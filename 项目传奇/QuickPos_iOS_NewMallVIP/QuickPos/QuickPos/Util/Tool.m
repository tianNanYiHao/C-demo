//
//  Tool.m
//  QuickPos
//
//  Created by Aotu on 15/11/10.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+(void)setobject:(id)obj forkey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(id)objectforkey:(NSString *)key
{
    return  [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
}

+(UILabel*)createLabWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)color
{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.textColor = color;
    lab.font = font;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = title;
    
    return lab;
    
    
}

+(UIImageView*)createImageWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    
    UIImageView *imageVI = [[UIImageView alloc] initWithFrame:frame];
    imageVI.image = [UIImage imageNamed:imageName];
    
    return imageVI;
}

+(UIView*)createViewWithFrame:(CGRect)frame background:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
    
}
+(UIButton*)createBtnWithFrame:(CGRect)frame backgroudColor:(UIColor *)color title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor target:(id)taget select:(SEL)select
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    btn.backgroundColor = color;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn addTarget:taget action:select forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
    
}

+(void)addAlertwithTitle:(NSString*)title msg:(NSString*)msg cancle:(NSString*)cancle sure:(NSString*)sure defultBlock:(defultBlock)defultB cancleBlock:(cancleBlock)cancleB viewController:(UIViewController*)viewController tag:(int)tag{
    
    if (iOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            defultB(action);
        }];
        
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            cancleB(action);
        }];
        
        [alertController addAction:actionSure];
        [alertController addAction:actionCancle];
        [viewController presentViewController:alertController animated:YES completion:nil];
        
    }
    else{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:viewController cancelButtonTitle:cancle otherButtonTitles:sure, nil];
        alerView.tag = (int)tag;
        [alerView show];
        
        
        
    }
    
    
}

@end
