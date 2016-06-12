//
//  TransferViewController.m
//  QuickPos
//
//  Created by 张倡榕 on 15/3/6.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "TransferViewController.h"
#import "Request.h"
#import "OrderData.h"
#import "Common.h"
#import "OrderViewController.h"
#import "ChooseView.h"
#import "PayType.h"
#import "WebViewController.h"



@interface TransferViewController ()<ResponseData,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,ChooseViewDelegate>{
    
    NSUInteger payType;
    NSUInteger payTimeType;//普通、实时
    OrderData *orderData;
    NSArray *numArr;
    NSString *productId;
    NSString *merchantId;
    NSRange  ran;

}
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chooseTypeBtns;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputTextFields;
@property (weak, nonatomic) IBOutlet UIButton *choosePayTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferToHim;
@property (weak, nonatomic) IBOutlet UISegmentedControl *payTypeSeg;
@property (weak, nonatomic) IBOutlet UIView *_subview;
@property (nonatomic, strong)UIBarButtonItem *help;
@property (weak, nonatomic) IBOutlet UIButton *comfirt;

@end

@implementation TransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.notes.text = [self.item objectForKey:@"announce"];
//    self.navigationItem.title = [self.item objectForKey:@"channelTitle"];
    self.navigationItem.title = @"转账汇款";
    // Do any additional setup after loading the view.
    payType = CardPayType;
    
    
    
    
    self.comfirt.layer.cornerRadius = 5;
    
    numArr = @[@"实时还款",@"普通还款"];
    payType = CardPayType;
    payTimeType = NormalPayTimeType;
    NSLog(@"%@",self.chooseTypeBtns);
    
    self.help = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"phone_help"] style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)];
    [self.navigationItem setRightBarButtonItem:self.help];
    
//    if (ISQUICKPAY) {
//        
//        [self.payTypeSeg insertSegmentWithTitle:@"快捷支付" atIndex:2 animated:NO];
//        
//        [self.payTypeSeg setWidth:self.payTypeSeg.frame.size.width/3 forSegmentAtIndex:2];
//    }
//    int count = ISQUICKPAY?3:2;
////    self.payTypeSeg.hidden = YES;
//    float x = (self._subview.frame.size.width - [ChooseView chooseWidth]*count)/2.0;
//    float y = self.choosePayTimeBtn.frame.origin.y + self.choosePayTimeBtn.frame.size.height + 5;
//    [self._subview addSubview:[ChooseView creatChooseViewWithOriginX:x Y:y delegate:self]];
//    [ChooseView setChooseItemHidden:2 isHidden:YES];
    for (UITextField *txt in self.inputTextFields) {
        if ([self.inputTextFields indexOfObject:txt] != 0) {
            NumberKeyBoard *keyBoard = [[NumberKeyBoard alloc]init];
            [keyBoard setTextView:txt];
        }
    }

}


- (void)helpClick{
    WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [web setTitle:L(@"help")];
    [web setUrl:TransferHelp];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    for (UITextField *txt in self.inputTextFields) {
        switch (txt.tag) {
            case 1:
                txt.text = self.bankCardItem.name;
                txt.userInteractionEnabled = NO;
                break;
            case 2:
                txt.text = [Common bankCardNumSecret:self.bankCardItem.accountNo];
                txt.userInteractionEnabled = NO;
                break;
                
            default:
                break;
        }

    }

}

- (IBAction)closeKeyboard:(UITapGestureRecognizer *)sender {
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseView:(ChooseView *)chooseView chooseAtIndex:(NSUInteger)chooseIndex{
    payType = chooseIndex;
    UIView *v = chooseView.superview;
    for (UIView *c in v.subviews) {
        if ([c isKindOfClass:[ChooseView class]]) {
            if (c.tag != chooseIndex) {
                for (UIView *sv in c.subviews) {
                    if ([sv isKindOfClass:[UIButton class]]) {
                        [(UIButton*)sv setSelected:NO];
                    }
                    
                }
            }
        }
    }

}


//选择支付方式
//- (IBAction)choosePayType:(UIButton *)sender {
//    
//    NSLog(@"%@",sender.description);
//    for (UIButton* btn in self.chooseTypeBtns) {
//        if (btn == sender) {
//            btn.enabled = NO;
//            btn.backgroundColor = [UIColor grayColor];
//            payType = [self.chooseTypeBtns indexOfObject:btn];
//        }else{
//            btn.enabled = YES;
//            btn.backgroundColor = [UIColor redColor];
//        }
//    }
//    NSLog(@"payType ==== %d",payType);
//
//}


- (IBAction)choosePayType:(UISegmentedControl *)sender {
    payType = sender.selectedSegmentIndex;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    
    for (UITextField *text in self.inputTextFields) {
        if (text.text.length == 0) {
            [Common showMsgBox:nil msg:L(@"IncompleteInformation") parentCtrl:self];
            return NO;
        }
        
        switch (text.tag) {
                
            case 3:
                
                if (![self matchStringFormat:text.text withRegex:@"^([0-9]+\\.[0-9]{2})|([0-9]+\\.[0-9]{1})|[0-9]*$"]){
                    
                    [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"Highest2bit")];
                    
                    return NO;
                    
                }else
           
                if (text.text.length >9 && ![self matchStringFormat:text.text withRegex:@"^([0-9]+\\.[0-9]{2})|([0-9]+\\.[0-9]{1})|[0-9]*$"]){
                
                        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"Highest2bit")];
                    
                    return NO;
                
                }else
                    if([Common isPureInt:text.text]&& text.text.length >6){
                    
                        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"Highest")];
                        
                        return NO;
                    
                    }else if (text.text.length >9){
                    
                        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectAmount")];
                        
                        return NO;
                    }
                
                break;
            default:
                break;
        }
    
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:nil];
    
    if([identifier isEqualToString:@"TransferSegue"]){
        Request *req = [[Request alloc]initWithDelegate:self];
        NSString *orderAmt = [Common orderAmtFormat:[(UITextField*)[self.inputTextFields objectAtIndex:2] text]];
        NSString *orderDesc = self.bankCardItem.accountNo;
//        NSString *orderDesc = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@|",self.bankCardItem.accountNo,self.bankCardItem.cardIdx,self.bankCardItem.bankName,self.bankCardItem.bankProviceId,self.bankCardItem.bankCityId,self.bankCardItem.name];
        for (UITextField *txt in self.inputTextFields) {
            switch (txt.tag) {
                case 1:
                    self.bankCardItem.name = txt.text;
                    break;
                default:
                    break;
            }
            
        }

        NSString *orderRemark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@|",self.bankCardItem.name,self.bankCardItem.bankCityId,self.bankCardItem.cardIdx,self.bankCardItem.branchBankId,self.bankCardItem.remark?self.bankCardItem.remark:@""];
        if (payTimeType == NormalPayTimeType) {
            productId = @"0000000000";
            merchantId = @"0002000003";
            if (payType == AccountPayType) {
                [req applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId: @"0002000003" productId:@"0000000000" orderAmt:orderAmt orderDesc:orderDesc orderRemark:orderRemark commodityIDs:@"" payTool:@"02"];
            }else if(payType == CardPayType){
                [req applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0002000003" productId:@"0000000000" orderAmt:orderAmt orderDesc:orderDesc orderRemark:orderRemark commodityIDs:@"" payTool:@"01"];
            }else{
                [req applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0002000003" productId:@"0000000000" orderAmt:orderAmt orderDesc:orderDesc orderRemark:orderRemark commodityIDs:@"" payTool:@"03"];
            
            }
            
        }else{
            productId = @"0000000001";
            merchantId = @"0002000003";
            if (payType == AccountPayType) {
                [req applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0002000003" productId:@"0000000001" orderAmt:orderAmt orderDesc:orderDesc orderRemark:orderRemark commodityIDs:@"" payTool:@"02"];
            }else if(payType == CardPayType){
                [req applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0002000003" productId:@"0000000001" orderAmt:orderAmt orderDesc:orderDesc orderRemark:orderRemark commodityIDs:@"" payTool:@"01"];
            }else{
                [req applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0002000003" productId:@"0000000001" orderAmt:orderAmt orderDesc:orderDesc orderRemark:orderRemark commodityIDs:@"" payTool:@"03"];
            
            }
            
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    return NO;
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    if([[dict objectForKey:@"respCode"] isEqualToString:@"0000"]){
        if (type == REQUSET_ORDER) {
            orderData = [[OrderData alloc]initWithData:dict];
            orderData.orderPayType = payType;
            orderData.orderAccount = [(UITextField*)[self.inputTextFields objectAtIndex:2] text];
            orderData.productId = productId;
            orderData.merchantId = merchantId;
  orderData.orderAmt = [Common orderAmtFormat:[(UITextField*)[self.inputTextFields objectAtIndex:0] text]];
            [self performSegueWithIdentifier:@"TransferSegue" sender:self.transferToHim];
        }
    }else{
        [Common showMsgBox:@"" msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
    }

}
#pragma mark - UitextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - pickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //拾取视图的列数
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    payTimeType = row;
    if (row == 0) {
        return L(@"RealTimeReimbursement");
    }else if (row == 1) {
        return L(@"RegularPayments");
    }
    return L(@"RealTimeReimbursement");
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.choosePayTimeBtn setTitle:[NSString stringWithFormat:@"%@",numArr[row]] forState:UIControlStateNormal];
    payTimeType = row;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[OrderViewController class]]) {
        [(OrderViewController*)segue.destinationViewController setOrderData:orderData];
        
    }

}


#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:matchedStr];
}

@end
