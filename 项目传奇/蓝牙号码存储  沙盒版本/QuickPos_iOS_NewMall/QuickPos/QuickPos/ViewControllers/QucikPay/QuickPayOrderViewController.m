//
//  QuickPayOrderViewController.m
//  QuickPos
//
//  Created by 胡丹 on 15/4/8.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "QuickPayOrderViewController.h"
#import "OrderData.h"
#import "QuickBankData.h"
#import "Request.h"
#import "PayType.h"
#import "Common.h"
#import "MBProgressHUD+Add.h"
#import "QuickPosTabBarController.h"

@interface QuickPayOrderViewController ()<ResponseData,UIAlertViewDelegate>{
    NSString *productId;
    NSString *merchantId;
    MBProgressHUD *hud;


}
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *orderAmt;
@property (weak, nonatomic) IBOutlet UILabel *bankCardName;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNum;

@property (weak, nonatomic) IBOutlet UIButton *comfirt;

- (IBAction)quickPay:(UIButton *)sender;

@end

@implementation QuickPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.comfirt.layer.cornerRadius = 5;
    self.orderId.text = self.orderData.orderId;
    self.account.text = [AppDelegate getUserBaseData].mobileNo;
    self.orderAmt.text = [Common rerverseOrderAmtFormat:self.orderData.orderAmt];
    self.bankCardName.text = self.bankCardItem.bankName;
    self.bankCardNum.text = self.bankCardItem.cardNo;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    Request *req = [[Request alloc]initWithDelegate:self];
//    NSString *payInfo;
//    [req applyForQuickPay:payInfo orderID:self.orderData.orderId];
//    return YES;
//}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [hud hide:YES];
    NSString *code = [dict objectForKey:@"respCode"];
    if ([code isEqualToString:@"0000"]) {
        if(type == REQUEST_QUICKBANKCARDAPPLY){
            //无卡支付申请返回
            if([[dict objectForKey:@"smsConfirm"] intValue] == 1){
                Request *req = [[Request alloc]initWithDelegate:self];
                [req getQuickPayCode:self.orderData.orderId];
                [self getCodeView];
            }else{
                 hud = [MBProgressHUD showMessag:L(@"IsThePaymentConfirmation") toView:[[QuickPosTabBarController getQuickPosTabBarController]view]];
//                if(iOS8){
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"是否确认支付？" preferredStyle:UIAlertControllerStyleAlert];
//                                        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        Request *req = [[Request alloc]initWithDelegate:self];
                
                        [req enSureQuickPay:@"" orderID:self.orderData.orderId];

//                    }];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                    }];
//                    [alert addAction:defaultAction];
//                    [alert addAction:cancelAction];
//                    [self presentViewController:alert animated:YES completion:nil];
//                    
//                }else{
//                    
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否确认支付？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//                    alert.tag = 1;
//                    [alert show];
//                    
//                }

                            }
        
        }
        else if(type == REQUEST_QUICKBANKCARDCONFIRM){
            //无卡支付确认返回
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearShoppingCartNotification" object:[NSString stringWithFormat:@"%d",YES]];
            [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"TheSuccessOfPayment")];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
        }
    }else{
        [MBProgressHUD showHUDAddedTo:self.view WithString:[dict objectForKey:@"respDesc"]];
//        [Common showMsgBox:nil msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
        if (type == REQUEST_QUICKBANKCARDAPPLY || type == REQUEST_QUICKBANKCARDCONFIRM) {
            [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
        }
        
    }

}

- (void)goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//短信确认
- (void)getCodeView{
    if(iOS8){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert setTitle:L(@"SecurityVerification")];
        [alert setMessage:L(@"ForYourTransactionSecurityPleaseEnterTheVerificationCode")];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = L(@"MessageAuthenticationCode");
            textField.secureTextEntry = YES;
            
        }];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *pwd = [(UITextField*)[alert.textFields objectAtIndex:0] text];
            if (pwd.length == 0) {
                [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"VerificationCodeCannotBeEmpty")];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                hud = [MBProgressHUD showMessag:L(@"IsThePaymentConfirmation") toView:[[QuickPosTabBarController getQuickPosTabBarController]view]];
                Request *req = [[Request alloc]initWithDelegate:self];
                [req enSureQuickPay:[(UITextField*)[alert.textFields objectAtIndex:0] text] orderID:self.orderData.orderId];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert setTitle:L(@"SecurityVerification")];
        [alert setMessage:L(@"ForYourTransactionSecurityPleaseEnterTheVerificationCode")];
        [[alert textFieldAtIndex:0] setPlaceholder:L(@"MessageAuthenticationCode")];
        alert.tag = 2;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            NSString *pwd = [(UITextField*)[alertView textFieldAtIndex:0] text];
            if (pwd.length == 0) {
                [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"VerificationCodeCannotBeEmpty")];
                [alertView show];
            }else{
                hud = [MBProgressHUD showMessag:L(@"IsThePaymentConfirmation") toView:[[QuickPosTabBarController getQuickPosTabBarController]view]];
                Request *req = [[Request alloc]initWithDelegate:self];
                [req enSureQuickPay:[(UITextField*)[alertView textFieldAtIndex:0] text] orderID:self.orderData.orderId];
            }
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        if (buttonIndex == 1){
            hud = [MBProgressHUD showMessag:L(@"IsThePaymentConfirmation") toView:[[QuickPosTabBarController getQuickPosTabBarController]view]];
            Request *req = [[Request alloc]initWithDelegate:self];
            [req enSureQuickPay:@"" orderID:self.orderData.orderId];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

//我要付款
- (IBAction)quickPay:(UIButton *)sender {
    hud = [MBProgressHUD showMessag:L(@"IsSubmitRequest") toView:[[QuickPosTabBarController getQuickPosTabBarController]view]];
    Request *req = [[Request alloc]initWithDelegate:self];
    if (self.bankCardItem.isBind) {
        [req applyForQuickPay:@"" IDCard:@"" cardNo:@"" vaild:@"" cvv2:@"" phone:@"" orderID:self.orderData.orderId bindID:self.bankCardItem.bindID orderAmt:self.orderData.orderAmt productId:self.orderData.productId merchantId:self.orderData.merchantId];
    }else{
        if (self.bankCardItem.cardType == DEPOSITCARD) {
            [req applyForQuickPay:self.bankCardItem.name IDCard:self.bankCardItem.icCard cardNo:self.bankCardItem.cardNo vaild:@"" cvv2:@"" phone:self.bankCardItem.phone orderID:self.orderData.orderId bindID:@"" orderAmt:self.orderData.orderAmt productId:self.orderData.productId merchantId:self.orderData.merchantId];
        }else{
            [req applyForQuickPay:self.bankCardItem.name IDCard:self.bankCardItem.icCard cardNo:self.bankCardItem.cardNo vaild:self.bankCardItem.validateCode cvv2:self.bankCardItem.cvv2  phone:self.bankCardItem.phone orderID:self.orderData.orderId  bindID:@"" orderAmt:self.orderData.orderAmt productId:self.orderData.productId merchantId:self.orderData.merchantId];
        }
        
    }
    
}
@end
