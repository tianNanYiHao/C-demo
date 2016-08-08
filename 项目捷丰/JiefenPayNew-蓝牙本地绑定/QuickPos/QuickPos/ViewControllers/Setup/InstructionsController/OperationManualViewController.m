//
//  OperationManualViewController.m
//  QuickPos
//
//  Created by feng Jie on 16/8/2.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "OperationManualViewController.h"

#define INFORMATION_URL @"http://122.144.198.81:7071/jfpay_display/image/help/"
@interface OperationManualViewController ()
{
    UIWebView *_webView;

}
@end

@implementation OperationManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"操作手册";
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",INFORMATION_URL,self.str];
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    
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
