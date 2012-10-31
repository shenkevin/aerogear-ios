/*
 * JBoss, Home of Professional Open Source.
 * Copyright 2012 Red Hat, Inc., and individual contributors
 * as indicated by the @author tags.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AGAuthenticator.h"
#import "AGRestAuthentication.h"
#import "AGAuthConfiguration.h"

@implementation AGAuthenticator {
    NSMutableDictionary* _modules;
}

- (id)init {
    self = [super init];
    if (self) {
        _modules = [NSMutableDictionary dictionary];
    }
    return self;
}

+(id) authenticator {
    return [[self alloc] init];
}

-(id<AGAuthenticationModule>) add:(void (^)(id<AGAuthConfig> config)) config {
    
    AGAuthConfiguration* pipeConfig = [[AGAuthConfiguration alloc] init];
    
    if (config) {
        config(pipeConfig);
    }
    
    NSString* name  = [pipeConfig name];
    NSString* type = [pipeConfig type];
    NSURL* baseURL = [pipeConfig baseURL];
    
    return [self add:name baseURL:baseURL type:type];
}

// private helper
-(id<AGAuthenticationModule>)add:(NSString*) moduleName baseURL:(NSURL*)baseURL type:(NSString*) type {
    // TODO check ALL supported types...
    if (! [type isEqualToString:@"REST"]) {
        return nil;
    }

    id<AGAuthenticationModule> module = [AGRestAuthentication moduleForBaseURL:baseURL];
    [_modules setValue:module forKey:moduleName];
    return module;
}

-(id<AGAuthenticationModule>)remove:(NSString*) moduleName {
    id<AGAuthenticationModule> module = [self get:moduleName];
    [_modules removeObjectForKey:moduleName];
    return module;
}

-(id<AGAuthenticationModule>)get:(NSString*) moduleName {
    return [_modules valueForKey:moduleName];
}

-(NSString *) description {
    return [NSString stringWithFormat: @"%@ %@", self.class, _modules];
}

@end