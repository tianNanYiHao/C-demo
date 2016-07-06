//
//  PaywayView.m
//  QuickPos
//
//  Created by kuailefu on 16/6/23.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "PaywayView.h"
#import "Common.h"
@interface PaywayView()
@property (nonatomic, strong) UIImageView *rightImageA;
@property (nonatomic, strong) UIImageView *rightImageB;
@property (nonatomic, strong) UIImageView *rightImageC;
@property (nonatomic, strong) UIView *whileView;
@end
@implementation PaywayView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //底部图
        UIView *bottom = [[UIView alloc]initWithFrame:self.bounds];
        bottom.backgroundColor  = [Common hexStringToColor:@"000000"];
        bottom.alpha = 0.6;
        [self addSubview:bottom];
        
        //白底
        self.whileView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 260)];
        [UIView animateWithDuration:0.5 animations:^{
            self.whileView.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-260, CGRectGetWidth(self.bounds), 260);
        }];
        
        
        self.whileView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.whileView];
        
        //关闭按钮
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
        [closeBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.whileView addSubview:closeBtn];
        
        //提示文字
        UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, CGRectGetWidth(self.bounds)-20, 30)];
        tip.text = @"选择支付方式";
        tip.font = [UIFont systemFontOfSize:13];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.textColor = [Common hexStringToColor:@"444444"];
        [self.whileView addSubview:tip];
        
        //线
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(12, 40, CGRectGetWidth(self.bounds), 0.5)];
        line1.backgroundColor = [Common hexStringToColor:@"e5e5e5"];
        [self.whileView addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(12, 85, CGRectGetWidth(self.bounds), 0.5)];
        line2.backgroundColor = [Common hexStringToColor:@"e5e5e5"];
        [self.whileView addSubview:line2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(12, 85+45, CGRectGetWidth(self.bounds), 0.5)];
        line3.backgroundColor = [Common hexStringToColor:@"e5e5e5"];
        [self.whileView addSubview:line3];
        
        UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(12, 85+45+45, CGRectGetWidth(self.bounds), 0.5)];
        line4.backgroundColor = [Common hexStringToColor:@"e5e5e5"];
        [self.whileView addSubview:line4];
        
        
        //左边图片
        CGFloat width = 20;
        CGFloat height = 20;
        UIImageView *imageA = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, width, height)];
        imageA.image = [UIImage imageNamed:@"ZHCZ_icon1"];
        [self.whileView addSubview:imageA];
        
        UIImageView *imageB = [[UIImageView alloc]initWithFrame:CGRectMake(10, 95, width, height)];
        imageB.image = [UIImage imageNamed:@"ZHCZ_icon3"];
        [self.whileView addSubview:imageB];
        
        UIImageView *imageC = [[UIImageView alloc]initWithFrame:CGRectMake(10, 145, width, height)];
        imageC.image = [UIImage imageNamed:@"ZHCZ_icon2"];
        [self.whileView addSubview:imageC];
        
        //右边图片
        width = 13;
        height = 10;
        self.rightImageA = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 30, 55, width, height)];
        self.rightImageA.image = [UIImage imageNamed:@"selected"];
        [self.whileView addSubview:self.rightImageA];
        self.rightImageB = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 30, 100, width, height)];
        self.rightImageB.image = [UIImage imageNamed:@"selected"];
        [self.whileView addSubview:self.rightImageB];
        self.rightImageC = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 30, 150, width, height)];
        self.rightImageC.image = [UIImage imageNamed:@"selected"];
        [self.whileView addSubview:self.rightImageC];
        self.rightImageA.hidden = NO;
        self.rightImageB.hidden = YES;
        self.rightImageC.hidden = YES;
        
        //中间文字
        UIButton *tipA = [[UIButton alloc] initWithFrame:CGRectMake(40, 50, CGRectGetWidth(self.bounds) - 90, 23)];
        [tipA setTitle:@"刷卡支付" forState:UIControlStateNormal];
        tipA.tag = 1001;
        tipA.titleLabel.font = [UIFont systemFontOfSize:13];
        tipA.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [tipA setTitleColor:[Common hexStringToColor:@"444444"] forState:UIControlStateNormal];
        [tipA addTarget:self action:@selector(acitonBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.whileView addSubview:tipA];
        
        UIButton *tipB = [[UIButton alloc] initWithFrame:CGRectMake(40, 95, CGRectGetWidth(self.bounds) - 90, 23)];
        [tipB setTitle:@"账户支付" forState:UIControlStateNormal];
        tipB.tag = 1002;
        tipB.titleLabel.font = [UIFont systemFontOfSize:13];
        tipB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [tipB setTitleColor:[Common hexStringToColor:@"444444"] forState:UIControlStateNormal];
        [tipB addTarget:self action:@selector(acitonBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.whileView addSubview:tipB];
        
        UIButton *tipC = [[UIButton alloc] initWithFrame:CGRectMake(40, 145, CGRectGetWidth(self.bounds) - 90, 23)];
        [tipC setTitle:@"快捷支付" forState:UIControlStateNormal];
        tipC.tag = 1003;
        tipC.titleLabel.font = [UIFont systemFontOfSize:13];
        tipC.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [tipC setTitleColor:[Common hexStringToColor:@"444444"] forState:UIControlStateNormal];
        [tipC addTarget:self action:@selector(acitonBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.whileView addSubview:tipC];
        
    }
    return self;
}
- (void)closeView:(UIButton *)btn{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.whileView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 260);
    } completion:^(BOOL finished) {
           [self removeFromSuperview];
    }];
}
- (void)acitonBtn:(UIButton*)btn{
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    if ([tag isEqualToString:@"1001"]) {
        self.rightImageA.hidden = NO;
        self.rightImageB.hidden = YES;
        self.rightImageC.hidden = YES;
        
    }
    if ([tag isEqualToString:@"1002"]) {
        self.rightImageA.hidden = YES;
        self.rightImageB.hidden = NO;
        self.rightImageC.hidden = YES;
        
    }
    if ([tag isEqualToString:@"1003"]) {
        self.rightImageA.hidden = YES;
        self.rightImageB.hidden = YES;
        self.rightImageC.hidden = NO;
        
    }
    [self.delegate paywayViewFinishTag:btn.tag];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}
@end
