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
#pragma mark - 关闭监听网络
- (void)stopNetWorkStatus:(NSDictionary *)args callback:(YTWebViewBridgeCallback)callback {
    if (callback) {
        [self.reachabilityManager stopMonitoring];
        [self returnResult:0 callback:callback];
    }
}
#pragma mark - 开始监听加速度计状态
- (void)startAccelerometer:(NSDictionary *)args callback:(YTWebViewBridgeCallback)callback {
    if (callback) {
        if (![self.motionManager isAccelerometerAvailable]) {
            //加速计不可用
            NSLog(@"Accelerometer is not Available");
            return;
        }
        [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            //获取加速度
            CMAcceleration acceleration = accelerometerData.acceleration;
            NSLog(@"加速度 == x:%f, y:%f, z:%f", fabs(acceleration.x), fabs(acceleration.y), fabs(acceleration.z));
            //值越大说明摇动的幅度越大
            double num = 1.5f;
            if (fabs(acceleration.x) > num || fabs(acceleration.y) > num ||fabs(acceleration.z) > num) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:0];
                    [info setValue:@(acceleration.x) forKey:@"x"];
                    [info setValue:@(acceleration.y) forKey:@"y"];
                    [info setValue:@(acceleration.z) forKey:@"z"];
//                    [self returnResult:0 dic:info callback:callback];
                });
            }
        }];
    }
}
#pragma mark - 停止监听加速度计状态
- (void)stopAccelerometer:(NSDictionary *)args callback:(YTWebViewBridgeCallback)callback {
    if (callback) {
        if ([self.motionManager isAccelerometerActive]) {
            [self.motionManager stopAccelerometerUpdates];
//            [self returnResult:0 callback:callback];
        }
    }
}
#pragma mark - 设置系统剪切板内容
- (void)setClipboardData:(NSDictionary *)args callback:(YTWebViewBridgeCallback)callback {
    if (callback) {
        NSString *pasterStr = [args valueForKey:@"data"];
        if (pasterStr && pasterStr.length > 0) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = pasterStr;
//            [self returnResult:0 callback:callback];
        } else {
//            [self returnResult:1 callback:callback];
        }
    }
}
#pragma mark - 获取系统剪切板内容
- (void)getClipboardData:(NSDictionary *)args callback:(YTWebViewBridgeCallback)callback {
    if (callback) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        NSString *pasterStr = pasteboard.string;
        if (pasterStr && pasterStr.length > 0) {
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:0];
            [info setValue:pasterStr forKey:@"content"];
//            [self returnResult:0 dic:info callback:callback];
        } else {
//            [self returnResult:1 callback:callback];
        }
    }
}
- (void)returnResult:(NSInteger)code callback:(YTWebViewBridgeCallback)callback {
    [self returnResult:code value:nil callback:callback];
}

- (void)returnResult:(NSInteger)code data:(NSString *)data callback:(YTWebViewBridgeCallback)callback {
    [self returnResult:code value:data callback:callback];
}

- (void)returnResult:(NSInteger)code dic:(NSDictionary *)dic callback:(YTWebViewBridgeCallback)callback {
    [self returnResult:code value:dic callback:callback];
}

- (void)returnResult:(NSInteger)code array:(NSArray *)array callback:(YTWebViewBridgeCallback)callback {
    [self returnResult:code value:array callback:callback];
}

- (void)returnResult:(NSInteger)code value:(id)value callback:(YTWebViewBridgeCallback)callback {
    if (callback) {
        if (!value) {
            value = @{};
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        [param setObject:[NSNumber numberWithInteger:code] ?: @(1) forKey:@"code"];
        [param setObject:value forKey:@"data"];
        NSString *json = [param JSONLocalString];
        callback(json, code);
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
