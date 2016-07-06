//
//  BalanceEnquiryViewController.m
//  QuickPos
//
//  Created by 张倡榕 on 15/3/6.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "BalanceEnquiryViewController.h"
#import "Request.h"
#import "PosManager.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "ROllLabel.h"
#import "QuickPosTabBarController.h"
#import "PayType.h"
#import "PSTAlertController.h"
#import "DCBlueToothManager.h"


#define UUIDNAME  [[NSUserDefaults standardUserDefaults] objectForKey:@"SerialNumber"]

@interface BalanceEnquiryViewController ()<ResponseData,PosResponse,UIAlertViewDelegate,DCBlueToothManagerDelegate>{
    CardInfoModel *cardInfoModel;
    MBProgressHUD *hud;
    NSString *password;
    Request *_request;

}


@property (weak, nonatomic) IBOutlet UIView *swiperingView;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;

@property (weak, nonatomic) IBOutlet UIButton *comfirt;

@property (weak, nonatomic) IBOutlet UIView *blanceMoneyVIew;   //view
@property (weak, nonatomic) IBOutlet UILabel *myBlanceLab;  //我的账户余额 文字
@property (weak, nonatomic) IBOutlet UILabel *balanceMoneyLab;  //moneyLab 余额
@property (weak, nonatomic) IBOutlet UIButton *sureMoneyBtn;  //确认按钮
@property (nonatomic,strong) MBProgressHUD *hub;
@property (nonatomic,strong) NSString *isBluetooth;
@property (nonatomic,strong) PayWayViewController *payWayViewC;
@property (nonatomic,strong) NSString *payWay;
@property (nonatomic,strong) DCBlueToothManager *dcBlueToothManager;

@end

@implementation BalanceEnquiryViewController
@synthesize swiperingView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.comfirt.layer.cornerRadius = 5;
    if (!self.item) {
        self.navigationItem.title = L(@"BalanceInquiry");
    }
//    self.notes.text = [self.item objectForKey:@"announce"];
    [ROllLabel rollLabelTitle:[self.item objectForKey:@"announce"] color:[UIColor blackColor] backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:17.0] superView:self.notes fram:CGRectMake(0, 0, self.notes.frame.size.width, self.notes.frame.size.height)];
    self.navigationItem.title = [self.item objectForKey:@"title"];
    // Do any additional setup after loading the view.
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;//解决向下偏移
    }
    swiperingView.hidden = YES;
    
//    NumberKeyBoard *keyBoard = [[NumberKeyBoard alloc]init];
//    [keyBoard setTextView:self.cardNum];

    ////blanceMoneyView 内容
    _balanceMoneyLab.textColor = [Common hexStringToColor:@"#333333"];
    _myBlanceLab.textColor = [Common hexStringToColor:@"#333333"];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];
    
    self.isBluetooth = @"0";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideswiperingView) name:@"hideswiperingView" object:nil];
    //动联蓝牙通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticePostDCBlue:) name:@"startswipe" object:nil];
    
    //刷卡器选择页面
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _payWayViewC = [SB instantiateViewControllerWithIdentifier:@"PayWayViewController"];
    [self addChildViewController:_payWayViewC];
    [self.view addSubview:_payWayViewC.view];
    _payWayViewC.view.hidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payWayChange:) name:@"payWayChange" object:nil];
    

}
- (void)noticePostDCBlue:(NSNotification *)noti{
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = noti.userInfo;
    NSString *showSwiper = [dict objectForKey:@"showSwipe"];
    
    if ([showSwiper isEqualToString:@"yes"]) {
        swiperingView.hidden = NO;
    }else if ([showSwiper isEqualToString:@"no"]){
        swiperingView.hidden = YES;
    }
    
    
}
- (void)hideswiperingView{
    swiperingView.hidden = NO;
}
-(void)payWayChange:(NSNotification*)noti{
    
    _payWay =  [noti.userInfo objectForKey:@"payway"];
    NSLog(@"payWay ======== is %@" ,_payWay);
    
}
- (void)noticePost:(NSNotification*)noti{
    
    [self.hub hide:YES afterDelay:2];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *transLogNo = [NSString stringWithFormat:@"%06d",[[user objectForKey:@"transLogNo"] integerValue]];
    [[PosManager getInstance]cswipecardTransLogNo:transLogNo orderId:@"0000000000000000" delegate:self];
    swiperingView.hidden = NO;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    swiperingView.hidden = YES;
    _blanceMoneyVIew.hidden = YES;
    self.cardNum.text = L(@"CardBalance");
    
    _payWayViewC.view.hidden = NO;
    
    
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
    else if([_payWay isEqualToString:@"itron蓝牙"] || [_payWay isEqualToString:@"动联蓝牙"]){
        _request = [[Request alloc] initWithDelegate:self]; //检测是否已经绑定设备
        [_request getBuleToothDeviceNumberWithInteger:@"1" deviceId:@"" psamId:@"" PhoneNumber:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在核对您的蓝牙"];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [[PosManager getInstance].pos stop];
}

//查询余额
- (IBAction)checkBalanceEnquiry:(UIButton *)sender {

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *transLogNo = [NSString stringWithFormat:@"%06d",[[user objectForKey:@"transLogNo"] integerValue]];
    
    
    if ([_payWay isEqualToString:@"音频"]) {
          self.isBluetooth = @"1";
        if([[PosManager getInstance] getPluggedType])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程队列,进行UI的刷新
                swiperingView.hidden = NO;
            });
            dispatch_queue_t queue = dispatch_queue_create("firstQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^(void) {
                [[PosManager getInstance]cswipecardTransLogNo:transLogNo orderId:@"0000000000000000" delegate:self];
            });
            
        }else{
            [Common showMsgBox:@"" msg:@"未检测到刷卡头,请插入重试" parentCtrl:self];
        }
    }
    else if ([_payWay isEqualToString:@"itron蓝牙"]){
        if([[PosManager getInstance].pos hasHeadset]){  //如果插入刷卡头 也会启动蓝牙 为避免
            [Common showMsgBox:@"您选择了蓝牙刷卡方式" msg:@"检测到您插入了音频,请拔出音频重试" parentCtrl:self];
        }else{
            if ([[UUIDNAME substringToIndex:2] isEqualToString:@"YL"]) {
                self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:[NSString stringWithFormat:@"%@ 搜索中..",UUIDNAME]];
               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHUD:) name:@"closeHUD" object:nil];
                [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
                self.isBluetooth = @"0";
            }else
            {
                PSTAlertController *p = [PSTAlertController alertWithTitle:@"请更改已绑定蓝牙" message:@"您当前已绑定蓝牙非艾创设备"];
                [p addAction:[PSTAlertAction actionWithTitle:@"确认" handler:^(PSTAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [p showWithSender:nil controller:self animated:YES completion:NULL];
                
            }
        }
    }
    else if ([_payWay isEqualToString:@"动联蓝牙"]){
        if([[PosManager getInstance].pos hasHeadset]){  //如果插入刷卡头 也会启动蓝牙 为避免
            [Common showMsgBox:@"您选择了蓝牙刷卡方式" msg:@"检测到您插入了音频,请拔出音频重试" parentCtrl:self];
        }else{
             if ([[UUIDNAME substringToIndex:2] isEqualToString:@"CQ"]) {
                 _dcBlueToothManager = [DCBlueToothManager getDCBlueToothManager];
                 _dcBlueToothManager.viewController = self;
                 _dcBlueToothManager.delegate = self;
                 _dcBlueToothManager.orderId = @"0000000000000000";
                 _dcBlueToothManager.transLogo = transLogNo;
                 _dcBlueToothManager.cash = 0;
                 _dcBlueToothManager.actionType = 2; //查询
                 [_dcBlueToothManager searchDCBlueTooth];
             }else{
                 PSTAlertController *p = [PSTAlertController alertWithTitle:@"请更改已绑定蓝牙" message:@"您当前已绑定蓝牙非动联设备"];
                 [p addAction:[PSTAlertAction actionWithTitle:@"确认" handler:^(PSTAlertAction * _Nonnull action) {
                     [self.navigationController popViewControllerAnimated:YES];
                 }]];
                 [p showWithSender:nil controller:self animated:YES completion:NULL];
             }
        }
    }
    
}


- (void)posResponseDataWithCardInfoModel:(CardInfoModel *)cardInfo{
    
    if ([self.navigationController.viewControllers containsObject:self]) {
        if ([[PosManager getInstance].pos hasHeadset]) {
            cardInfoModel = cardInfo;
            dispatch_queue_t queue = dispatch_queue_create("firstQueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(dispatch_get_main_queue(), ^{
                //任务执行完成后,回到主线程队列,进行UI的刷新
                swiperingView.hidden = YES;
                _blanceMoneyVIew.hidden = NO;
                
            });
            
            if (cardInfo.hasPassword) {
                if (iOS8) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"EnterBankCardPassword") message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = L(@"Password");
                        textField.secureTextEntry = YES;
                        
                    }];
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        hud = [MBProgressHUD showMessag:L(@"IsQuery") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                        [hud hide:YES afterDelay:35];
                        Request *req = [[Request alloc]initWithDelegate:self];
                        [req checkMyCardBalance:cardInfo.cardInfo cardPassWord:[(UITextField*)[alert.textFields objectAtIndex:0] text] iccardInfo:cardInfo.data55 ICCardSerial:cardInfo.sequensNo ICCardValidDate:cardInfo.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:L(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }];
                    [alert addAction:defaultAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"EnterBankCardPassword") message:nil delegate:self cancelButtonTitle:L(@"cancel") otherButtonTitles:L(@"Confirm"), nil];
                    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                    alert.delegate = self;
                    [alert show];
                    
                }
                
            }else{
                if (cardInfo) {hud = [MBProgressHUD showMessag:L(@"IsQuery") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                    [hud hide:YES afterDelay:35];
                    Request *req = [[Request alloc]initWithDelegate:self];
                    [req checkMyCardBalance:cardInfo.cardInfo cardPassWord:@"000000" iccardInfo:cardInfo.data55 ICCardSerial:cardInfo.sequensNo ICCardValidDate:cardInfo.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
                } else {
                    self.cardNum.text = @"0.00";
                }
            }
        }
        
        
        
        //蓝牙查询余额返回数据
        if (cardInfo) {
            NSLog(@"卡信息 ----> %@",cardInfo.cardInfo);
            cardInfoModel = cardInfo;
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程队列,进行UI的刷新
                swiperingView.hidden = YES;
                _blanceMoneyVIew.hidden = NO;
                if (cardInfo.hasPassword) {
                    
                    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:L(@"EnterBankCardPassword") message:nil];
                    [gotoPageController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"密码";
                        textField.secureTextEntry = YES;
                        textField.keyboardType = UIKeyboardTypeNumberPad;
                    }];
                    [gotoPageController addAction:[PSTAlertAction actionWithTitle:L(@"Confirm") handler:^(PSTAlertAction *action) {
                        password = action.alertController.textField.text;
                        if (password.length == 0) {
                            password = @"FFFFFF";
                        }
                        if (password.length>6) {
                            [Common showMsgBox:@"" msg:@"请输入正确密码" parentCtrl:self];
                            password = @"";
                            return ;
                        }
                        
                        hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                        Request *req = [[Request alloc]initWithDelegate:self];
                        
                        [req checkMyCardBalance:cardInfo.cardInfo cardPassWord:action.alertController.textField.text iccardInfo:cardInfo.data55 ICCardSerial:cardInfo.sequensNo ICCardValidDate:cardInfo.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
                    
                    }]];
                    [gotoPageController addAction:[PSTAlertAction actionWithTitle:L(@"cancel") style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
                        
                    }]];
                    [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];

                }else{
                    if (cardInfo) {
                        if (cardInfo) {hud = [MBProgressHUD showMessag:L(@"IsQuery") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
                            [hud hide:YES afterDelay:35];
                            Request *req = [[Request alloc]initWithDelegate:self];
                            [req checkMyCardBalance:cardInfo.cardInfo cardPassWord:@"000000" iccardInfo:cardInfo.data55 ICCardSerial:cardInfo.sequensNo ICCardValidDate:cardInfo.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
                        } else {
                            self.cardNum.text = @"0.00";
                        }
                    }
                }
            });
        }
    }
}


#pragma mark - DCBlueToothManagerDelegate 动联蓝牙代理
-(void)dcBlueToothManagerResponseByCardInfo:(CardInfoModel *)cardInfo{

    cardInfoModel = cardInfo;
    Request *req = [[Request alloc]initWithDelegate:self];
    if (cardInfo) {
        NSLog(@"卡信息 ----> %@",cardInfo.cardInfo);
        cardInfoModel = cardInfo;
        
        
        PSTAlertController *psta = [PSTAlertController alertWithTitle:L(@"EnterBankCardPassword") message:nil];
        [psta addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        [psta addAction:[PSTAlertAction actionWithTitle:L(@"Confirm") handler:^(PSTAlertAction * _Nonnull action) {
            
            password = action.alertController.textField.text;
            if (password.length == 0) {
                password = @"FFFFFF";
            }
            if (password.length>6) {
                [Common showMsgBox:@"" msg:@"请输入正确密码" parentCtrl:self];
                password = @"";
                return ;
            }
            
            hud = [MBProgressHUD showMessag:L(@"IsTrading") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
            Request *req = [[Request alloc]initWithDelegate:self];
            
            [req checkMyCardBalance:cardInfo.cardInfo cardPassWord:action.alertController.textField.text iccardInfo:cardInfo.data55 ICCardSerial:cardInfo.sequensNo ICCardValidDate:cardInfo.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
            
            
            
        }]];
        
        [psta addAction:[PSTAlertAction actionWithTitle:L(@"cancel")  handler:^(PSTAlertAction * _Nonnull action) {
            [hud hide:YES];
            [_dcBlueToothManager cancleSwipeCard]; //取消刷卡(断开连接)
        }]];
        
        [psta showWithSender:nil controller:self animated:YES completion:NULL];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        hud = [MBProgressHUD showMessag:L(@"IsQuery") toView:[[QuickPosTabBarController getQuickPosTabBarController] view]];
        [hud hide:YES afterDelay:35];
        Request *req = [[Request alloc]initWithDelegate:self];
        [req checkMyCardBalance:cardInfoModel.cardInfo cardPassWord:[[alertView textFieldAtIndex:0] text] iccardInfo:cardInfoModel.data55 ICCardSerial:cardInfoModel.sequensNo ICCardValidDate:cardInfoModel.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
    }
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [hud hide:YES];
    
    if (type == REQUEST_GETBULETOOHTHNUMBER) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *tsf = [[dict objectForKey:@"data"] objectForKey:@"tsf"];
        if (tsf.count == 0) {
            [Common showMsgBox:nil msg:@"您还未绑定蓝牙,请至'我的账户'绑定" parentCtrl:self];
        }else if([[NSUserDefaults standardUserDefaults] objectForKey:@"SerialNumber"] == nil){
            
            PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"" message:@"您还未选择蓝牙,请前往'我的刷卡器选择'"];
            
            [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"确认" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
            }]];
            [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];
        }else{
            //
        }
    }
    
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        if (type == REQUSET_CARDBALANCE) {
            self.cardNum.text = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"balance"] doubleValue]/100];
            
            NSString *str = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"balance"] doubleValue]/100];
            
            _balanceMoneyLab.text = [NSString stringWithFormat:@"￥%@",str];
        }
        
    }else{
    
        [Common showMsgBox:nil msg:[dict objectForKey:@"respDesc"] parentCtrl:self];
    }

}
- (IBAction)goubackVIewController:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
    _balanceMoneyLab.text = @"";
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
