//
//  KdwViewController.m
//  CustomAlertView
//
//  Created by YHIOS001 on 16/10/10.
//  Copyright © 2016年 YH_kongdw. All rights reserved.
//

#import "KdwViewController.h"
#import "AlertView.h"
#import "Alert.h"
#import "AlertLoading.h"
#import <objc/runtime.h>
static char* const networkLoadingView_KEY = "networkLoadingView";
@interface KdwViewController ()
@property (nonatomic,strong) UIView *networkLoadingView;
@end

@implementation KdwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
- (void)setNetworkLoadingView:(UIView *)networkLoadingView
{
    objc_setAssociatedObject(self,networkLoadingView_KEY,networkLoadingView,OBJC_ASSOCIATION_RETAIN);
    
}

- (UIView *)networkLoadingView
{
    return objc_getAssociatedObject(self,networkLoadingView_KEY);
}


-(void)initUI
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake((self.view.frame.size.width-100)/2, 100, 100, 30)];
    [btn1 setTitle:@"AlertView1" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake((self.view.frame.size.width-100)/2, 200, 100, 30)];
    [btn2 setTitle:@"AlertView2" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake((self.view.frame.size.width-100)/2, 300, 100, 30)];
    [btn3 setTitle:@"AlertView3" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn4 setFrame:CGRectMake((self.view.frame.size.width-100)/2, 400, 100, 30)];
    [btn4 setTitle:@"Alert" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn5 setFrame:CGRectMake((self.view.frame.size.width-100)/2, 500, 100, 30)];
    [btn5 setTitle:@"AlertLoading" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(clickBtn5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];

}


-(void)clickBtn1
{
    AlertView *alertView = [[AlertView alloc]initWithTitle:@"提示" andMessage:@"美女你走光了！"] ;
    [alertView addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeCancel handler:nil];
    [alertView show];
}

-(void)clickBtn2
{
    AlertView *alertView = [[AlertView alloc]initWithTitle:@"提示" andMessage:@"美女,我来了！"] ;
    [alertView addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeCancel handler:nil];
    alertView.transitionStyle = CustomAlertViewTransitionStyleSlideFromTop;
    [alertView show];
}


-(void)clickBtn3
{
    AlertView *alertView = [[AlertView alloc]initWithTitle:@"提示" andMessage:@"美女，等等我！"] ;
    [alertView addButtonWithTitle:@"取消" type:CustomAlertViewButtonTypeDefault handler:nil];
    [alertView addButtonWithTitle:@"确定" type:CustomAlertViewButtonTypeCancel handler:nil];
    alertView.transitionStyle = CustomAlertViewTransitionStyleBounce;
    [alertView show];
}

-(void)clickBtn4
{
    [Alert show:@"呵呵！" hasSuccessIcon:YES AndShowInView:self.view];
}

-(void)clickBtn5
{
   self.networkLoadingView = [AlertLoading alertLoadingWithMessage:@"请稍后..." andFrame:CGRectMake((self.view.frame.size.width-130)/2, 100, 130, 100) isBelowNav:YES];
    
    [self.view addSubview:self.networkLoadingView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.networkLoadingView) {
        [self.networkLoadingView removeFromSuperview];
    }
    
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
