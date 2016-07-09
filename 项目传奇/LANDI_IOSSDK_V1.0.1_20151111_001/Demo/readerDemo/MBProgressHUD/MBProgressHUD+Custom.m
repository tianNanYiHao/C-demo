//
//  MBProgressHUD+Custom.m
//  Lakala
//
//  Created by  on 12-11-6.
//  Copyright (c) 2012年 lakala.com. All rights reserved.
//

#import "MBProgressHUD+Custom.h"
#import "AppDelegate.h"
#define MBPROGRESSHUD_PROMPT_DELAY 1.2
#define MAIN_WINDOW [(AppDelegate *)[[UIApplication sharedApplication] delegate] window]

@implementation MBProgressHUD (Custom)

+ (void)show
{
    [MBProgressHUD showHUDAddedTo:MAIN_WINDOW animated:YES];
}

+ (void)show:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.hud = [MBProgressHUD showHUDAddedTo:MAIN_WINDOW animated:YES];
        appDelegate.hud.labelText = text;
    });
}

+ (void)hide
{
    [MBProgressHUD hideAllHUDsForView:MAIN_WINDOW animated:YES];
}

+ (void)prompt:(NSString*)text yOffset:(NSInteger)yOffset
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:MAIN_WINDOW animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.yOffset = yOffset;
    [hud hide:YES afterDelay:MBPROGRESSHUD_PROMPT_DELAY];
}

+ (void)prompt:(NSString*)text
{
    [self prompt:text yOffset:-32];
}

+ (void)promptNetFailed
{
    [self prompt:@"网络请求失败"];
}

+ (void)promptDataError
{
    [self prompt:@"异常数据"];
}

+ (void)promptNoMoreData
{
    [self prompt:@"没有更多的数据了！"];
}

@end
