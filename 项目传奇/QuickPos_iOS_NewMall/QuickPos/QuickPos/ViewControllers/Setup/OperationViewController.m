//
//  OperationViewController.m
//  QuickPos
//
//  Created by caiyi on 16/2/19.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "OperationViewController.h"
#import "MBProgressHUD+Add.h"
#define OPERATION_URL @"http://112.65.206.146:8000/get/help/recharge/index.html"


@interface OperationViewController ()
{
    UIWebView *_webView;
    MBProgressHUD *hud;
    
}
@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = L(@"Operation");
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:OPERATION_URL]];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:request];

}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (!hud) {
        hud = [MBProgressHUD showMessag:L(@"Loading") toView:self.view];
    }
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
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
