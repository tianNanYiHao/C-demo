//
//  ViewController.m
//  UIStatusBar(状态栏) test
//
//  Created by Aotu on 15/12/2.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //ios 7以后 此方法不在通用 , statusBar 状态栏是根据具体的uiviewController 来调整 所以 提供了如下接口
    
    //
//    [self setNeedsStatusBarAppearanceUpdate]; //另一张出发方法
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    
    
}

#pragma mark - 系统自动调用
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;  //白色文字
    
}
//-(BOOL)prefersStatusBarHidden
//{
//    return YES;  //隐藏statusBar
//}


-(void)setNeedsStatusBarAppearanceUpdate
{

    [self preferredStatusBarStyle];
}
@end
