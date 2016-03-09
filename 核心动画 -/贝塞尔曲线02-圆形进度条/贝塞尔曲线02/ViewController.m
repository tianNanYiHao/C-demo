//
//  ViewController.m
//  贝塞尔曲线02
//
//  Created by 张延深 on 16/1/12.
//  Copyright © 2016年 宜信. All rights reserved.
//

#import "ViewController.h"
#import "CustomCircleView.h"

@interface ViewController ()
{
    CustomCircleView *_circleView;
}
@property (strong, nonatomic) IBOutlet UITextField *rateTxt;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CustomCircleView *circleView = [[CustomCircleView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100) * 0.5, 100, 100, 100)];
    _circleView = circleView;
    [self.view addSubview:_circleView];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (_rateTxt.text.length == 0) {
        [self showAlertViewMsg:@"请输入Rate！"];
        NSLog(@"请输入Rate！");
        return;
    }
    if (![self isPureInteger:_rateTxt.text]) {
        [self showAlertViewMsg:@"请输入纯数字！"];
        NSLog(@"请输入纯数字！");
        return;
    }
    _circleView.rate = [_rateTxt.text integerValue];
    [_circleView startAnimation];
}

#pragma mark - private methods

#pragma mark 判断是否是纯数字
- (BOOL)isPureInteger:(NSString *)str {
    NSScanner *scanner = [NSScanner scannerWithString:str];
    NSInteger val;
    return [scanner scanInteger:&val] && [scanner isAtEnd];
}

#pragma mark Alertview
- (void)showAlertViewMsg:(NSString *)msg {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
