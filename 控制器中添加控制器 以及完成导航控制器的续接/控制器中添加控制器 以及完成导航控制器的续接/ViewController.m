//
//  ViewController.m
//  控制器中添加控制器 以及完成导航控制器的续接
//
//  Created by Aotu on 15/12/24.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "orangViewController.h"
@interface ViewController ()
{
  
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"根控制器";
    self.view.backgroundColor = [UIColor redColor];
    
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor cyanColor]];
  
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(30, 30, 100, 100);
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    
}

-(void)click
{
    orangViewController *o = [[orangViewController alloc] init];
    [self.navigationController pushViewController:o animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
