//
//  LGHttpTool.h
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#define POSTSTR @"POST"
#define GETSTR  @"GET"
#define NO_NET @"NO_NET"

@interface LGHttpTool : NSObject

+ (NSURLSessionDataTask *)myOriRequestWithBaseUrl:(NSString *)baseUrl
                                           urlStr:(NSString *)urlStr
                                           method:(NSString *)methodStr
                                       parameters:(NSDictionary *)parameters
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

+ (NSURLSessionDataTask *)myRequestWithBaseUrl:(NSString *)baseUrl
                                        urlStr:(NSString *)urlStr
                                        method:(NSString *)methodStr
                                    parameters:(NSDictionary *)parameters
                                       success:(void (^)(NSObject *resultObj))success
                                          fail:(void (^)(NSString *errorStr))fail;
@end
