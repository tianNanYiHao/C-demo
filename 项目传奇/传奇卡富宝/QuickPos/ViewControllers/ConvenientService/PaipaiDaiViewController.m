//
//  PaipaiDaiViewController.m
//  QuickPos
//
//  Created by kuailefu on 16/6/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "PaipaiDaiViewController.h"

@interface PaipaiDaiViewController ()
@property (nonatomic, strong) UIWebView *web;
@end

@implementation PaipaiDaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"拍拍贷";
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-60)];
    NSURL *url = [[NSURL alloc]initWithString:@"http://m.ppdai.com/landingcpsnew.html?regsourceid=weifeidaikuan006"];
    self.web.scrollView.bounces = NO;
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.web];
    
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
