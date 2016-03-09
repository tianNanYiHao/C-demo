//
//  ViewController.m
//  跳转系统控制界面
//
//  Created by Aotu on 15/12/9.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "Tool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    http://www.cocoachina.com
//    http://www.cocoachina.com/ios/20151209/14547.html  跳转各个系统控制页面的合集
    
    
    
    
    //跳转到设置
    UIButton *btn = [Tool createButtonWitFrame:CGRectMake(0, 20, 100, 100) andColor:[UIColor redColor] target:self sel:@selector(click)];
    [self.view addSubview:btn];
    
//    //跳转到WIFI  //5.0已禁用
//    UIButton *btnWIFI = [Tool createButtonWitFrame:CGRectMake(100, 20, 100, 100) andColor:[UIColor orangeColor] target:self sel:@selector(click1)];
//    [self.view addSubview:btnWIFI];
    
    
    
}

-(void)click
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

////无效方法
//-(void)click1
//{
//    
//    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
//    if ([[UIApplication sharedApplication] canOpenURL:url])
//    {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//}
@end
