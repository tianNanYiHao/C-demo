//
//  orangViewController.m
//  控制器中添加控制器 以及完成导航控制器的续接
//
//  Created by Aotu on 15/12/24.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "orangViewController.h"
#import "newViewController.h"
@interface orangViewController ()
{
      newViewController *_viewC;
}
@end

@implementation orangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"初始的控制器";
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
 
    
    //1.添加一个新的控制器Controller
    _viewC = [[newViewController alloc] init];
    
    _viewC.view.frame = CGRectMake(30, 30, 300, 500);
    
    //2.此时,如果只是添加上新Controller的view 并不能让导航控制器也导入
    [self.view addSubview:_viewC.view];
    
    //3.因此,还需在根viewController中添加上 子控制器 (newController 作为Viewcontroller 的自控制器)
    [self addChildViewController:_viewC];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
