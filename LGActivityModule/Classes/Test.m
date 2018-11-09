//
//  Test.m
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import "Test.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
typedef void(^LGWebViewBridgeCallback)(NSString *result, BOOL completed);
@interface Test ()
@property(nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
@end
@implementation Test
//监听网络
- (NSString *)monitorNetStatus {
    [self.reachabilityManager startMonitoring];
    AFNetworkReachabilityStatus status = self.reachabilityManager.networkReachabilityStatus;
    NSString *statusStr;
    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
        statusStr = @"wifi";
    } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = info.currentRadioAccessTechnology;
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
            statusStr = @"3G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
            statusStr = @"3G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
            statusStr = @"3G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
            statusStr = @"2G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
            statusStr = @"3G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
            statusStr = @"3G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
            statusStr = @"3G";
        }
        else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
            statusStr = @"4G";
        }
    } else if (status == AFNetworkReachabilityStatusUnknown) {
        statusStr =  @"未知网络";
    } else {
        statusStr = @"无网络";
    }
    return statusStr;
}
#pragma mark - 获取网络状态
- (void)getNetWorkType:(NSDictionary *)args callback:(LGWebViewBridgeCallback)callback {
    if (callback) {
        NSString *typeStr = [self monitorNetStatus];
        [self.reachabilityManager stopMonitoring];
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:0];
        [info setValue:typeStr forKey:@"type"];
//        [self returnResult:0 dic:info callback:callback];
    }
}

- (AFNetworkReachabilityManager *)reachabilityManager {
    if (!_reachabilityManager) {
        _reachabilityManager = [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    }
    return _reachabilityManager;
}
- (CMMotionManager *)motionManager
{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.1;   //加速计更新频率，以秒为单位
    }
    return _motionManager;
}
@end
