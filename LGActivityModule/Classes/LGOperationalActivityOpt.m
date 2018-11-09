//
//  LGOperationalActivityOpt.m
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import "LGOperationalActivityOpt.h"
#import "LGOperationalActivityManager.h"
#import "LGHttpTool.h"
#import "LGAdModel.h"
#import <YYModel/YYModel.h>
@interface LGOperationalActivityOpt()

@end

@implementation LGOperationalActivityOpt
+ (void)queryOperationalActivityListWithParam:(NSDictionary *)param success:(void (^)(NSArray<LGAdModel *> *))success fail:(void (^)(NSString *))fail {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:param[@"appId"] forKey:@"appId"];
    [dict setValue:param[@"position"] forKey:@"position"];
    [dict setValue:param[@"empNo"] forKey:@"empNo"];
    [LGHttpTool myRequestWithBaseUrl:param[@"BaseUrl"] urlStr:param[@"AdUrl"] method:POSTSTR parameters:dict success:^(NSObject *resultObj) {
        if (resultObj && [resultObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)resultObj;
            NSArray *arr = [NSArray yy_modelArrayWithClass:[LGAdModel class] json:dic[@"data"]];
            success(arr);
        }
    } fail:^(NSString *errorStr) {
        fail(errorStr);
    }];
}
+ (void)uploadOperationalActivityWithParam:(NSDictionary *)param {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:param[@"empNo"] forKey:@"empNo"];
    [dict setValue:param[@"adId"] forKey:@"adId"];
    [LGHttpTool myRequestWithBaseUrl:param[@"BaseUrl"] urlStr:param[@"CloseAdUrl"] method:POSTSTR parameters:dict success:^(NSObject *resultObj) {
    } fail:^(NSString *errorStr) {
    }];
}
@end
