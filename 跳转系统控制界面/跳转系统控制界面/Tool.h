//
//  Tool.h
//  跳转系统控制界面
//
//  Created by Aotu on 15/12/9.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Tool : NSObject


+(UIButton*)createButtonWitFrame:(CGRect)frame andColor:(UIColor*)color target:(id)target sel:(SEL)sel;


@end
