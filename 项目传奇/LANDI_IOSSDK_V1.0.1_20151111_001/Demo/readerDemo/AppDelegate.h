//
//  AppDelegate.h
//  readerDemo
//
//  Created by lvv on 14-3-11.
//  Copyright (c) 2014年 landi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD/MBProgressHUD+Custom.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MBProgressHUD *hud; // 公共转圈圈

@end
