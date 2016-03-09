//
//  Tool.m
//  跳转系统控制界面
//
//  Created by Aotu on 15/12/9.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+(UIButton*)createButtonWitFrame:(CGRect)frame andColor:(UIColor *)color target:(id)target sel:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    btn.backgroundColor = color;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}

@end
