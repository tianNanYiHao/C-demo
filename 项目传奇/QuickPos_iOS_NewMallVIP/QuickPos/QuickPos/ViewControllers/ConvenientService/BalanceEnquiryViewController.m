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
#import "MyCreditCardMachineViewController.h"



@interface BalanceEnquiryViewController ()<ResponseData,PosResponse,UIAlertViewDelegate>{
    CardInfoModel *cardInfoModel;
    MBProgressHUD *hud;
    NSString *password;
}


@property (weak, nonatomic) IBOutlet UIView *swiperingView;
@property (weak, nonatomic) IBOutlet UILabel *cardNum;

@property (weak, nonatomic) IBOutlet UIButton *comfirt;


@property (weak, nonatomic) IBOutlet UIView *blanceMoneyVIew;//view
@property (weak, nonatomic) IBOutlet UILabel *myBlanceLab;  //我的账户余额 文字
@property (weak, nonatomic) IBOutlet UILabel *balanceMoneyLab;  //moneyLab 余额
@property (weak, nonatomic) IBOutlet UIButton *sureMoneyBtn;  //确认按钮
@property (nonatomic,strong) MBProgressHUD *hub;
@property (nonatomic,strong) NSString *isBluetooth;



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
    
     self.isBluetooth = @"1";
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];
    
   
    
}

- (void)noticePost:(NSNotification *)noti{
    [self.hub hide:YES afterDelay:2];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *transLogNo = [NSString stringWithFormat:@"%06d",[[user objectForKey:@"transLogNo"] integerValue]];
    [[PosManager getInstance] cswipecardTransLogNo:transLogNo orderId:@"0000000000000000" delegate:self];
    swiperingView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeBluetooth" object:nil];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeLDBluetooth" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    swiperingView.hidden = YES;
    _blanceMoneyVIew.hidden = YES;
    self.cardNum.text = L(@"CardBalance");
}

- (void)viewDidAppear:(BOOL)animated
{
    [[PosManager getInstance].pos stop];
}

//查询余额
- (IBAction)checkBalanceEnquiry:(UIButton *)sender {
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *transLogNo = [NSString stringWithFormat:@"%06d",[[user objectForKey:@"transLogNo"] integerValue]];
//    
//    if([[PosManager getInstance] getPluggedType])
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回到主线程队列,进行UI的刷新
//            swiperingView.hidden = NO;
//        });
//        dispatch_queue_t queue = dispatch_queue_create("firstQueue", DISPATCH_QUEUE_CONCURRENT);
//        dispatch_async(queue, ^(void) {
//            [[PosManager getInstance]cswipecardTransLogNo:transLogNo orderId:@"0000000000000000" delegate:self];
//        });
//        
//    }else
//    {
//        //[MBProgressHUD showHUDAddedTo:self.view WithString:L(@"IdentificationOfFailure")];
//        
//        //蓝牙搜索
//        
//        self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"设备搜索中..."];
//        [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
//        self.isBluetooth = @"0";
//        
//    }
//
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];
    
    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:nil message:@"请选择刷卡器类型?"];
    
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"音频" handler:^(PSTAlertAction *action) {
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
                [[PosManager getInstance]cswipecardTransLogNo:transLogNo orderId:@"0000000000000000" delegate:self];
            });
        }else{
            [Common showMsgBox:@"" msg:@"未检测到刷卡头,请插入重试" parentCtrl:self];
        }
        
    }]];
    
    
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"蓝牙" style:PSTAlertActionStyleCancel handler:^(PSTAlertAction *action) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"] length]>0) {
            self.isBluetooth = @"0";
            NSString *s=
            [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:[NSString stringWithFormat:@"%@ 搜索中..",s]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHUD:) name:@"closeHUD" object:nil];
            [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
            
        }else{
            
            
            PSTAlertController *pstac = [PSTAlertController alertWithTitle:@"" message:@"您还未绑定蓝牙,请至'我的账户绑定'"];
            [pstac addAction:[PSTAlertAction actionWithTitle:@"确定" handler:^(PSTAlertAction * _Nonnull action) {
                MyCreditCardMachineViewController *myCreditCardMachineVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyCreditCardMachineVC"];
                myCreditCardMachineVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myCreditCardMachineVC animated:YES];//我的刷卡器
                
            }]];
            [pstac addAction:[PSTAlertAction actionWithTitle:@"取消" handler:^(PSTAlertAction * _Nonnull action) {
                
            }]];
            
            [pstac showWithSender:nil controller:self animated:YES completion:NULL];
            
        }
        
        
        //            //为蓝牙卡头添加登记
        //            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"欢迎使用"
        //                                                        message:@"请绑定您的蓝牙刷卡器" delegate:self cancelButtonTitle:@"已绑定过" otherButtonTitles:@"绑定", nil];
        //            alert.tag = 100789;
        //            alert.delegate = self;
        //            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        //
        //            UITextField *t = [alert textFieldAtIndex:0];
        //            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"] length]>0) {
        //                t.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
        //            }else{
        //                t.placeholder = @"请输入蓝牙刷卡头编号(YL开头)";
        //            }
        //            [alert show];
        //
        //            self.isBluetooth = @"0";
        //            self.hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"蓝牙设备搜索中..."];
        //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeHUD:) name:@"closeHUD" object:nil];
        //
        //            [[PosManager getInstance] initDeviceWithType:DEVICE_TYPE_BOARD_BLUETOOTH];
        
    }]];
    [gotoPageController showWithSender:nil controller:self animated:YES completion:NULL];
    
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
        else{
            if (cardInfo) {
                NSLog(@"卡信息 ----> %@",cardInfo.cardInfo);
                cardInfoModel = cardInfo;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回到主线程队列,进行UI的刷新
                    swiperingView.hidden = YES;
                    _blanceMoneyVIew.hidden = NO;
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
                                
                                [req checkMyCardBalance:cardInfo.cardInfo cardPassWord:[(UITextField*)[alert.textFields objectAtIndex:0] text] iccardInfo:cardInfo.data55 ICCardSerial:cardInfo.sequensNo ICCardValidDate:cardInfo.expiryDate merchantId:@"" productId:@"" orderId:@"0000000000000000" encodeType:@"bankpassword"];
                                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
