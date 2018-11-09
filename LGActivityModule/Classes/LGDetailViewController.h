//
//  LGDetailViewController.h
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGDetailViewController : UIViewController
@property (nonatomic, copy) void(^goBlock)(void);
- (instancetype)initWithUrl:(NSString* )urlStr;
@end
