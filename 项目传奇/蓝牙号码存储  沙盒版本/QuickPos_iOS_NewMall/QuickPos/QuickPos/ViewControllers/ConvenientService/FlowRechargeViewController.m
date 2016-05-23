//
//  FlowRechargeViewController.m
//  QuickPos
//
//  Created by caiyi on 16/4/11.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "FlowRechargeViewController.h"
#import "NumberKeyBoard.h"
#import "Common.h"
#import "ChooseView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "RadioButton.h"
#import "Request.h"
#import "UserBaseData.h"
#import "UserInfoView.h"
#import "OrderViewController.h"
#import "OrderData.h"
#import "PayType.h"
#import "ChooseView.h"
#import "MBProgressHUD+Add.h"
#import "ROllLabel.h"



@interface FlowRechargeViewController ()<ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate,ResponseData,ChooseViewDelegate>
{
    NSUInteger payType;
    Request *request;
    NSDictionary *phoneArray;
    OrderData *orderData;
    MBProgressHUD *hud;
    NSString *merchantId;   //商户商家id
    NSString *productId;
    NSString *payTool;
//    UILabel *labelB;//金额
    
    NSArray *arr;
    
    NSMutableArray *_arrayDate;
    int  _count;
    float  _accountMoney;
    NSString *orderAmt;
    
    
    
    
   
}
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumberTextFild;//
@property (weak, nonatomic) IBOutlet UIButton *PeopleBook;//通讯录
@property (weak, nonatomic) IBOutlet UILabel *PhoneNumberDetailLabel;//手机号详情(展示手机号是移动/电信和联通,后台返回)
@property (weak, nonatomic) IBOutlet UIView *PhoneNumberView;

@property (nonatomic,strong) NSString *mobileNo;//手机号;
@property (nonatomic,strong) NSString *amountAmt;//充值金额
@property (weak,nonatomic) UILabel *labelB;//金额


@property (weak, nonatomic) IBOutlet UILabel *SelectLabel;//选择流量
@property (weak, nonatomic) IBOutlet RadioButton *button1;//流量按钮1
@property (weak, nonatomic) IBOutlet RadioButton *button2;//流量按钮2
@property (weak, nonatomic) IBOutlet RadioButton *button3;//流量按钮3
@property (weak, nonatomic) IBOutlet RadioButton *button4;//流量按钮4
@property (weak, nonatomic) IBOutlet RadioButton *button5;//流量按钮5
@property (weak, nonatomic) IBOutlet RadioButton *button6;//流量按钮6
@property (weak, nonatomic) IBOutlet UIView *buttonView;//按钮所在的view


@property (weak, nonatomic) IBOutlet UIView *PayTypeView;//支付选择View
@property (weak, nonatomic) IBOutlet RadioButton *cardPay;//刷卡支付button
@property (weak, nonatomic) IBOutlet RadioButton *accountPay;//账户支付button




@property (weak, nonatomic) IBOutlet UILabel *flowLabelA1;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelB1;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelA2;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelB2;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelA3;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelB3;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelA4;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelB4;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelA5;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelB5;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelA6;
@property (weak, nonatomic) IBOutlet UILabel *flowLabelB6;

@property (nonatomic,strong) NSMutableArray *flowDetailArr;//接受后台返回的数据(流量包的详情)
@property (nonatomic,strong) NSMutableArray *productdescArr;

@property (weak, nonatomic) IBOutlet UILabel *FlowDescribeLabel;//流量描述label
@property (weak, nonatomic) IBOutlet UILabel *FlowDetailLabel;//流量详情,(展示流量包的具体信息,后台返回的数据详情)
@property (weak, nonatomic) IBOutlet UILabel *SeclectPay;//选择支付
@property (weak, nonatomic) IBOutlet UIButton *CardPayBtn;//刷卡支付btn
@property (weak, nonatomic) IBOutlet UIButton *AccountPayBtn;//账户支付btn
@property (weak, nonatomic) IBOutlet UIButton *comfirt;//确定按钮
//@property (nonatomic, strong) Request *request;


@property (nonatomic,retain) NSArray *flwArr;//
@property (nonatomic,retain) NSArray *countArr;//
@property (nonatomic,retain) NSArray *arr;

@property (nonatomic, strong) NSString *isAccount;//是否是账户充值的标准

@property (nonatomic,strong) NSString  *saveNumber;



@end

@implementation FlowRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.request = [[Request alloc]initWithDelegate:self];
    
    _count = 0;
     self.comfirt.layer.cornerRadius = 5;
    request = [[Request alloc]initWithDelegate:self];
    
    self.title = @"流量充值";
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];

    _PhoneNumberTextFild.delegate = self;
    _PhoneNumberTextFild.text = @"";
    _PhoneNumberDetailLabel.text = @"";

    [self creatBtn];
    payType = AccountPayType;
    self.isAccount = @"0";

    _button1.groupButtons = @[_button1,_button2,_button3,_button4,_button5,_button6];
    
//    _cardPay.groupButtons = @[_cardPay,_accountPay];
    
//    _button1.selected = YES;
//    _cardPay.selected = YES;
    
    
    self.productdescArr = [NSMutableArray array];
    
    self.flowDetailArr = [NSMutableArray  arrayWithCapacity:0];
    

     self.PhoneNumberTextFild.text = [[NSUserDefaults standardUserDefaults]objectForKey:UserPhone];

    _arrayDate = [NSMutableArray arrayWithCapacity:0];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    
    if ([_saveNumber length]>0) {
        
        self.PhoneNumberTextFild.text = _saveNumber;
        self.mobileNo = _saveNumber;
        
        [request getPhoneNumber:self.mobileNo];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中,请稍后..."];
        
    }else{
        self.PhoneNumberTextFild.text = [[NSUserDefaults standardUserDefaults]objectForKey:UserPhone];
        [request getPhoneNumber:[AppDelegate getUserBaseData].mobileNo];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中,请稍后..."];
    }
    
    
    [request getVirtualAccountBalance:@"00" token:[AppDelegate getUserBaseData].token];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"账户余额查询中.."];
    

    
    
    
}

- (void)creatBtn
{
    _button1.selected = YES;
    _button1.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    _flowLabelA1.textColor = [UIColor whiteColor];
    _flowLabelB1.textColor = [UIColor whiteColor];
    _button1.layer.borderColor = [Common hexStringToColor:@"47a8ef"].CGColor;
    [_button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
  
    
    
    _button2.layer.borderColor = [Common hexStringToColor:@"47a8ef"].CGColor;
    [_button2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _button3.layer.borderColor = [Common hexStringToColor:@"47a8ef"].CGColor;
    [_button3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    _button4.layer.borderColor = [Common hexStringToColor:@"47a8ef"].CGColor;
    [_button4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


    
    _button5.layer.borderColor = [Common hexStringToColor:@"47a8ef"].CGColor;
    [_button5 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _button6.layer.borderColor = [Common hexStringToColor:@"47a8ef"].CGColor;
    [_button6 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)btnClick:(UIButton *)btn {
    for (UIView *view in _buttonView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *selectedBtn = (UIButton *)view;
            
            if (selectedBtn.tag == btn.tag ) {
                selectedBtn.backgroundColor = [Common hexStringToColor:@"47a8ef"];
 
                _count = selectedBtn.tag -10010;
                
                _FlowDetailLabel.text = self.productdescArr[_count];
            }else {
                selectedBtn.backgroundColor = [UIColor whiteColor];
            }
        }
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *flowLabel = (UILabel *)view;
            if ((flowLabel.tag-1008610)/2 == btn.tag-10010) {
                flowLabel.textColor = [UIColor whiteColor];
            }else if (flowLabel.tag != 95550 && flowLabel.tag != 95551 && flowLabel.tag != 95552 && flowLabel.tag != 95553){
                flowLabel.textColor = [Common hexStringToColor:@"47a8ef"];
                
            }
        }
        
    }
}



//选择通讯录
- (IBAction)choosePeopleBook:(id)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:^{
        
    }];
    
}

#pragma mark  - ABPeoplePickerNavigationControllerDelegate


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);

    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    
    //    int i;
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        
        NSString *aPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        
        [phones addObject:aPhone];
        
    }
    
    NSLog(@"+qqqqqqqqqq++++%@",phones);
    
    
    NSLog(@"****************");
    
    if (!phones || !phones.count){
        //phones是空或nil
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"请选择正确的手机号码"];
        return;
    }
    NSString *mobileNo = [phones objectAtIndex:0];
    NSMutableString *newMobileNo = [NSMutableString stringWithString:@""];
    for (int i = 0; i < mobileNo.length; i ++) {
        NSString *str = [mobileNo substringWithRange:NSMakeRange(i, 1)];
        if (![str isEqualToString:@"-"]) {
            [newMobileNo appendString:str];
        }
        
    }
    if ([newMobileNo hasPrefix:@"+86 "]){
        newMobileNo = [NSMutableString stringWithString:[newMobileNo substringFromIndex:newMobileNo.length-11]];
    }
    _saveNumber = newMobileNo;
    
    phoneArray = [[NSDictionary alloc]init];
    

    
    //    self.label.text = (NSString*)ABRecordCopyCompositeName(person);
    
    
    NSLog(@"++++++++++++++++++++%@",newMobileNo);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//- (IBAction)comfirtBtn:(id)sender {
//    
//    //判断号码
//    if (_PhoneNumberTextFild.text.length == 0) {
//        [Common showMsgBox:@"" msg:L(@"InputNumber") parentCtrl:self];//请输入手机号码
//        return;
//    }else if (![Common isPhoneNumber:_PhoneNumberTextFild.text]) //如果 输入号码格式错误
//    {
//        [Common showMsgBox:@"" msg:L(@"MobilePhoneNumberIsWrong") parentCtrl:self]; //手机号码错误 重输
//        return;
//        
//    }
//}


- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
 
    if ([[dict objectForKey:@"respCode"] isEqualToString:@"0000"]) {
       
        //流量充值-查询手机号返回
        if (type == REQUEST_GETPHONENUMBER){
            _saveNumber = @"";
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([[[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"resultCode"] isEqualToString:@"8897"]) {
                [Common showMsgBox:nil msg:@"暂不支持该号码" parentCtrl:self];
                _PhoneNumberTextFild.text = @"";
                if ([_PhoneNumberTextFild.text length] == 0) {
//                    _buttonView.hidden = YES
                    ;
                }
            }else{
                
                
                NSString *numberStr = [[[dict objectForKey:@"data"] objectForKey:@"ispinfo"]objectForKey:@"provincename"];
                NSString *phoneTypeStr = [[[dict objectForKey:@"data"] objectForKey:@"ispinfo"]objectForKey:@"isptype"];
                NSString *phoneStr = [NSString stringWithFormat:@"%@%@",numberStr,phoneTypeStr];
                
                
                if ([phoneStr isEqualToString:@"(null)(null)"]) {
                    self.PhoneNumberDetailLabel.text = @"";
                }else {
                    self.PhoneNumberDetailLabel.text = phoneStr;
                }
                
                if ([_arrayDate count]>0) {
                    [_arrayDate removeAllObjects];

                }
                
                
                
                //        选择流量
                self.flwArr = @[_flowLabelA1,_flowLabelA2,_flowLabelA3,_flowLabelA4,_flowLabelA5,_flowLabelA6];
                
                self.countArr = @[_flowLabelB1,_flowLabelB2,_flowLabelB3,_flowLabelB4,_flowLabelB5,_flowLabelB6];
                
                self.arr = [[dict objectForKey:@"data"]objectForKey:@"tfinfo"];
     
                
                
                
                for (NSInteger i = 0; i<self.arr.count; i++) {
                    NSDictionary *flwDic = self.arr[i];
                    NSString *flwStr = flwDic[@"flowsize"];
                    NSString *amount = flwDic[@"amount"];
                    [_arrayDate addObject:amount];
                    
                    NSInteger flw = flwStr.integerValue;
                    UILabel *labelA = _flwArr[i];
                    labelA.text = [NSString stringWithFormat:@"%liM",(long)flw];
                    
                    self.labelB = _countArr[i];
                    
                    self.amountAmt = flwDic[@"amount"];
                    NSInteger count = self.amountAmt.integerValue;
                    self.labelB.text = [NSString stringWithFormat:@"售价%li元",(long)count];
   
                }
            
                if (_flowDetailArr.count>0) {
                    [_flowDetailArr removeAllObjects];
                }
                
                //流量描述
                self.flowDetailArr = [[dict objectForKey:@"data"]objectForKey:@"tfinfo"];
                [self.productdescArr removeAllObjects];
                for (NSInteger j = 0; j<self.flowDetailArr.count; j++) {

                    NSDictionary *productdescDict = self.flowDetailArr[j];
                    NSString *productdescStr = productdescDict[@"productdesc"];
                    [self.productdescArr addObject:productdescStr];

                }
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    _FlowDetailLabel.text = [_flowDetailArr[_count] objectForKey:@"productdesc"];
                   orderAmt =  _arrayDate[_count];

                });

            }
            
        }else if (type == REQUEST_ACCTENQUIRY){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *accountMoney = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"availableAmt"] floatValue]/100];

            _accountMoney = [accountMoney floatValue];
            

        }
    
    else if(type == REQUSET_ORDER){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //申请订单成功
        orderData = [[OrderData alloc]initWithData:dict];
        //            orderData.orderType = [numArr objectAtIndex:payType];
        orderData.orderAccount = self.PhoneNumberTextFild.text;
        orderData.orderPayType  = payType;
//        orderData.orderAmt = [Common rerverseOrderAmtFormat:orderData.orderAmt];
        
//        NSString *str = [self.amountAmt stringByReplacingOccurrencesOfString:@"￥" withString:@""];
//        NSString *orderAmt = [Common orderAmtFormat:str];
//        
//        NSLog(@"%@  %@",self.amountAmt,orderAmt);

        
        orderData.productId =  @"0000000000";
        orderData.merchantId = @"0001000006";
        [self performSegueWithIdentifier:@"FlowRechargeSegue" sender:self.comfirt];
        
    }
    
  }
}


//确认支付
- (IBAction)flowComfirt:(id)sender {
//    if ([identifier isEqualToString:@"FlowRechargeSegue"]){
    
    
    if([Common isPhoneNumber:self.PhoneNumberTextFild.text]){
        
        orderAmt = [Common orderAmtFormat:_arrayDate[_count]];

        if(payType == AccountPayType){
                if (_accountMoney < [_arrayDate[_count] floatValue] ) {
                    [Common showMsgBox:nil msg:@"账户余额不足" parentCtrl:self];
                }       else{
                    [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                                      MerchanId:@"0001000006"
                                      productId:@"0000000000"
                                       orderAmt:orderAmt
                                      orderDesc:self.PhoneNumberTextFild.text
                                    orderRemark:@""
                                   commodityIDs:@""
                                        payTool:@"02"];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"OrderIsSubmitted")];
                    
                }
        }
        
    }else  if (_PhoneNumberTextFild.text.length == 0) {
        [Common showMsgBox:@"" msg:L(@"InputNumber") parentCtrl:self];//请输入手机号码
        return;
    }
    
    else{
        
        [Common showMsgBox:@"" msg:L(@"MobilePhoneNumberIsWrong") parentCtrl:self];
        
    }
    
//    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[OrderViewController class]]) {
        [(OrderViewController*)segue.destinationViewController setOrderData:orderData];
        
    }
}



-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"FlowRechargeSegue"]) {
        if([Common isPhoneNumber:self.PhoneNumberTextFild.text]){
            
            if(payType == AccountPayType){
                
                
            }
        }
        
        return NO;
    }
    return NO;
}


#pragma ------------UITextField----------代理

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _PhoneNumberTextFild.text = @"";
    _PhoneNumberDetailLabel.text = @"";
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
 self.navigationController.navigationBar.userInteractionEnabled = YES;
    if (textField.text.length == 0) {
        [Common showMsgBox:@"" msg:L(@"InputNumber") parentCtrl:self];
        
//        _buttonView.hidden = YES;
        return;
    }
    
    if(![Common isPhoneNumber:textField.text]){
        [Common showMsgBox:@"" msg:L(@"MobilePhoneNumberIsWrong") parentCtrl:self];
//        _buttonView.hidden = YES;
        
        return;
    }
    
    if ([textField.text length]>0) {
//        _buttonView.hidden = NO;
         [request getPhoneNumber:self.PhoneNumberTextFild.text];
         [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中,请稍后..."];
    }
   

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
