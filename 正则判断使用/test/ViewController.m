//
//  ViewController.m
//  test
//
//  Created by kuailefu on 16/5/26.
//  Copyright © 2016年 kuailefu. All rights reserved.
//

#import "ViewController.h"

//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textA;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textA.delegate = self;
    
    // 方法一 正则判断
  if(![self matchStringFormat:self.textA.text withRegex:@"^[\u4e00-\u9fa5]*$"]){
      NSLog(@"请输入中文,不能包含字母或数字");
//      [MBProgressHUD showHUDAddedTo:self.view WithString:@"请输入中文,不能包含字母或数字"];
  }
    
}

//方法二  键盘限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
{
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if ([string isEqualToString:@""]) {
        return YES;
        
    }
    
    if ([string isEqualToString:filtered]) {
        return NO;
    }else{
        return YES;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:matchedStr];
}

@end
