//
//  LGHttpTool.m
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import "LGHttpTool.h"

@implementation LGHttpTool

+ (NSURLSessionDataTask *)myOriRequestWithBaseUrl:(NSString *)baseUrl
                                           urlStr:(NSString *)urlStr
                                           method:(NSString *)methodStr
                                       parameters:(NSDictionary *)parameters
                                completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:methodStr URLString:[NSString stringWithFormat:@"%@%@",baseUrl,urlStr] parameters:parameters error:nil];
//        [request setValue:@"application/json;charset=utf-8;text/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 15;
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil  completionHandler:completionHandler];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionDataTask *)myRequestWithBaseUrl:(NSString *)baseUrl
                                        urlStr:(NSString *)urlStr
                                        method:(NSString *)methodStr
                                    parameters:(NSDictionary *)parameters
                                       success:(void (^)(NSObject *resultObj))success
                                          fail:(void (^)(NSString *errorStr))fail{
    return [self myOriRequestWithBaseUrl:baseUrl urlStr:urlStr method:methodStr parameters:parameters completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (error.code == -1001) {
                if(fail)fail(@"请求超时");
                return;
            }
            if(fail)fail(@"网络异常");//网络链接问题或者请求地址有误
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                if(success)success(dic);
                return;
            }else{
                if(fail)fail(@"请求失败");//返回数据格式错误
            }
        }
    }];
}

@end
