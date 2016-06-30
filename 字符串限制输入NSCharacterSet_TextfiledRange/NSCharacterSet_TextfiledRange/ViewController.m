//
//  ViewController.m
//  NSCharacterSet_TextfiledRange
//
//  Created by Aotu on 16/6/30.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *t;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _t.delegate = self;
    
    
}
//
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSCharacterSet *charer = [NSCharacterSet characterSetWithCharactersInString:@"12345"];
    NSString *filed  = [[string componentsSeparatedByCharactersInSet:charer] componentsJoinedByString:@""];
    if ([filed isEqualToString:string]) {
        return NO;
    }
    return [ViewController moneyTextField:textField shouldChangeCharactersInRange:range replacementString:string max:1000];
}



#pragma mark - 限制输入数字以及最大值 方法实现
+(BOOL)moneyTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string max:(NSInteger)max
{
    //筛选输入内容确保正确性
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    BOOL isHasRadixPoint = YES;
    //小数点后面的位数
    NSInteger RadixPointNum = 2;
    NSString *existText = textField.text;
    //判断是否含有小数点
    if ([existText rangeOfString:@"."].location == NSNotFound) {
        isHasRadixPoint = NO;
    }
    
    if (string.length > 0) {
        unichar newChar = [string characterAtIndex:0];
        //开始进入判断文本
        if (existText.length>0) {
            if ([existText characterAtIndex:0]=='0') {
                //当首位是0的时候
                if (newChar=='0') {
                    //输入是零的时候判断是否有小数点
                    if (isHasRadixPoint) {
                        return range.location<=2;
                    }else{
                        return NO;
                    }
                }else if((newChar > '0' && newChar <= '9') &&existText.length<=1){
                    textField.text = @"";
                }
            }
        }
        
        if ((newChar >= '0' && newChar <= '9') || newChar == '.' ) {
            if (newChar == '.') {
                if (existText.length==0) {
                    textField.text = @"0.";
                    return NO;
                }else{
                    return !isHasRadixPoint;
                }
            }else {
                if (isHasRadixPoint) {
                    NSRange ran = [existText rangeOfString:@"."];
                    return (range.location - ran.location <= RadixPointNum);
                } else{
                    //小数点前面的位数
                    //return existText.length<6;
                    if ([textField.text isEqualToString:@"0"]){
                        textField.text = @"0.";
                    }
                    NSString *nowString;
                    if (range.length==0) {
                        nowString = [NSString stringWithFormat:@"%@%@",textField.text,string];
                    }else{
                        nowString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                    }
                    //                    NSString *nowString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                    if (nowString.doubleValue>= max) {
                        textField.text = [NSString stringWithFormat:@"%ld",max];
                        return NO;
                    }
                    return nowString.doubleValue <= max;
                }
            }
        }else {
            return YES;
        }
    }
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
