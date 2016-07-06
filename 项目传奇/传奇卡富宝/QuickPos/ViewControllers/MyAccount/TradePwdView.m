//
//  TradePwdView.m
//  QuickPos
//
//  Created by kuailefu on 16/6/7.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "TradePwdView.h"

// 屏幕bounds
#define ZCScreenBounds [UIScreen mainScreen].bounds

@implementation TradePwdView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:ZCScreenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //背景
        UIView *bottom = [[UIView alloc]initWithFrame:self.bounds];
        bottom.alpha = 0.7;
        bottom.backgroundColor  =[UIColor blackColor];
        [self addSubview:bottom];
        
        //白色底
        UIView *whieBottom = [[UIView alloc]initWithFrame:CGRectMake(25, 70, CGRectGetWidth(self.bounds) - 50, 170)];
        whieBottom.backgroundColor  = [UIColor whiteColor];
        whieBottom.layer.cornerRadius = 8;
        [self addSubview:whieBottom];
        
        //提示文字
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, CGRectGetWidth(whieBottom.bounds), 30)];
        title.text = @"输入支付密码";
        title.textColor = [UIColor lightGrayColor];
        title.textAlignment = NSTextAlignmentCenter;
        [whieBottom addSubview:title];
        
         //线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, 40, CGRectGetWidth(whieBottom.bounds) - 40, 1)];
        line.backgroundColor = [Common hexStringToColor:@"e5e5e5"];
        line.alpha = 0.5;
        [whieBottom addSubview:line];
        
        //显示金额
        self.amountMoney = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, CGRectGetWidth(whieBottom.bounds) - 40, 28)];
        [whieBottom addSubview:self.amountMoney];
        
        //输入框
        self.inputView = [[UITextField alloc]initWithFrame:CGRectMake(20, 70, CGRectGetWidth(whieBottom.bounds) - 40, 35)];
        self.inputView.layer.cornerRadius = 5;
        self.inputView.secureTextEntry = YES;
        self.inputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.inputView becomeFirstResponder];
        self.inputView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [whieBottom addSubview:self.inputView];
        
        CGFloat heightBtn = 35;
        //取消按钮
        UIButton *cancel  =[[UIButton alloc]initWithFrame:CGRectMake(20, 120, 110, heightBtn)];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[Common hexStringToColor:@"8e8e8e"] forState:UIControlStateNormal];
        cancel.layer.cornerRadius  = 5;
        cancel.backgroundColor = [Common hexStringToColor:@"F2F2F2"];
        [cancel addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [whieBottom addSubview:cancel];
        
        //支付按钮
        UIButton *comfirt  =[[UIButton alloc]initWithFrame:CGRectMake(140, 120, 110, heightBtn)];
        [comfirt setTitle:@"支付" forState:UIControlStateNormal];
        [comfirt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        comfirt.layer.cornerRadius  = 5;
        comfirt.backgroundColor = [Common hexStringToColor:@"14b9d5"];
        [comfirt addTarget:self action:@selector(tradePwdfinish) forControlEvents:UIControlEventTouchUpInside];
        [whieBottom addSubview:comfirt];
        
        
        
    }
    return self;
}
- (void)tradePwdfinish{

    if ([self.delegate respondsToSelector:@selector(tradePwdfinish:)]) {
       [self.delegate tradePwdfinish:self.inputView.text];
       [self removeFromSuperview];
    }
}
@end
