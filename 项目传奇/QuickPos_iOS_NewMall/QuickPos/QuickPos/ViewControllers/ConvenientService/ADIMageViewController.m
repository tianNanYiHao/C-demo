//
//  ADIMageViewController.m
//  QuickPos
//
//  Created by Aotu on 16/4/8.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "ADIMageViewController.h"

@interface ADIMageViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation ADIMageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"大山深处的·木竹坞";
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:_webView];
    
    NSString  *strUrl = @"http://wap.ruijiutou.com/index.php?m=content&c=index&a=show&catid=9&id=7&s=chuanqi";
    
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 50, 50);
    [btn setTitle:@"回首页" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(goBacktoAD) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;

}
-(void)goBacktoAD{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
