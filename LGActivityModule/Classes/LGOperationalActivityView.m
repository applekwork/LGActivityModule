
//
//  LGOperationalActivityView.m
//  ActivityModule
//
//  Created by guomac on 2018/11/5.
//  Copyright © 2018年 guo. All rights reserved.
//

#import "LGOperationalActivityView.h"
#import "UIImageView+WebCache.h"
#import <Masonry/Masonry.h>

@interface LGOperationalActivityView()<UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UIButton    *closeBtn;
@property(nonatomic, strong) LGAdModel   *model;
@end

@implementation LGOperationalActivityView

- (instancetype)initWithAdModel:(LGAdModel *)model{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.model = model;
        [self addSubview:self.imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self.mas_left).offset(42.5);
            make.right.equalTo(self.mas_right).offset(-42.5);
            make.height.mas_equalTo(380);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipAction)];
        tap.delegate = self;
        [self.imgView addGestureRecognizer:tap];
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(45);
            make.centerX.equalTo(self.imgView);
        }];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.adUrl]];
    }
    return self;
}
#pragma mark - 点击时间相关处理 -
- (void)skipAction {
    if (self.model.redirectUrl && self.model.redirectUrl.length > 0) {
        [self removeFromSuperview];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(jumpDetailWithAdModel:)]){
        [_delegate jumpDetailWithAdModel:self.model];
    }
}
- (void)closeBtnAction {
    [self removeFromSuperview];
    if (_delegate && [_delegate respondsToSelector:@selector(activityViewCloseWithAdModel:)]){
        [_delegate activityViewCloseWithAdModel:self.model];
    }
}
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleURL = [bundle URLForResource:@"OperationalActivity" withExtension:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithURL: bundleURL];
        UIImage *img = [UIImage imageNamed:@"close" inBundle:resourceBundle compatibleWithTraitCollection:nil];
        [_closeBtn setImage:img forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
@end
