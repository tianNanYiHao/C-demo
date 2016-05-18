//
//  PhoneRechargeViewController.m
//  QuickPos
//
//  Created by 张倡榕 on 15/3/6.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "PhoneRechargeViewController.h"
#import "NumberKeyBoard.h"
#import "Common.h"
#import "Request.h"
#import "UserBaseData.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UserInfoView.h"
#import "OrderViewController.h"
#import "OrderData.h"
#import "PayType.h"
#import "ChooseView.h"
#import "MBProgressHUD+Add.h"
#import "ROllLabel.h"



@interface PhoneRechargeViewController ()<ResponseData,ABPeoplePickerNavigationControllerDelegate,ChooseViewDelegate>{
    NSUInteger payType;//账户支付 刷卡支付 快捷支付
    Request *request;
    OrderData *orderData;
    MBProgressHUD *hud;

}
@property (weak, nonatomic) IBOutlet UIButton *phoneRechargeBtn;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *payTypeSeg;
@property (weak, nonatomic) IBOutlet UIView *_subview;

@property (weak, nonatomic) IBOutlet UIButton *comfirtButton;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerViewA;


@end

@implementation PhoneRechargeViewController
- (IBAction)ShowHide:(id)sender {
    self.pickerViewA.hidden = !self.pickerViewA.hidden;
}


@synthesize payLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    payLabel.text = @"50";
    if (!self.item) {
        self.Notes.text = L(@"Mobile phone recharge");
    }
    
    self.pickerViewA.hidden = YES;
    self.comfirtButton.layer.cornerRadius = 5;
//    self.Notes.text = [self.item objectForKey:@"announce"];
    [ROllLabel rollLabelTitle:[self.item objectForKey:@"announce"] color:[UIColor blackColor] backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:17.0] superView:self.Notes fram:CGRectMake(0, 0, self.Notes.frame.size.width, self.Notes.frame.size.height)];
    self.navigationItem.title = [self.item objectForKey:@"title"];
//    self.navigationItem.title = @"手机充值";
    // Do any additional setup after loading the view.
    payType = AccountPayType;
    
    //自定义键盘
    NumberKeyBoard*numberkeyboard=[[NumberKeyBoard alloc]init];
    [numberkeyboard setTextView:self.phoneNumberTextField];
    int count = 2;
//    self.payTypeSeg.hidden = YES;
    float x = (self._subview.frame.size.width - [ChooseView chooseWidth]*count)/2.0 - 60;
    float y = self.payLabel.frame.origin.y + self.payLabel.frame.size.height + 83;
//    [self._subview addSubview:[ChooseView creatChooseViewWithOriginX:x Y:y delegate:self count:count]];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
//    int count = ISQUICKPAY?3:2;
//    //    self.payTypeSeg.hidden = YES;
//    float x = (self._subview.frame.size.width - [ChooseView chooseWidth]*count)/2.0;
//    float y = self.payLabel.frame.origin.y + self.payLabel.frame.size.height + 16;
//    [self._subview addSubview:[ChooseView creatChooseViewWithOriginX:x Y:y delegate:self count:count]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选择通讯录
- (IBAction)chooseAddressBook:(UIButton *)sender {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:^{
        
    }];
}

#pragma mark  - ABPeoplePickerNavigationControllerDelegate

#pragma mark  - ChooseViewDelegate
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

//    switch (chooseIndex) {
//        case CardPayType:
//            payType = CardPayType;
//            break;
//        case AccountPayType:
//            
//            break;
//        case QuickPayType:
//            
//            break;
//
//        default:
//            break;
//    }
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
//    ABMutableMultiValueRef address=ABRecordCopyValue(person, kABPersonAddressProperty);
//    ABMutableMultiValueRef birthday=ABRecordCopyValue(person, kABPersonBirthdayProperty);
//    ABMutableMultiValueRef creationDate=ABRecordCopyValue(person, kABPersonCreationDateProperty);
//    ABMutableMultiValueRef date=ABRecordCopyValue(person, kABPersonDateProperty);
//    ABMutableMultiValueRef department=ABRecordCopyValue(person, kABPersonDepartmentProperty);
//    ABMutableMultiValueRef email=ABRecordCopyValue(person, kABPersonEmailProperty);
//    ABMutableMultiValueRef firstNamePhonetic=ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
//    ABMutableMultiValueRef firstName=ABRecordCopyValue(person, kABPersonFirstNameProperty);
//    ABMutableMultiValueRef instantMessage=ABRecordCopyValue(person, kABPersonInstantMessageProperty);
//    ABMutableMultiValueRef jobTitle=ABRecordCopyValue(person, kABPersonJobTitleProperty);
//    ABMutableMultiValueRef kind=ABRecordCopyValue(person, kABPersonKindProperty);
//    ABMutableMultiValueRef lastNamePhonetic=ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
//    ABMutableMultiValueRef lastName=ABRecordCopyValue(person, kABPersonLastNameProperty);
//    ABMutableMultiValueRef middleNamePhonetic=ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
//    ABMutableMultiValueRef middleName=ABRecordCopyValue(person, kABPersonMiddleNameProperty);
//    ABMutableMultiValueRef modificationDate=ABRecordCopyValue(person, kABPersonModificationDateProperty);
//    ABMutableMultiValueRef nickname=ABRecordCopyValue(person, kABPersonNicknameProperty);
//    ABMutableMultiValueRef note=ABRecordCopyValue(person, kABPersonNoteProperty);
//    ABMutableMultiValueRef organization=ABRecordCopyValue(person, kABPersonOrganizationProperty);
//    ABMutableMultiValueRef phone=ABRecordCopyValue(person, kABPersonPhoneProperty);
//    ABMutableMultiValueRef prefix=ABRecordCopyValue(person, kABPersonPrefixProperty);
//    ABMutableMultiValueRef relatedNames=ABRecordCopyValue(person, kABPersonRelatedNamesProperty);
//    ABMutableMultiValueRef socialProfile=ABRecordCopyValue(person, kABPersonSocialProfileProperty);
//    ABMutableMultiValueRef personSuffix=ABRecordCopyValue(person, kABPersonSuffixProperty);
//    ABMutableMultiValueRef _URL=ABRecordCopyValue(person, kABPersonURLProperty);
    
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    
    //    int i;
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        
        NSString *aPhone = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        
        [phones addObject:aPhone];
        
    }
    
    NSLog(@"+qqqqqqqqqq++++%@",phones);
    
    
    NSLog(@"****************");
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
    
        self.phoneNumberTextField.text = newMobileNo;
    
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


- (IBAction)choosePayType:(UISegmentedControl *)sender {
    payType = sender.selectedSegmentIndex;
}

//选择支付方式
//- (IBAction)choosePayType:(UIButton *)sender {
//    NSLog(@"%@",sender.description);
//    for (UIButton* btn in self.payTypeBtns) {
//        if (btn == sender) {
//            btn.enabled = NO;
//            btn.backgroundColor = [UIColor grayColor];
//            payType = [self.payTypeBtns indexOfObject:btn];
//        }else{
//            btn.enabled = YES;
//            btn.backgroundColor = [UIColor redColor];
//        }
//    }
//    NSLog(@"payType ==== %d",payType);
//}


#pragma mark - 确认充值
- (IBAction)phoneRecharge:(UIButton *)sender {
    if([Common isPhoneNumber:self.phoneNumberTextField.text]){
        
        NSString *str = [self.payLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        NSString *orderAmt = [Common orderAmtFormat:str];
        request = [[Request alloc]initWithDelegate:self];

        //账户支付
        if(payType == AccountPayType){
            
            [request getVirtualAccountBalance:@"00" token:[AppDelegate getUserBaseData].token];
            //刷卡支付
        }else if (payType == CardPayType){
            
            [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0001000001" productId:@"0000000000" orderAmt:orderAmt orderDesc:self.phoneNumberTextField.text orderRemark:@"" commodityIDs:@"" payTool:@"01"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"OrderIsSubmitted")];
        }else{
            //快捷支付
            [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0001000001" productId:@"0000000000" orderAmt:orderAmt orderDesc:self.phoneNumberTextField.text orderRemark:@"" commodityIDs:@"" payTool:@"03"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"OrderIsSubmitted")];
        }

    }
    else{

        [Common showMsgBox:@"" msg:L(@"MobilePhoneNumberIsWrong") parentCtrl:self];
        
    }
    
}


- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        if (type == REQUEST_USERLOGIN) {
            
            UserBaseData *u = [[UserBaseData alloc]initWithData:dict];
            if (u) {
                [AppDelegate getUserBaseData].token = u.token;
            }
            
        }else if(type == REQUEST_ACCTENQUIRY){
            //查询虚拟账户余额
            if([[dict objectForKey:@"availableAmt"] floatValue]>[self.payLabel.text floatValue]){
                //余额够
                NSString *str = [self.payLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
                NSString *orderAmt = [Common orderAmtFormat:str];                [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0001000001" productId:@"0000000000" orderAmt:orderAmt orderDesc:self.phoneNumberTextField.text orderRemark:@"" commodityIDs:@"" payTool:@"02"];
            
            }else{
                
                 [Common showMsgBox:@"" msg:L(@"AccountBalanceIsInsufficient") parentCtrl:self];
            
            }
            NSLog(@"availableAmt===%@",[dict objectForKey:@"availableAmt"]);
            NSLog(@"cashAvailableAmt===%@",[dict objectForKey:@"cashAvailableAmt"]);
            
        }else if(type == REQUSET_ORDER){
            [hud hide:YES];
            //申请订单成功
            orderData = [[OrderData alloc]initWithData:dict];
            //            orderData.orderType = [numArr objectAtIndex:payType];
            orderData.orderAccount = self.phoneNumberTextField.text;
            orderData.orderPayType  = payType;
//            orderData.orderAmt = [Common rerverseOrderAmtFormat:orderData.orderAmt];
            orderData.productId = @"0000000000";
            orderData.merchantId = @"0001000001";
            [self performSegueWithIdentifier:@"PhoneRechargeSegue" sender:self.phoneRechargeBtn];
            
        }

    }else{

        [Common showMsgBox:@"" msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
    }
    
}


#pragma mark - pickerView 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //拾取视图的列数
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{


    if (row == 0) {
        return [NSString stringWithFormat:@"￥%d",50];
    }else if (row == 1) {
        return [NSString stringWithFormat:@"￥%d",100];
    }else if (row == 2) {
        return [NSString stringWithFormat:@"￥%d",200];
    }else {
        return [NSString stringWithFormat:@"￥%d",300];
    }
    
    
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 4;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *numArr = @[@"￥50",@"￥100",@"￥200",@"￥300"];
    payLabel.text = [NSString stringWithFormat:@"%@",numArr[row]];
    
    self.pickerViewA.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[OrderViewController class]]) {
        [(OrderViewController*)segue.destinationViewController setOrderData:orderData];
        
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"PhoneRechargeSegue"]) {
        if([Common isPhoneNumber:self.phoneNumberTextField.text]){
            hud = [MBProgressHUD showMessag:L(@"IsSubmitRequest") toView:self.view];
            request = [[Request alloc]initWithDelegate:self];
            if(payType == AccountPayType){
                [request getVirtualAccountBalance:@"00" token:[AppDelegate getUserBaseData].token];
            }else if (payType == CardPayType){
                NSString *str = [self.payLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
                NSString *orderAmt = [Common orderAmtFormat:str];                [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0001000001" productId:@"0000000000" orderAmt:orderAmt orderDesc:self.phoneNumberTextField.text orderRemark:@"" commodityIDs:@"" payTool:@"01"];
            }else{
                //快捷支付
                NSString *str = [self.payLabel.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
                NSString *orderAmt = [Common orderAmtFormat:str];
                [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo MerchanId:@"0001000001" productId:@"0000000000" orderAmt:orderAmt orderDesc:self.phoneNumberTextField.text orderRemark:@"" commodityIDs:@"" payTool:@"03"];
            }
            
        }else{
            
            [Common showMsgBox:@"" msg:L(@"MobilePhoneNumberIsWrong") parentCtrl:self];
            
        }

        return NO;
    }
    return NO;
}


@end
