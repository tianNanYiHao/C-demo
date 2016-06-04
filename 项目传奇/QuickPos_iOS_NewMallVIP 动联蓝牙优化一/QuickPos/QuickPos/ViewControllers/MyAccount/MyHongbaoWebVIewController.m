//
//  MyHongbaoWebVIewController.m
//  QuickPos
//
//  Created by Aotu on 16/1/26.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "MyHongbaoWebVIewController.h"

@interface MyHongbaoWebVIewController ()
{
    UIWebView *_webView;
    
}
@end

@implementation MyHongbaoWebVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = @"我的红包";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://112.65.206.146:8000/get/account/redpacket?appuser=bmqhchqvip&userid=%@",[AppDelegate getUserBaseData].mobileNo]];
    NSLog(@"%@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _webView.scrollView.bounces = YES;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"jiantou"];
    
    
}


- (void)backAction:(UIButton*)btn{
    
    if ([self.title isEqualToString:@"我的红包"]) {
        [self.navigationController popViewControllerAnimated:YES];
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
