//
//  LGOperationalActivityManager.h
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGOperationalActivityManager : NSObject

+ (instancetype)shareInstance;

- (void)activityManagerWithParams:(NSDictionary *)param;
@end
