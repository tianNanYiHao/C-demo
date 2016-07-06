//
//  PerfectInformationViewController.m
//  QuickPos
//
//  Created by Leona on 15/3/12.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "PerfectInformationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HeadPhotoViewController.h"

//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"


@interface PerfectInformationViewController ()<ResponseData,UITextFieldDelegate>{
    
    UIImage * photoimage;
    NSString * fileName;
    NSUserDefaults *userDefaults;//储存
    NSDictionary *dataDic;//请求返回字典
    Request *requst;
    MBProgressHUD * hud;
}

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;//姓名输入框

@property (weak, nonatomic) IBOutlet UITextField *IdTextField;//身份证输入框
@property (weak, nonatomic) IBOutlet UIButton *comfirtButton;

@end

@implementation PerfectInformationViewController

@synthesize IDstr;
@synthesize realNameStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.comfirtButton.layer.cornerRadius = 5;
    //self.title = L(@"InputName");
    
    self.navigationController.navigationBarHidden = NO;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.accountTextField.text = realNameStr;
    self.accountTextField.tag  = 1000991;
    self.accountTextField.delegate = self;
    
    self.IdTextField.text = IDstr;
    
    requst = [[Request alloc]initWithDelegate:self];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField.tag == 1000991){
        
        if (![self validateRealNameCNorUK:textField.text]) {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"请输入正确的姓名"];
            self.accountTextField.text = @"";
        };
    }
}

- (BOOL) validateRealNameCNorUK:(NSString *)name
{
    if (name.length==0) {
        return NO;
    }
    NSString *cnRegex = @"^[\u4E00-\u9FA5]{1}+$";
    NSString *cnAllRegex = @"^[\u4E00-\u9FA5]{1,16}+$";
    
    
    NSPredicate *cnPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cnRegex];
    NSPredicate *cnAllPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cnAllRegex];
    //    NSString *ukRegex = @"^[a-zA-Z]{1}+$";
    //    NSString *ukAllRegex = @"^[a-zA-Z ]{1,16}+$";
    //    NSPredicate *ukPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ukRegex];
    //    NSPredicate *ukAllPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ukAllRegex];
    if ([cnPredicate evaluateWithObject:[name substringWithRange:NSMakeRange(0, 1)]]) {
        return [cnAllPredicate evaluateWithObject:name];
    }
    //    else if([ukPredicate evaluateWithObject:[name substringWithRange:NSMakeRange(0, 1)]]){
    //        return [ukAllPredicate evaluateWithObject:name];
    //    }
    else{
        return NO;
    }
}


- (IBAction)TakingPictures:(UIButton *)sender {
    
    
    if([self.accountTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputName")];
        
    }else if ([self.IdTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputID")];
        
    }else if (self.IdTextField.text.length > 18){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectID")];
        
    }else if (self.IdTextField.text.length < 15){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectID")];
        
    }else if (self.IdTextField.text.length == 17 || self.IdTextField.text.length == 16){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectID")];
        
    }else if ([self.IdTextField.text rangeOfString:@"x"].location != NSNotFound){
        self.IdTextField.text = [self.IdTextField.text  stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
        NSLog(@"id ====  %@",self.IdTextField.text);
        [requst realNameAuthentication:self.accountTextField.text ID:self.IdTextField.text];
        
    }
    else{
        
        [self.IdTextField resignFirstResponder];
        [requst realNameAuthentication:self.accountTextField.text ID:self.IdTextField.text];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"MBPLoading")];
        
    }
    
    
    
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [hud hide:YES];
    dataDic = dict;
    
    if([dataDic[@"respCode"] isEqual:@"0000"]){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        HeadPhotoViewController *headviewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"touxiangVC"];
        
        [self.navigationController pushViewController:headviewVC animated:YES];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:dataDic[@"respDesc"]];
        
    }
    
    
    
    
    
    
    
}


@end
