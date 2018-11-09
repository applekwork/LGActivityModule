//
//  LGOperationalActivityOpt.h
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGAdModel.h"

typedef void (^LGOperationalActivityBlock)(id result, NSError *error);

@interface LGOperationalActivityOpt : NSObject

//获取运营活动数据
+ (void)queryOperationalActivityListWithParam:(NSDictionary *)param  success:(void (^)(NSArray<LGAdModel *> *resultObj))success
                                         fail:(void (^)(NSString *errorStr))fail;


//上传活动ID到后台
+ (void)uploadOperationalActivityWithParam:(NSDictionary *)param;
@end
