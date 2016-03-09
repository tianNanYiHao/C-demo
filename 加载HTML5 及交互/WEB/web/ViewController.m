//
//  ViewController.m
//  web
//
//  Created by kuailefu on 16/1/11.
//  Copyright © 2016年 kuailefu. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "ViewController.h"
#import "twoViewController.h"

@interface ViewController ()<UIAlertViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/3*2.0)];
    
    
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"Finance" ofType:@"html"];
//    NSURL* url = [NSURL fileURLWithPath:path];
//        NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"product.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    
    _webView.delegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    
    
    
    JSContext *jscontext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"]; //关联js与oc 

    jscontext[@"share"] = ^(){

        //一下均为oc方法
        NSLog(@"ddddddddddddddddddddddddddddddddddddddd");

        NSArray *arges = [JSContext currentArguments];
        for (JSValue *value in arges) {
            NSLog(@"%@",value.toString);
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tishi" message:@"js调用了oc 这里oc原生的alert " delegate:self cancelButtonTitle:nil  otherButtonTitles:@"确定", nil];
        [alert show];
        

        NSLog(@"ddddddddddddddddddddddddddddddddddddddddd");
    };
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, CGRectGetMaxY(_webView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-_webView.frame.size.height);
    
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(js) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点击调用js   执行js的alert弹出框" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
}

-(void)js{
    
    JSContext *jsc = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    NSString *jsstring = @"hello('这是oc里 调js 弹出js的alert,非oc弹出...')";
    
    [jsc evaluateScript:jsstring]; //执行脚本
    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"1111111111111111111111111111111111111111");

    

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        twoViewController *t = [[twoViewController alloc] init];
        [self presentViewController:t animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
