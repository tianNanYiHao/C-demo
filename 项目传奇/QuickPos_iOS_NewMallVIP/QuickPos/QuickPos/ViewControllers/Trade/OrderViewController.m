//
//  OrderViewController.m
//  QuickPos
//
//  Created by 胡丹 on 15/3/18.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//
#import "LocationManager.h"
#import "OrderViewController.h"
#import "Request.h"
#import "OrderData.h"
#import <MESDK/MESDK.h>
#import "PosManager.h"
#import "CardInfoModel.h"
#import "Common.h"
#import "PayType.h"
#import "HandSignViewController.h"
#import "MyBankListViewController.h"
#import "OrderReceiptViewController.h"
#import "QuickPosTabBarController.h"
#import "MBProgressHUD+Add.h"
#import "Pos.h"
#import "vcom.h"
#import "ITronBlueToothVpos.h"
#import "LianDiBlueToothVpos.h"
#import "UPPayPlugin.h"
#import "PSTAlertController.h"
#import "MyCreditCardMachineViewController.h"



@interface OrderViewController ()<ResponseData,PosResponse,UIAlertViewDelegate,HandSignActionDelegate,CSwiperStateChangedListener,LianDiBlueToothVposDelegate,UPPayPluginDelegate,ResponseData>{
    CardInfoModel *cardInfoModel;
    NSString *password;
    UIImage *takImg;
    NSTimer*timer;
    int second;
    BOOL printType;
    MBProgressHUD *hud;
    NSMutableArray *deviceArr;
    Request *_request;
    
    
    
}

@property (weak, nonatomic) IBOutlet UIView *swiperingView;
@property (weak, nonatomic) IBOutlet UIImageView *swiperingImage;
@property (weak, nonatomic) IBOutlet UILabel *swiperingTitle;

@property (weak, nonatomic) IBOutlet UILabel *orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *orderAccount;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *getCodeView;
@property (nonatomic, strong) MBProgressHUD *hub;
@property (weak, nonatomic) IBOutlet UIButton *comfirt;
@property (nonatomic, strong)vcom *mVcom;
@property (nonatomic, strong) NSString *isBluetooth;
@property (nonatomic, strong) LianDiBlueToothVpos *lianDiBlueVC;
@end

@implementation OrderViewController
@synthesize handSignViewController;
@synthesize delegate;
@synthesize swiperingView;
@synthesize mVcom;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    
   

    printType = NO;
    self.navigationItem.title = L(@"TheOrderInformation");
    
    NSMutableDictionary *textAttributes = [NSMutableDictionary dictionary];
    textAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    //导航行颜色设置
    self.navigationController.navigationBar.barTintColor = [Common hexStringToColor:@"3B3839"];
    
    self.comfirt.layer.cornerRadius = 5;
    self.orderNumber.text = self.orderData.orderId;
    self.orderPrice.text = [Common rerverseOrderAmtFormat:self.orderData.orderAmt];
    
    if(self.orderData.orderPayType == CardPayType){
        self.orderType.text = L(@"CreditCardPayment");
    }else if(self.orderData.orderPayType == AccountPayType){
        self.orderType.text = L(@"AccountToPay");
    }else{
        self.orderType.text = L(@"QuickPayment");
    }
    self.orderAccount.text = self.orderData.orderAccount;
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;//解决向下偏移
    }
    swiperingView.hidden = YES;
    self.swiperingImage.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2 - 120, 20, 240, 240);
    self.swiperingTitle.frame = CGRectMake(0, 170, CGRectGetWidth(self.view.frame), 240);
    if (self.orderData.orderPayType == AccountPayType) {
        self.getCodeView.hidden = NO;
    }else{
        self.getCodeView.hidden = YES;
    }
    
  
    
   
    
//    if (self.orderData.orderPayType == CardPayType) {
//        
//        if (iOS8) { //防止5s奔溃
//            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//            [center addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请选择刷卡器类型?" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"音频" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                self.isBluetooth = @"1";
//                
//            }];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"蓝牙") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                self.isBluetooth = @"0";
//                
//            }];
//            [alert addAction:defaultAction];
//            [alert addAction:cancelAction];
//            [self presentViewController:alert animated:YES completion:nil];
//        }else
//        {
//            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//            [center addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];
//            self.isBluetooth = @"0";
//        }
//    }
    
    self.isBluetooth = @"1";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideswiperingView) name:@"hideswiperingView" object:nil];
    
}

- (void)hideswiperingView{
    swiperingView.hidden = NO;
}
- (void)noticePost:(NSNotification*)noti{
    
    [self.hub hide:YES afterDelay:2];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *transLogNo = [NSString stringWithFormat:@"%06d",[[user objectForKey:@"transLogNo"] integerValue]];
    [[PosManager getInstance]cswipecardTransLogNo:transLogNo orderId:self.orderData.orderId delegate:self];
    swiperingView.hidden = NO;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    if (self.orderData.orderPayType == CardPayType) {
        
        if ([_payWay isEqualToString:@"音频"]) {
            PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"" message:@"使用音频前,请关闭系统蓝牙"];
            [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"关闭" handler:^(PSTAlertAction *action) {
                NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }]];
            [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"取消" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
                
            }]];
            [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];
        }
        else if([_payWay isEqualToString:@"蓝牙"]){
            _request = [[Request alloc] initWithDelegate:self]; //检测是否已经绑定设备
            [_request getBuleToothDeviceNumberWithInteger:@"1" deviceId:@"" psamId:@"" PhoneNumber:nil];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在核对您的蓝牙"];
        }
        
    }
    
    
    swiperingView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[PosManager getInstance].pos stop];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)getMobileMacCode:(UIButton *)sender {
    
    if (self.orderData.orderPayType == AccountPayType) {
        Request *req = [[Request alloc]initWithDelegate:self];
        [req getMobileMacWithAccount:[AppDelegate getUserBaseData].mobileNo appType:@"JFPalAcctPay"];
        second =60;
        [timer invalidate];
        timer=nil;
        timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeats) userInfo:nil repeats:YES];
        
    }
    
}

- (void)repeats
{
    
    if (second >0)
    {  --second;
        
        self.getCodeBtn.enabled = NO;
        [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
        [self.getCodeBtn setTitle:[NSString stringWithFormat:L(@"ToResendToSecond"),second] forState:UIControlStateNormal];
    }
    else
    {
        //[self.getCodeBtn setBackgroundImage:[UIImage imageNamed:@"fasongyanzma2.png"] forState:UIControlStateNormal];
        self.getCodeBtn.enabled =YES;
        
        [self.getCodeBtn setTitle:[NSString stringWithFormat:L(@"ToResend")] forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
    }
    
}

//确认支付
- (IBAction)actionPay:(UIButton *)sender {

    if (self.orderData.orderPayType == AccountPayType) {
        if (self.codeTextField.text.length == 0) {
            [Common showMsgBox:nil msg:L(@"VerificationCodeCannotBeEmpty") parentCtrl:self];
        }else{
            if (iOS8) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:L(@"PleaseEnterTradingPassword") preferredStyle:UIAlertControllerStyleAlert];
                [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.placeholder = L(@"TradePassword");
                    textField.secureTextEntry = YES;
                    
                }];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if ([(UITextField*)[alert.textFields objectAtIndex:0] text].length == 0) {
                        [Common showMsgBox:nil msg:L(@"PasswordCannotBeEmpty") parentCtrl:self];
                    }else{
                        hud = [MBProgressHUD showMessag:@"正在交易中，请稍后" toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                        Request *req = [[Request alloc]initWithDelegate:self];
                        [req acctPay:[AppDelegate getUserBaseData].mobileNo encodetype:nil password:[(UITextField*)[alert.textFields objectAtIndex:0] text] mobileMac:self.codeTextField.text acctType:@"00" merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId orderAmt:self.orderData.orderAmt encodeType:nil payType:@"02"];
                    }
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"PleaseEnterTradingPassword") message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
                alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [[alert textFieldAtIndex:0] setPlaceholder:L(@"TradePassword")];
                alert.tag = AccountPayType;
                [alert show];
            }
        }
    }else if(self.orderData.orderPayType == CardPayType){
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];
        
        if ([_payWay isEqualToString:@"音频"]) {
            
            self.isBluetooth = @"1";
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"closeBluetooth" object:nil];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *transLogNo = [NSString stringWithFormat:@"%06d",[[user objectForKey:@"transLogNo"] integerValue]];
            
            if([[PosManager getInstance] getPluggedType])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回到主线程队列,进行UI的刷新
                    swiperingView.hidden = NO;
                });
                dispatch_queue_t queue = dispatch_queue_create("firstQueue", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, ^(void) {
                    [[PosManager getInstance]cswipecardTransLogNo:transLogNo orderId:self.orderData.orderId delegate:self];
                });
            }else{
                [Common showMsgBox:@"" msg:@"未检测到刷卡头,请插入重试" parentCtrl:self];
            }
            
        }else if([_payWay isEqualToString:@"蓝牙"]){
            
            if([[PosManager getInstance].pos hasHeadset]){  //如果插入刷卡头 也会启动蓝牙 为避免
                [Common showMsgBox:@"您选择了蓝牙刷卡方式" msg:@"检测到您插入了音频,请拔出音频重试" parentCtrl:self];
            }else{
                
                    self.isBluetooth = @"0";
                    NSString *s=
                    [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
                    self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:[NSString stringWithFormat:@"%@ 搜索中..",s]];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHUD:) name:@"closeHUD" object:nil];
                    [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
                    
                }
       }
    }else{
        NSLog(@"选择了继续快捷支付");
        UIStoryboard *quick = [UIStoryboard storyboardWithName:@"QuickPay" bundle:nil];
        MyBankListViewController *myBankListCtrl = [quick instantiateViewControllerWithIdentifier:@"MyBankListViewController"];
        [myBankListCtrl setOrderData:self.orderData];
        [self.navigationController pushViewController:myBankListCtrl animated:YES];

    }
}


- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    //回调无论成功失败都hideMBP
    [hud hide:YES];
    
    if (type == REQUEST_GETBULETOOHTHNUMBER) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *tsf = [[dict objectForKey:@"data"] objectForKey:@"tsf"];
        if (tsf.count == 0 || [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"] == nil) {
            PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"" message:@"您还未选择蓝牙,请前往'我的刷卡器选择'"];
            
            [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"确认" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
                
                MyCreditCardMachineViewController *myCreditCardMachineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCreditCardMachineVC"];
                myCreditCardMachineVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCreditCardMachineVC animated:YES];//我的刷卡器
                
            }]];
            [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];
  
        }else{
            //
        }
    }
    
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0002"] || [[dict objectForKey:@"respCode"]isEqualToString:@"0001"])
    {
        [[QuickPosTabBarController getQuickPosTabBarController] gotoLoginViewCtrl];
    }
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        
        if (type == REQUEST_USERSIGNATUREUPLOAD) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            OrderReceiptViewController *rv = [[OrderReceiptViewController alloc] init];
            rv.order = self.orderData;
            rv.printInfo = _printInfo;
            rv.signImg = takImg;
            [self.navigationController pushViewController:rv animated:YES];
            
        }
        else if (type == REQUSET_JFPALCARDPAYFORSTORE)
        {
            [self.delegate getOrderType:YES];
            self.printInfo = [NSString stringWithFormat:@"%@", [dict objectForKey:@"printInfo"]];
            if ([[PosManager getInstance] getBigType]) {
                if (self.printInfo && self.printInfo.length > 0) {
                    NSArray *a = [_printInfo componentsSeparatedByString:@","];
                    [self print:a pCnt:2];
                }
            }
            else if (![[PosManager getInstance] getBigType])
            {
                //商城刷卡支付成功
                if(!self.handSignViewController) {
                    self.handSignViewController = [[HandSignViewController alloc] init];
                }
                QuickPosTabBarController *q = [QuickPosTabBarController getQuickPosTabBarController];
                handSignViewController.delegate = q;
                handSignViewController.view.hidden = NO;
                handSignViewController.printInfo = _printInfo;
                [handSignViewController setOrder:self.orderData];
                
                q.printInfo = _printInfo;
                q.orderData = self.orderData;
                [handSignViewController showPanelIn:q.view];
            }
        }
        else if (type == REQUSET_JFPALCARDPAY) {
            //刷卡支付成功
            self.printInfo = [NSString stringWithFormat:@"%@", [dict objectForKey:@"printInfo"]];
            if ([[PosManager getInstance] getBigType]) {
                if (self.printInfo && self.printInfo.length > 0) {
                    NSArray *a = [_printInfo componentsSeparatedByString:@","];
                    [self print:a pCnt:2];
                }
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"SuccessfulDeal")];
            [self performSelector:@selector(gobackRootCtrl) withObject:nil afterDelay:2.0];
            
        }else if(type == REQUEST_GETMOBILEMAC){
            
            //获取验证码
            
            [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"VerificationCodeSentSuccessfully")];
        }
        else if(type == REQUSET_JFPALACCTPAY)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearShoppingCartNotification" object:[NSString stringWithFormat:@"%d",YES]];
            //账户支付成功
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"SuccessfulDeal")];
            [self performSelector:@selector(gobackRootCtrl) withObject:nil afterDelay:2.0];
            
        }
    }else{
        NSString *desc = [dict objectForKey:@"respDesc"];
        if ((type == REQUSET_JFPALACCTPAY || type == REQUSET_JFPALCARDPAYFORSTORE || type == REQUSET_JFPALCARDPAY || type == REQUEST_QUICKBANKCARDAPPLY)) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        [Common showMsgBox:nil msg:desc parentCtrl:self];
    }
    
}

#pragma mark - request代理方法二
-(void)getTNWithString:(NSString *)tnn{
    

     [UPPayPlugin startPay:tnn
                      mode:@"01"
            viewController:self
                  delegate:self];
    
}

- (void)gobackRootCtrl{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
//-(void)posResponseDataWithCardInfoModelWithLianDi:(CardInfoModel *)cardInfo{
//    //蓝牙支付返回数据
//    if (cardInfo) {
//        NSLog(@"卡信息 ----> %@",cardInfo.cardInfo);
//        cardInfoModel = cardInfo;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回到主线程队列,进行UI的刷新
//            swiperingView.hidden = YES;
//            if (!cardInfo.hasPassword) {
//                if (iOS8) {
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"EnterBankCardPassword") message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                        textField.placeholder = @"密码";
//                        textField.secureTextEntry = YES;
//                        
//                    }];
//                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                        password = [(UITextField*)[alert.textFields objectAtIndex:0] text];
//                        if (password.length == 0) {
//                            password = @"FFFFFF";
//                        }
//                        hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
//                        Request *req = [[Request alloc]initWithDelegate:self];
//                        if(self.orderData.mallOrder == YES)
//                        {
//                            [req mallCardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
//                            
//                        }
//                        else
//                        {
////                            [req cardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
//                        }
//                    }];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                        [hud hide:YES];
//                    }];
//                    [alert addAction:defaultAction];
//                    [alert addAction:cancelAction];
//                    [self presentViewController:alert animated:YES completion:nil];
//                }else{
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"EnterBankCardPassword") message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
//                    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
//                    alert.tag = CardPayType;
//                    [alert show];
//                    
//                }
//                
//            }else{
//                if (cardInfo) {
//                    hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
//                    Request *req = [[Request alloc]initWithDelegate:self];
//                    if(self.orderData.mallOrder == YES)
//                    {
//                        [req mallCardPay:cardInfoModel.cardInfo cardPassWord:@"FFFFFF" iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
//                    }
//                    else
//                    {
////                        [req cardPay:cardInfoModel.cardInfo cardPassWord:@"FFFFFF" iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
//                    }
//                }
//            }
//        });
//        
//    }
//
//}
-(void)posResponseDataWithCardInfoModel:(CardInfoModel *)cardInfo
{
    
    if ([self.navigationController.viewControllers containsObject:self]) {
        if ([[PosManager getInstance].pos hasHeadset]) {
            
            if (cardInfo) {
                NSLog(@"卡信息 ----> %@",cardInfo.cardInfo);
                cardInfoModel = cardInfo;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回到主线程队列,进行UI的刷新
                    swiperingView.hidden = YES;
                    if (cardInfo.hasPassword) {
                        if (iOS8) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"EnterBankCardPassword") message:nil preferredStyle:UIAlertControllerStyleAlert];
                            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                textField.placeholder = @"密码";
                                textField.secureTextEntry = YES;
                                
                            }];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                password = [(UITextField*)[alert.textFields objectAtIndex:0] text];
                                if (password.length == 0) {
                                    password = @"FFFFFF";
                                }
                                hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                                Request *req = [[Request alloc]initWithDelegate:self];
                                if(self.orderData.mallOrder == YES)
                                {
                                    [req mallCardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
                                    
                                }
                                else
                                {
                                    NSLog(@"%@%@%@%@%@%@%@%@%@",cardInfoModel.cardInfo,password,cardInfoModel.data55,cardInfoModel.sequensNo,cardInfoModel.expiryDate,self.orderData.merchantId,self.orderData.productId,self.orderData.orderId,self.orderData.orderAmt);
                                    
                                    [req cardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
                                    
                                }
                            }];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                [hud hide:YES];
                            }];
                            [alert addAction:defaultAction];
                            [alert addAction:cancelAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"EnterBankCardPassword") message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
                            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                            alert.tag = CardPayType;
                            [alert show];
                            
                        }
                        
                    }else{
                        if (cardInfo) {
                            hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                            Request *req = [[Request alloc]initWithDelegate:self];
                            if(self.orderData.mallOrder == YES)
                            {
                                [req mallCardPay:cardInfoModel.cardInfo cardPassWord:@"FFFFFF" iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
                            }
                            else
                            {
                                [req cardPay:cardInfoModel.cardInfo cardPassWord:@"FFFFFF" iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
                            }
                        }
                    }
                });
                
            }
        }else{
            
            //蓝牙支付返回数据
            if (cardInfo) {
                NSLog(@"卡信息 ----> %@",cardInfo.cardInfo);
                cardInfoModel = cardInfo;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回到主线程队列,进行UI的刷新
                    swiperingView.hidden = YES;
                    if (cardInfo.hasPassword) {
                        if (iOS8) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"EnterBankCardPassword") message:nil preferredStyle:UIAlertControllerStyleAlert];
                            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                textField.placeholder = @"密码";
                                textField.secureTextEntry = YES;
                                
                            }];
                            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                password = [(UITextField*)[alert.textFields objectAtIndex:0] text];
                                if (password.length == 0) {
                                    password = @"FFFFFF";
                                }
                                hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                                Request *req = [[Request alloc]initWithDelegate:self];
                                if(self.orderData.mallOrder == YES)
                                {
                                    [req mallCardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
                                    
                                }
                                else
                                {
                                    [req cardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
                                }
                            }];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                [hud hide:YES];
                            }];
                            [alert addAction:defaultAction];
                            [alert addAction:cancelAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"EnterBankCardPassword") message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
                            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                            alert.tag = CardPayType;
                            [alert show];
                            
                        }
                        
                    }else{
                        if (cardInfo) {
                            hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                            Request *req = [[Request alloc]initWithDelegate:self];
                            if(self.orderData.mallOrder == YES)
                            {
                                [req mallCardPay:cardInfoModel.cardInfo cardPassWord:@"FFFFFF" iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
                            }
                            else
                            {
                                [req cardPay:cardInfoModel.cardInfo cardPassWord:@"FFFFFF" iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
                            }
                        }
                    }
                });
                
            }
        }
        
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Request *req = [[Request alloc]initWithDelegate:self];
    
//    //是否登记蓝牙刷卡头
//    if (alertView.tag == 100789) {
//        if (buttonIndex == 0) {  //已绑定过 直接搜索
//            self.isBluetooth = @"0";
//            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"蓝牙设备搜索中..."];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHUD:) name:@"closeHUD" object:nil];
//            [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
//            
//        }else if (buttonIndex == 1){  //去绑定 替换uuidName
//            
//            [[NSUserDefaults standardUserDefaults] setObject:[[alertView textFieldAtIndex:0] text] forKey:@"uuidName"];
//            self.isBluetooth = @"0";
//            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"蓝牙设备搜索中..."];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHUD:) name:@"closeHUD" object:nil];
//            [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
//        }
//    }

//    //新增银联SDK快捷支付 tag : 9527
//    if (alertView.tag == 9527) {
//        if (buttonIndex == 0) {
//            NSLog(@"选择了继续快捷支付");
//            
//            UIStoryboard *quick = [UIStoryboard storyboardWithName:@"QuickPay" bundle:nil];
//            MyBankListViewController *myBankListCtrl = [quick instantiateViewControllerWithIdentifier:@"MyBankListViewController"];
//            [myBankListCtrl setOrderData:self.orderData];
//            [self.navigationController pushViewController:myBankListCtrl animated:YES];
//            
//        }else{
//            NSLog(@"选择了银联在线支付");
//            Request *r = [[Request alloc] initWithDelegate:self];
//            
//            [r getTN];
//  
//        }
//    }
    
    //原本业务处理
    {
        
        if (alertView.tag == CardPayType) {
            if (buttonIndex == 1) {
                password = [(UITextField*)[alertView textFieldAtIndex:0] text];
                if (password.length == 0) {
                    password = @"FFFFFF";
                }
                hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                if(self.orderData.mallOrder == YES)
                {
                    [req mallCardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt payType:@"01"];
                }
                else
                {
                    NSLog(@"----------------++++++++++++++++++++%@%@%@%@%@%@%@%@%@",cardInfoModel.cardInfo,password,cardInfoModel.data55,cardInfoModel.sequensNo,cardInfoModel.expiryDate,self.orderData.merchantId,self.orderData.productId,self.orderData.orderId,self.orderData.orderAmt);
                    NSLog(@"%@%@",self.orderData.productId,self.orderData.merchantId);
                    
                    [req cardPay:cardInfoModel.cardInfo cardPassWord:password iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId encodeType:@"bankpassword" orderAmt:self.orderData.orderAmt  payType:@"01"];
                }
                
                
            }else{
                [hud hide:YES];
            }
            
        }else{
            
            if (buttonIndex == 1) {
                if ([(UITextField*)[alertView textFieldAtIndex:0] text].length == 0) {
                    [Common showMsgBox:nil msg:L(@"PasswordCannotBeEmpty") parentCtrl:self];
                    //                [req acctPay:[AppDelegate getUserBaseData].mobileNo encodetype:nil password:[(UITextField*)[alertView textFieldAtIndex:1] text] mobileMac:self.codeTextField.text acctType:@"00" merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId orderAmt:self.orderData.orderAmt encodeType:nil payType:@"02"];
                    
                }else{
                    hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                    [req acctPay:[AppDelegate getUserBaseData].mobileNo encodetype:nil password:[(UITextField*)[alertView textFieldAtIndex:1] text] mobileMac:self.codeTextField.text acctType:@"00" merchantId:self.orderData.merchantId productId:self.orderData.productId orderId:self.orderData.orderId orderAmt:self.orderData.orderAmt encodeType:nil payType:@"02"];
                }
                
            }else{
                [hud hide:YES];
            }
            
            
        }
        
        
        
    }
    
    
}

- (void) handsignFinished: (UIImage *) img {
    takImg = img;
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(img)];
    
    NSMutableString *handsignString = [NSMutableString stringWithCapacity:([imageData length] * 2)];
    const unsigned char *dataBuffer = (unsigned char *) [imageData bytes];
    for (int i = 0; i < [imageData length]; ++i) {
        [handsignString appendFormat:@"%02X", (unsigned) dataBuffer[i]];
    }
    
    NSString *imageHash = [Utils md5WithData:imageData];
    
    NSString *longitude = [NSString stringWithFormat:@"%.2f",[AppDelegate getUserBaseData].lon];
    NSString *latitude = [NSString stringWithFormat:@"%.2f",[AppDelegate getUserBaseData].lat];
    //执行图片上传
    Request *req = [[Request alloc]initWithDelegate:self];
    [req UserSignatureUploadMobile:[AppDelegate getUserBaseData].mobileNo longitude:longitude latitude:latitude merchantId:self.orderData.merchantId orderId:self.orderData.orderId signPicAscii:handsignString picSign:imageHash];
    
    hud = [MBProgressHUD showMessag:L(@"UploadSignaturePicture") toView:self.view];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"closeBluetooth" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeLDBluetooth" object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) print:(NSArray*) lineList pCnt:(int)_cnt {
    if( [[[PosManager getInstance].pos mVcom] rmPrint3:(NSMutableArray*) lineList pCnt:_cnt pakLen:400] == 0 )
    {
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"IsPrinting")];
        printType = YES;
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"PrinterError")];
        printType = NO;
    }
}

-(void)closeHUD:(NSNotification*)noti{
    [_hub hide:YES];
    
    NSDictionary *sDict = [[NSDictionary alloc] init];
    sDict = noti.userInfo;
    
    
    NSString *s = [sDict objectForKey:@"pipiNo"];
    NSString *s2 = [sDict objectForKey:@"pipiOver"];
    NSString *s3 = [sDict objectForKey:@"pipiTimeOut"];
    
    if (noti && [s isEqualToString:@"未搜索到匹配的蓝牙"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeHUD" object:nil];
        [Common showMsgBox:@"" msg:@"未搜索到匹配的蓝牙,请重新搜索" parentCtrl:self];
        
    }
    else if(noti && [s2 isEqualToString:@"蓝牙搜索结束"]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeHUD" object:nil];
        [Common showMsgBox:@"" msg:@"蓝牙搜索结束" parentCtrl:self];
    }
    else if(noti && [s3 isEqualToString:@"超时"]){
        [Common showMsgBox:@"" msg:@"蓝牙链接超时" parentCtrl:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeHUD" object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeHUD" object:nil];
        [Common showMsgBox:@"" msg:@"搜索到设备,但蓝牙连接失败,请重试" parentCtrl:self];
    }

}

@end
