//
//  ViewController.m
//  luageuC$EN
//
//  Created by Aotu on 15/12/8.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getCurrentLanguage];
    
    //    zh-Hans-US  7()   zh-Hans 真机
    //
    //    zh-Hans-US  9(模拟器)   zh-Hans-CN 真机
    
    
    //判断当前语言
    if ([[self getCurrentLanguage] isEqualToString:@"zh-Hans-CN"]||[[self getCurrentLanguage] isEqualToString:@"zh-Hans"]) {
        NSLog(@"这里是中文状态");
    }else
    {
        NSLog(@"这里是其他语言状态 具体自己去测");
    }
    
    //判断当前设备系统 ios789
     if([[[UIDevice currentDevice] systemVersion]floatValue]<8)
     {
         
     }else
     {
         
     }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取当前语言
- (NSString*)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];NSLog(@"%@",currentLanguage);
    return currentLanguage;
    
}
@end
