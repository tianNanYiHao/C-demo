//
//  ViewController.m
//  testInstall
//
//  Created by Aotu on 16/7/12.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSURL *url = [NSURL URLWithString:path];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://oa6vva40q.qnssl.com/index.html"]];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:req];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
