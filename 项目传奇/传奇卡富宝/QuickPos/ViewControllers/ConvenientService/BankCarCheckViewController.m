//
//  BankCarCheckViewController.m
//  QuickPos
//
//  Created by kuailefu on 16/6/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "BankCarCheckViewController.h"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface BankCarCheckViewController ()<ResponseData,UITextFieldDelegate>
{
    Request *_request;
}
@property (weak, nonatomic) IBOutlet UIButton *comfirt;

@end

@implementation BankCarCheckViewController
- (IBAction)check:(id)sender {
    
    if (![Common validateIdentityCard:self.idcard.text]) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"身份证不正确"];
        return;
    }
    if (![Common isPhoneNumber:self.phone.text]) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"手机号码不正确"];
        return;
    }
    
    [_request carCheckName:self.name.text cardNum:self.carNumTextF.text phone:self.phone.text idCard:self.idcard.text];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _request = [[Request alloc] initWithDelegate:self];
    [self.name becomeFirstResponder];
    
    self.title = @"卡验证";
    self.carNumTextF.text = self.carNum;
    self.carNumTextF.adjustsFontSizeToFitWidth = YES;
    self.carNumTextF.userInteractionEnabled = NO;
    self.idcard.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    self.phone.delegate = self;
    self.phone.tag = 10;
    self.name.delegate = self;
    self.name.tag = 11;
    self.idcard.delegate = self;
    
    self.comfirt.backgroundColor =[Common hexStringToColor:@"ebebeb"];
    self.comfirt.enabled = NO;
    [self.comfirt setTitleColor:[Common hexStringToColor:@"dcdcdc"] forState:UIControlStateNormal];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    if (textField.tag == 11) {
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
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 10) {
        self.comfirt.backgroundColor =[Common hexStringToColor:@"14b9d5"];
        self.comfirt.enabled = YES;
        [self.comfirt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
//    if ([self.phone.text length]>0 && [self.name.text length]>0 && [self.idcard.text length]>0 ) {

//    }

}
- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    if (type == REQUEST_FOURINFO) {
        
        NSString *statu =  dict[@"data"][@"result"][@"resultCode"];
        if ([statu isEqualToString:@"1000"]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate finishCheck:@"OK"];
        }
        
        if ([statu isEqualToString:@"1001"]) {
            [MBProgressHUD showHUDAddedTo:self.view WithString:[NSString stringWithFormat:@"%@",dict[@"data"][@"result"][@"message"]]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate finishCheck:@"NO"];
            });
        }
        
    }
    
}


@end
