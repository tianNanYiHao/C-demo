//
//  BigHongBaoViewControl.m
//  QuickPos
//
//  Created by Aotu on 16/1/29.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "BigHongBaoViewControl.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UMSocial.h"
#import "ShareView.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"

@interface BigHongBaoViewControl ()<UIWebViewDelegate,UMSocialUIDelegate,UMSocialDataDelegate>
{
    
}
@end

@implementation BigHongBaoViewControl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"红包";
    self.shareUrl = [NSString string];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    NSString *urlStr = [NSString stringWithFormat:@"http://112.65.206.146:8000/get/redpacket/redEnvelope.html?userid=%@&appuser=%@",[AppDelegate getUserBaseData].mobileNo,APPUSER];
  
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    self.webView .delegate = self;
    self.webView .scrollView.bounces = NO;
    [self.webView  loadRequest:req];
    
    [self.view addSubview:self.webView];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"jiantou"];
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",request.URL];
    if ([urlStr rangeOfString:@"choose.html"].location != NSNotFound) {
        self.title = @"发红包";
    }else if([urlStr rangeOfString:@"normal.html"].location != NSNotFound){
        self.title = @"普通红包";
    }else if([urlStr rangeOfString:@"luck.html"].location != NSNotFound){
        self.title = @"手气红包";
    }
    else if([urlStr rangeOfString:@"convert.html"].location != NSNotFound){
        self.title = @"兑红包";
    }else if([urlStr rangeOfString:@"receive.html"].location != NSNotFound){
        self.title = @"收到的红包";
    }else if([urlStr rangeOfString:@"send.html"].location != NSNotFound){
        self.title = @"发出的红包";
    }else if([urlStr rangeOfString:@"xx.html"].location != NSNotFound){
        self.title = @"账户充值";
    }
    
    
    return YES;
}

- (void)backAction:(UIButton*)btn{
    
    if ([self.title isEqualToString:@"红包"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.title isEqualToString:@"发红包"]){
        [self.webView goBack];
        self.title = @"红包";
    }else if([self.title isEqualToString:@"普通红包"]){
        [self.webView goBack];
        self.title = @"红包";
    }else if([self.title isEqualToString:@"手气红包"]){
        [self.webView goBack];
        self.title = @"红包";
    }
    
    else if([self.title isEqualToString:@"兑红包"]){
        [self.webView goBack];
        self.title = @"红包";
    }else if([self.title isEqualToString:@"收到的红包"]){
        [self.webView goBack];
        self.title = @"红包";
    }else if([self.title isEqualToString:@"发出的红包"]){
        [self.webView goBack];
        self.title = @"红包";
    }else if([self.title isEqualToString:@"账户充值"]){
        [self.webView goBack];
        self.title = @"红包";
    }
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名
    context[@"share"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
            self.shareUrl = [NSString stringWithFormat:@"%@",jsVal.toString];
        }
        
        [UMSocialData openLog:YES];
        //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
        //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
        [UMSocialSnsService presentSnsController:self
                                          appKey:@"5695bb63e0f55a6749000609"
                                       shareText:@"【金猴迎新，投桃报李】分享APP，红包拜新年！"                                         shareImage:[UIImage imageNamed:@"icon"]
                                 shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToAlipaySession, nil]
                                        delegate:self];
        
        [UMSocialQQHandler setQQWithAppId:@"1105050299" appKey:@"Wudxj7JidLKxPosR" url:self.shareUrl];
        //微信分享AppID
        //    AppID：wx2d12d0e858b51baf
        //    AppSecret：5f211e402f9b26675a3e16326d0c8915
        [UMSocialWechatHandler setWXAppId:@"wx2d12d0e858b51baf" appSecret:@"5f211e402f9b26675a3e16326d0c8915" url:self.shareUrl];
    };
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
