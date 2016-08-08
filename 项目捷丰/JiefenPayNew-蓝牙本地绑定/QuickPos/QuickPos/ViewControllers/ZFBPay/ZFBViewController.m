//
//  ZFBViewController.m
//  QuickPos
//
//  Created by Lff on 16/8/8.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "ZFBViewController.h"
#import "LBXScanWrapper.h"
#import "LBXAlertAction.h"

#import "UIImageView+CornerRadius.h"


@interface ZFBViewController ()<UIWebViewDelegate>
{
    UIImageView *_imageVIew;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ZFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付宝支付";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://58.247.33.66/alipay.wap.create.direct.pay.by.user-JAVA-UTF-8/"]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    _webView.delegate = self;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* orderInfo = [[AlipaySDK defaultService]fetchOrderInfoFromH5PayUrl:[request.URL absoluteString]];
    if (orderInfo.length > 0) {
        NSLog(@"%@",orderInfo);
        NSString *newOrderInfo = [orderInfo substringFromIndex:19];
        NSDictionary *dict = [ZFBViewController dictionaryWithJsonString:newOrderInfo];
        NSLog(@"%@",dict);
        NSString * strHtml = [dict objectForKey:@"url"];
        _imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
        [self.view addSubview:_imageVIew];
        _imageVIew.image = [LBXScanWrapper createQRWithString:strHtml size:_imageVIew.bounds.size];
        [LBXScanWrapper addImageViewLogo:_imageVIew centerLogoImageView:nil logoSize:CGSizeZero];
        return NO;
    }
    return YES;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
