//
//  LGOperationalActivityManager.m
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import "LGOperationalActivityManager.h"
#import "LGOperationalActivityOpt.h"
#import "LGOperationalActivityView.h"
#import "LGDetailViewController.h"
@interface LGOperationalActivityManager()
@property (nonatomic, copy)   NSString          *url;
@property (nonatomic, strong) NSDictionary      *param;
@property (nonatomic, strong) NSMutableArray    *adArr;
@end

static LGOperationalActivityManager *shareManager;
@implementation LGOperationalActivityManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[LGOperationalActivityManager alloc]init];
    });
    return shareManager;
}
#pragma mark - <LGOperationalActivityViewDelegate>
- (void)jumpDetailWithAdModel:(LGAdModel *)model {
    if (model.redirectUrl && model.redirectUrl.length > 0) {
        LGDetailViewController *vc = [[LGDetailViewController alloc]initWithUrl:model.redirectUrl];
        vc.goBlock = ^{
            if ([self.adArr count] > 0) {
                [self showActivityViewWithModel:self.adArr[0]];
            }
        };
        UINavigationController *nav = [self currentTabbarSelectedNavigationController];
        if (nav) [nav pushViewController:vc animated:YES];
    }
    [self uploadAdId:model.adId];
}
-(void)activityViewCloseWithAdModel:(LGAdModel *)model {
    if ([self.adArr count] > 0) {
        [self showActivityViewWithModel:self.adArr[0]];
    }
    [self uploadAdId:model.adId];
}
- (void)showActivityViewWithModel:(LGAdModel *)model{
    LGOperationalActivityView *adView = [[LGOperationalActivityView alloc]initWithAdModel:model];
    adView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:adView];
    [self.adArr removeObjectAtIndex:0];
}
- (void)activityManagerWithParam:(NSDictionary *)param{
    self.param = param;
    [LGOperationalActivityOpt queryOperationalActivityListWithParam:param success:^(NSArray<LGAdModel *> *resultObj) {
        if ([resultObj count] > 0) {
            [self.adArr addObjectsFromArray:resultObj];
            [self showActivityViewWithModel:resultObj[0]];
        }
    } fail:^(NSString *errorStr) {
        NSLog(@"%@",errorStr);
    }];
}
- (void)uploadAdId:(NSString *)adId {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
    [param setValue:self.param[@"empNo"] forKey:@"empNo"];
    [param setValue:self.param[@"BaseUrl"] forKey:@"BaseUrl"];
    [param setValue:self.param[@"CloseAdUrl"] forKey:@"CloseAdUrl"];
    [param setValue:adId forKey:@"adId"];
    [LGOperationalActivityOpt uploadOperationalActivityWithParam:param];
}
- (UINavigationController *)currentTabbarSelectedNavigationController {
    UITabBarController *tabbarController = [self tabbarController];
    UINavigationController *selectedNV = tabbarController.selectedViewController;
    if ([selectedNV isKindOfClass:[UINavigationController class]]) {
        return selectedNV;
    }
    return nil;
}
-(UITabBarController *)tabbarController
{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *tabbarController = window.rootViewController;
    if ([tabbarController isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabbarController;
    }
    return nil;
    
}
- (NSMutableArray *)adArr {
    if (!_adArr) {
        _adArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _adArr;
}
@end
