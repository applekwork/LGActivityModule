//
//  LGOperationalActivityView.h
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAdModel.h"

@protocol LGOperationalActivityViewDelegate<NSObject>

@optional
//关闭弹窗
-(void)activityViewCloseWithAdModel:(LGAdModel *)model;
//跳转详情
-(void)jumpDetailWithAdModel:(LGAdModel *)model;
@end

@interface LGOperationalActivityView : UIView

@property (nonatomic, weak) id <LGOperationalActivityViewDelegate> delegate;

- (instancetype)initWithAdModel:(LGAdModel *)model;
@end
