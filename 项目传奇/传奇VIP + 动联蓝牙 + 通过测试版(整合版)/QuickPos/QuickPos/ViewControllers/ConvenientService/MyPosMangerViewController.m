//
//  MyPosMangerViewController.m
//  QuickPos
//
//  Created by Aotu on 16/4/7.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "MyPosMangerViewController.h"
#import "Common.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MyPosMangerViewController ()<UIWebViewDelegate>
{
    UIButton *_clearBtn;
    
}

@end

@implementation MyPosMangerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    self.title = @"Pos管理";
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    [self.view addSubview:_webView];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://112.65.206.146:8000/get/posmanage/index.html?appuser=%@&userid=%@",APPUSER,[AppDelegate getUserBaseData].mobileNo];
//    NSString  *strUrl = @"http://112.65.206.146:8000/get/posmanage/index.html?appuser=bmqhchqvip&userid=18217503524";
    
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
    
    

    _clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
     _clearBtn.frame = CGRectMake(0, 0, 60,50);
    _clearBtn.backgroundColor = [UIColor clearColor];
    [_clearBtn addTarget:self action:@selector(goBackToConvenisentServiceViewController) forControlEvents:UIControlEventTouchUpInside];
    [_webView addSubview:_clearBtn];
    [_webView bringSubviewToFront:_clearBtn];
    
    
    
    //暂时不用
//    
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
//    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"jiantou"];

    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //定义好JS要调用的方法, share就是调用的share方法名
//    context[@"myObj.goBack"] = ^() {
//        NSArray *args = [JSContext currentArguments];
//        for (JSValue *jsVal in args) {
//            NSLog(@"%@", jsVal.toString);
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//        [self dismissViewControllerAnimated:YES completion:nil];
//
//    };
    

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    

    NSString *url = [NSString stringWithFormat:@"%@",request.URL];
   
    
    if ([url rangeOfString:@"posmanage/index.html"].location != NSNotFound) {

        _clearBtn.hidden = NO;
        self.view.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    }
    else if([url rangeOfString:@"query.html"].location != NSNotFound){
        self.view.backgroundColor = [Common hexStringToColor:@"484848"];
        _clearBtn.hidden = YES;
    }
    else if([url rangeOfString:@"endUser.html"].location != NSNotFound){
        self.view.backgroundColor = [Common hexStringToColor:@"484848"];
        _clearBtn.hidden = YES;
    }
    else if([url rangeOfString:@"traRec.html"].location != NSNotFound){
        self.view.backgroundColor = [Common hexStringToColor:@"484848"];
        _clearBtn.hidden = YES;
    }
    else if([url rangeOfString:@"query.html"].location != NSNotFound){
        self.view.backgroundColor = [Common hexStringToColor:@"484848"];
        _clearBtn.hidden = YES;
    }
    else if([url rangeOfString:@"shopDet.html"].location != NSNotFound){
        self.view.backgroundColor = [Common hexStringToColor:@"47a8ef"];
        _clearBtn.hidden = YES;
    }
    else {
        _clearBtn.hidden = YES;
    }
    

//    
//    if ([url rangeOfString:@"addShop.html"].location != NSNotFound) {
//        self.title = @"添加商户";
//    }
//    else if([url rangeOfString:@"shopDet.html"].location != NSNotFound){
//        self.title = @"商户详情";
//    }
//    else if([url rangeOfString:@"endUser.html"].location != NSNotFound){
//        self.title = @"商户终端信息管理";
//    }
//    else if([url rangeOfString:@"traRec.html"].location != NSNotFound){
//        self.title = @"交易记录";
//    }
    //
    return YES;
}


-(void)goBackToConvenisentServiceViewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





- (void)backAction:(UIButton*)btn{
    
    if ([self.title isEqualToString:@"Pos管理"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([self.title isEqualToString:@"添加商户"]){
        [_webView goBack];
        self.title = @"Pos管理";
    }else if([self.title isEqualToString:@"商户详情"]){
        self.title = @"Pos管理";
        [_webView goBack];
    }else if([self.title isEqualToString:@"商户终端信息管理"]){
        self.title = @"商户详情";
         [_webView goBack];
    }else if([self.title isEqualToString:@"交易记录"]){
        self.title = @"商户终端信息管理";
         [_webView goBack];
    }else if([self.title isEqualToString:@"交易记录查询"]){
        self.title = @"Pos管理";
        [_webView goBack];
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

