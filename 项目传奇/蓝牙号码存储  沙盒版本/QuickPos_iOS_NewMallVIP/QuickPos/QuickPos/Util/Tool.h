//
//  Tool.h
//  QuickPos
//
//  Created by Aotu on 15/11/10.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^defultBlock) (id defult);
typedef void(^cancleBlock) (id cancle);


@interface Tool : NSObject

+(void)setobject:(id)obj forkey:(NSString*)key;

+(id)objectforkey:(NSString*)key;

+(UILabel*)createLabWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font color:(UIColor *)color;

+(UIImageView*)createImageWithFrame:(CGRect)frame imageName:(NSString *)imageName;

+(UIView*)createViewWithFrame:(CGRect)frame background:(UIColor *)color;

+(UIButton*)createBtnWithFrame:(CGRect)frame backgroudColor:(UIColor *)color title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor target:(id)taget select:(SEL)select;

+(void)addAlertwithTitle:(NSString*)title msg:(NSString*)msg cancle:(NSString*)cancle sure:(NSString*)sure defultBlock:(defultBlock)defultB cancleBlock:(cancleBlock)cancleB viewController:(UIViewController*)viewController tag:(int)tag;



@end
