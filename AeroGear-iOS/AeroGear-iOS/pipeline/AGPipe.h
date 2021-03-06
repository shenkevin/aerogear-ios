/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
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

#import <Foundation/Foundation.h>

/**
 * AGPipe represents a server connection. An object of this class is responsible to
 * communicate with the server and perfoms read/write operations.
 */
@protocol AGPipe <NSObject>

/**
 * Returns the type of the underlying 'pipe implementation'
 */
@property (nonatomic, readonly) NSString* type;

/**
 * Returns the url string of the underlying 'pipe implementation'
 */
@property (nonatomic, readonly) NSURL* URL;

/**
 * Reads all the data from the underlying server connection.
 *
 * @param success A block object to be executed when the request operation finishes successfully.
 * This block has no return value and takes one argument: The object created from the response
 * data of request.
 *
 * @param failure A block object to be executed when the request operation finishes unsuccessfully,
 * or that finishes successfully, but encountered an error while parsing the resonse data.
 * This block has no return value and takes one argument: The `NSError` object describing
 * the network or parsing error that occurred.
 */
-(void) read:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 * Read specific object from the underlying server connection.
 *
 * @param value The value of the recordId. See property [AGPipeConfig recordId]
 *
 * @param success A block object to be executed when the request operation finishes successfully.
 * This block has no return value and takes one argument: The object created from the response
 * data of request.
 *
 * @param failure A block object to be executed when the request operation finishes unsuccessfully,
 * or that finishes successfully, but encountered an error while parsing the resonse data.
 * This block has no return value and takes one argument: The `NSError` object describing
 * the network or parsing error that occurred.
 */
-(void) read:(id)value
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 * Reads all the data that matches a given parameter provider from the underlying server connection.
 *
 * @param parameterProvider A dictionary containing all the parameters and their values, that are 
 * passed to the server. If no parameterProvider is given, the defaults from the `AGPipeConfig` 
 * are used.
 *
 * @param success A block object to be executed when the request operation finishes successfully.
 * This block has no return value and takes one argument: The object created from the response
 * data of request.
 *
 * @param failure A block object to be executed when the request operation finishes unsuccessfully,
 * or that finishes successfully, but encountered an error while parsing the response data.
 * This block has no return value and takes one argument: The `NSError` object describing
 * the network or parsing error that occurred.
 */
-(void) readWithParams:(NSDictionary*)parameterProvider
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;


/**
 * Saves (or updates) a given object from the underlying server connection.
 *
 * @param object a 'JSON' map, representing the data to save/update
 *
 * @param success A block object to be executed when the request operation finishes successfully.
 * This block has no return value and takes one argument: The object created from the response
 * data of request.
 *
 * @param failure A block object to be executed when the request operation finishes unsuccessfully,
 * or that finishes successfully, but encountered an error while parsing the response data.
 * This block has no return value and takes one argument: The `NSError` object describing
 * the network or parsing error that occurred.
 */
-(void) save:(NSDictionary*) object
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

/**
 * Removes an object from the underlying server connection.
 *
 *
 * @param object a 'JSON' map, representing the data to remove. Note the map must have the
 * 'recordId' key set. See property [AGPipeConfig recordId]
 *
 * @param success A block object to be executed when the request operation finishes successfully.
 * This block has no return value and takes one argument: The object created from the response
 * data of request.
 *
 * @param failure A block object to be executed when the request operation finishes unsuccessfully,
 * or that finishes successfully, but encountered an error while parsing the response data.
 * This block has no return value and takes one argument: The `NSError` object describing
 * the network or parsing error that occurred.
 */
-(void) remove:(NSDictionary*) object
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

/**
 * Cancel all running pipe operations. Any registered callbacks on the pipe are NOT executed.
 * It is your responsibility to provide any neccessary cleanups after calling this method.
 * 
 * Note: Calling cancel has no effect on the server, so if you do a save or remove and then
 * call cancel, that action will still take place on the the server.
 *
 */
-(void) cancel;

@end