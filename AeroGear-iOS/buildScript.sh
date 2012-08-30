#!/bin/sh
#
# JBoss, Home of Professional Open Source
# Copyright ${year}, Red Hat, Inc., and individual contributors
# by the @authors tag. See the copyright.txt in the distribution for a
# full listing of individual contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## NOTE set the 'build dir' to the 'Workspace-relative' folder 'build' (in Xcode: File->Workspace Settings...)

## clean up the previous builds...
echo "Clean up (rm -rf build/)"
rm -rf build/

## build for the ARM arch:
echo "Building for the iOS SDK (ARM arch.)"
xcodebuild -scheme AeroGear-iOS -sdk iphoneos -workspace AeroGear-iOS.xcworkspace -configuration Release clean build

## Simulator: this matches what we have in Jenkins as well (currently only local, on matzew's machine)
echo "Building for the iphonesimulator SDK and executing tests"
xcodebuild -scheme AeroGear-iOSTests -sdk iphonesimulator -workspace AeroGear-iOS.xcworkspace -configuration Release clean build TEST_AFTER_BUILD=YES


## Generate universal binary for the device and simulator
mkdir build/universal
mkdir build/universal/Headers
SIMULATOR_LIB="build/AeroGear-iOS/Build/Products/Release-iphonesimulator/libAeroGear-iOS.a"
DEVICE_LIB="build/AeroGear-iOS/Build/Products/Release-iphoneos/libAeroGear-iOS.a"
lipo ${SIMULATOR_LIB} ${DEVICE_LIB} -create -output build/universal/libAeroGear-iOS.a

## copy header files
cp -r build/AeroGear-iOS/Build/Products/Release-iphoneos/include/AeroGear-iOS/ build/universal/Headers

## creating a 'simple' dist file (tarball)
pushd build/universal
tar cfvz ../../AeroGear-iOS.tgz *

popd

## Clean old appledoc
echo "Generating the API doc"
rm -rf ./Docset
## Run appledoc
appledoc --project-name AeroGear-iOS --project-company "Red Hat" --company-id org.jboss.aerogear --output ~/help --docset-install-path ./Docset ./AeroGear-iOS/ 