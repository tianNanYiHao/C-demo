//
//  WebAgreementViewController.m
//  QuickPos
//
//  Created by Aotu on 16/1/26.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "WebAgreementViewController.h"

@interface WebAgreementViewController ()
{
    UIWebView *_webVIew;
    
}
@end

@implementation WebAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.title = _titleName;
    
    _webVIew = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSURLRequest *req = [NSURLRequest requestWithURL:_url];
    
    [_webVIew loadRequest:req];
    
    [self.view addSubview:_webVIew];

    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"jiantou"];
    
    





}
- (void)backAction:(UIButton*)btn{
    
    if ([self.title isEqualToString:@"授权协议"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self.title isEqualToString:@"借款协议"]) {
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
