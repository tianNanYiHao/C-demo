//
//  BankCardBindViewController.m
//  QuickPos
//
//  Created by 胡丹 on 15/4/8.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "BankCardBindViewController.h"
#import "NumberKeyBoard.h"
#import "Request.h"
#import "QuickBankData.h"
#import "QuickPayOrderViewController.h"
#import "AddCardDetailInfoViewController.h"
#import "Common.h"
#import "PayType.h"
#import "MBProgressHUD+Add.h"
#import "WebViewController.h"


@interface BankCardBindViewController ()<ResponseData,UITextFieldDelegate>{
    QuickBankItem *item;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UITextField *cardNum;//卡号
@property (weak, nonatomic) IBOutlet UITextField *name;//姓名
@property (weak, nonatomic) IBOutlet UITextField *icCard;//身份证号
@property (weak, nonatomic) IBOutlet UITextField *phone;//银行预留手机号
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation BankCardBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NumberKeyBoard *numKeyBoard = [[NumberKeyBoard alloc]init];
//    [numKeyBoard setTextView:self.cardNum];
    
//    NumberKeyBoard *numKeyBoard2 = [[NumberKeyBoard alloc]init];
//    [numKeyBoard2 setTextView:self.icCard];
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    self.cardNum.text = [user objectForKey:@"cardNumTest"];
//    self.icCard.text = [user objectForKey:@"icCardTest"];
//    self.name.text = [user objectForKey:@"nameTest"];
//    self.phone.text = [user objectForKey:@"phoneTest"];

    self.nextBtn.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [hud hide:YES];
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        if (type == REQUEST_QUICKBANKCARDQUERY) {
            //查询卡信息返回
            item = [[QuickBankItem alloc]init];
            item.cardType = [[dict objectForKey:@"cardType"] integerValue];
            item.isValid = [[dict objectForKey:@"isValid"] integerValue];
            item.bankName = [dict objectForKey:@"bankName"];
            item.phone = self.phone.text;
            
            if ([self.icCard.text rangeOfString:@"x"].location != NSNotFound){
                self.icCard.text = [self.icCard.text  stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
                NSLog(@"id ====  %@",self.icCard.text);
            }
            item.icCard = self.icCard.text;
            item.name = self.name.text;
            item.cardNo = self.cardNum.text;
            if (item.cardType == DEPOSITCARD) {
                //储蓄卡
                if ([self.navigationController.viewControllers containsObject:self]) {
                    [self performSegueWithIdentifier:@"QuickOrderSegue" sender:self.nextBtn];
                }
                
            }else{
                if(item.isValid){
                    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"QuickPay" bundle:nil];
                    AddCardDetailInfoViewController *add = [storyBoard instantiateViewControllerWithIdentifier:@"AddCardDetailInfoViewController"];
                    [add setOrderData:self.orderData];
                    [add setQuickBankItem:item];
                    [self.navigationController pushViewController:add animated:YES];
                }
                else {
                    [Common showMsgBox:nil msg:L(@"InvalidCardNumber") parentCtrl:self];
                }
            }
            
        }
    } else {
        [Common showMsgBox:nil msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"QuickOrderSegue"]){
        if ([segue.destinationViewController isKindOfClass:[QuickPayOrderViewController class]]) {
            [(QuickPayOrderViewController*)segue.destinationViewController setOrderData:self.orderData];
            [(QuickPayOrderViewController*)segue.destinationViewController setBankCardItem:item];
        }
    
    }else if([segue.identifier isEqualToString:@"AddCardDetailSegue"]){
        if ([segue.destinationViewController isKindOfClass:[AddCardDetailInfoViewController class]]) {
            [(AddCardDetailInfoViewController*)segue.destinationViewController setOrderData:self.orderData];
            [(AddCardDetailInfoViewController*)segue.destinationViewController setQuickBankItem:item];
            
        }
        
    }
    
}

- (IBAction)showHelp:(id)sender {
    WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
    [web setUrl:BankListHelp];
    [web setTitle:L(@"help")];
    [self.navigationController pushViewController:web animated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (self.cardNum.text.length == 0 || self.icCard.text.length == 0 ||self.phone.text.length == 0) {
        [Common showMsgBox:@"" msg:L(@"PleaseEnterCorrectInformation") parentCtrl:self];
        return NO;
    }
    if (self.phone.text.length != 11 ) {
        [Common showMsgBox:@"" msg:L(@"InputCorrectNumber") parentCtrl:self];
        return NO;
    }
    
    if ( self.icCard.text.length != 15 && self.icCard.text.length != 18) {
        [Common showMsgBox:@"" msg:L(@"InputCorrectID") parentCtrl:self];
        return NO;
    }
    
    if ( self.name.text.length > 9) {
        [Common showMsgBox:@"" msg:L(@"PleaseEnterCorrectName") parentCtrl:self];
        return NO;
    }
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setObject:self.cardNum.text forKey:@"cardNumTest"];
//    [user setObject:self.icCard.text forKey:@"icCardTest"];
//    [user setObject:self.name.text forKey:@"nameTest"];
//    [user setObject:self.phone.text forKey:@"phoneTest"];
    Request *req = [[Request alloc]initWithDelegate:self];
    [req checkBankCardInfo:self.cardNum.text];
    hud = [MBProgressHUD showMessag:L(@"VerifyingCardInformation") toView:self.view];
    return NO;
}

@end
