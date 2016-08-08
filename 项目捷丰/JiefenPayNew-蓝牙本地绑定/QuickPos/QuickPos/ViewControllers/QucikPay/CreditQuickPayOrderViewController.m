//
//  CreditQuickPayOrderViewController.m
//  QuickPos
//
//  Created by feng Jie on 16/6/26.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "CreditQuickPayOrderViewController.h"
#import "OrderData.h"
#import "QuickBankData.h"
#import "Request.h"
#import "PayType.h"
#import "Common.h"
#import "MBProgressHUD+Add.h"
#import "QuickPosTabBarController.h"

@interface CreditQuickPayOrderViewController ()<ResponseData,UIAlertViewDelegate>{
    NSString *productId;
    NSString *merchantId;
    MBProgressHUD *hud;
    Request *request;
    
    int Second;//秒数
    NSTimer *timer;//倒计时
    
}

@property (weak, nonatomic) IBOutlet UILabel *orderId;//订单编号

@property (weak, nonatomic) IBOutlet UILabel *transAccount;//交易账户

@property (weak, nonatomic) IBOutlet UILabel *CardValid;//卡有效期

@property (weak, nonatomic) IBOutlet UILabel *SecurityCode;//卡安全码


@property (weak, nonatomic) IBOutlet UILabel *transAmt;//交易金额

@property (weak, nonatomic) IBOutlet UILabel *transBank;//支付银行

@property (weak, nonatomic) IBOutlet UILabel *bankNo;//银行卡号

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;//获取验证码按钮

@property (weak, nonatomic) IBOutlet UITextField *SMSVerification;//短信验证

@property (weak, nonatomic) IBOutlet UITextField *PaymentPassword;//支付密码

@property (nonatomic,strong) NSString *orderAmts;

@property (nonatomic,strong) NSString *dynameic;

@end

@implementation CreditQuickPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderId.text = self.orderData.orderId;//订单编号
    self.transAccount.text = [AppDelegate getUserBaseData].mobileNo;//交易账户
    self.orderAmts = self.orderData.orderAmt;//交易金额
    self.transAmt.text = [NSString stringWithFormat:@"￥%.2f",[_orderAmts integerValue]/100.0];//金额转化
    
    self.transBank.text = self.bankName;//支付银行
    self.bankNo.text = self.cardNums;//银行卡号
    self.CardValid.text = self.CardValid;//卡有效期
    self.SecurityCode.text = self.SecurityCode;//卡安全码
    
    NSLog(@"%@  %@  %@  %@  %@",self.orderId.text,self.transAccount.text,self.transAmt.text,self.transBank.text,self.bankNo.text);
    
    request = [[Request alloc]initWithDelegate:self];
}

//获取验证码
- (IBAction)GetVerificationCode:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view WithString:@"短信发送成功"];
    
    Second = 60;
    
    [timer invalidate];
    
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeats) userInfo:nil repeats:YES];
    
    [request SendDynamicCode:self.newbindid];
    NSLog(@"%@",self.newbindid);
    
}


- (void)repeats
{
    
    if (Second > 0)
    {  --Second;
        
        self.getCodeButton.enabled = NO;
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
        [self.getCodeButton setTitle:[NSString stringWithFormat:L(@"ToResendToSecond"),Second] forState:UIControlStateNormal];
        
    }else
    {
        [self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"fasongyanzma2.png"] forState:UIControlStateNormal];
        self.getCodeButton.enabled =YES;
        
        [self.getCodeButton setTitle:[NSString stringWithFormat:L(@"ToResend")] forState:UIControlStateNormal];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
    }
    
}


//确认验证码
- (IBAction)ConfirmingTheVerificationCode:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在验证短信验证码..."];
    [request CheckDynamicCode:self.newbindid dynameic:self.dynameic];
    
}


- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        if (type == REQUSET_SENDDYNAMICCODE) {
            self.dynameic = [dict objectForKey:@"dynameic"];
            NSLog(@"%@",self.dynameic);
            
            
        }else if (type == REQUSET_CHECKDYNAMICCODE){
            
            
            
//            if (self.codeTextField.text.length == 0) {
//                    [Common showMsgBox:nil msg:L(@"VerificationCodeCannotBeEmpty") parentCtrl:self];
//                }else{
                    if (iOS8) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:L(@"PleaseEnterTradingPassword") preferredStyle:UIAlertControllerStyleAlert];
                        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                            textField.placeholder = L(@"TradePassword");
                            textField.secureTextEntry = YES;
                            
                        }];
                        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            if ([(UITextField*)[alert.textFields objectAtIndex:0] text].length == 0) {
                                [Common showMsgBox:nil msg:L(@"PasswordCannotBeEmpty") parentCtrl:self];
                            }else{//账户支付
                                hud = [MBProgressHUD showMessag:@"正在交易中，请稍后" toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                                Request *req = [[Request alloc]initWithDelegate:self];
                                
                                [req QuickBankCardConfirmCardNo:self.cardNums
                                                       password:[(UITextField*)[alert.textFields objectAtIndex:0] text]
                                                      newbindid:self.newbindid
                                                      transDate:@""
                                                      transTime:@""
                                                      orderTime:@""
                                                     customerId:self.customerId
                                                   customerName:self.customerName
                                                       cardType:self.cardType
                                                       bankName:self.bankName
                                                       orderAmt:self.orderData.orderAmt
                                                        orderId:self.orderData.orderId
                                                         PinBlk:[(UITextField*)[alert.textFields objectAtIndex:0] text]
                                 ];
                                
                                
                                
                            }
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        }];
                        [alert addAction:defaultAction];
                        [alert addAction:cancelAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"PleaseEnterPayPassword") message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
                        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                        [[alert textFieldAtIndex:0] setPlaceholder:L(@"PayPassword")];
                        alert.tag = AccountPayType;
                        [alert show];
                    }
               
//            }
            
            
        }
        
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"respDesc"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}


- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
