//
//  DCBlueToothManager.m
//  P27BlueToothPosManager
//
//  Created by Aotu on 16/5/26.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "DCBlueToothManager.h"
#import <DCSwiperAPI/DCSwiperAPI.h>
#import "PSTAlertController.h"
#import "MBProgressHUD.h"
#define DEVICEBACKINFO @"deviceBackInfo"
#define UUIDNAME   [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"]


/*
切换蓝牙的问题:
如果有 超时,有刷卡错误等操作,那么 切换蓝牙就会导致瞬联 旧的蓝牙名
如果在旧蓝牙断开的情况下, 可以连上新蓝牙
*/


@interface DCBlueToothManager ()<DCSwiperAPIDelegate,MBProgressHUDDelegate>
{
    NSMutableDictionary       *_BTNameDict; //蓝牙名字字典
    NSMutableArray            *_BTNameArray;//蓝牙名称数据源
    NSString                  *_identifier; //选中的蓝牙Mac
    MBProgressHUD             *_hud;
    NSString                  *_deviceBackInfo; //设备反馈信息
    CBPeripheral              *_peripheralSure;
    int                       _FirstSearchType;           //判断是否第一次获取蓝牙失败
    NSString                  *_deviceBreak;     //检测到设备断开
    BOOL                       _swipeAgain;      //是否再次刷卡
    NSString                  *_bdmSave;         //绑定码保存的
    NSString                  *_isMatched;       //是否匹配到的
    
}
@property (nonatomic,strong) DCSwiperAPI *dcSwiper;
@property (nonatomic,strong) PSTAlertController *pstaControler;

@end

@implementation DCBlueToothManager
static DCBlueToothManager *_dcBlueToothManager = nil;

+(instancetype)getDCBlueToothManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dcBlueToothManager = [[self alloc] init];
    });
    
    return _dcBlueToothManager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _dcSwiper = [DCSwiperAPI sharedDCEMV];
        _dcSwiper.delegate = self;
        _BTNameDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        _BTNameArray = [[NSMutableArray alloc] initWithCapacity:0];
        _deviceBackInfo = DEVICEBACKINFO;
        _swipeAgain = NO;

    }
    return self;
}


-(void)showHUDWithString:(NSString*)message{
    _hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:_hud];
    _hud.delegate = self;
    _hud.labelText = message;
    [_hud show:YES];
}
-(void)endHUD{
    [_hud hide:YES];
}
-(void)endHUDWithAfterDelay:(NSTimeInterval)delay{
    [_hud hide:YES afterDelay:delay];
}


//搜索蓝牙对外接口
-(void)searchDCBlueTooth{
    NSLog(@"=========搜索or连接蓝牙==========");
    
    if (_swipeAgain) {
        //先检测一下蓝牙状态
        //是重新刷卡
        [_dcSwiper cancelPinInput];//取消刷卡 (复位)
        
    }else{
        if (_BTNameArray.count>0) {
            [_BTNameArray removeAllObjects];
        }
        if (_dcBlueToothManager) {
            [_dcSwiper scanBlueDevice]; // 搜索蓝牙
            [self showHUDWithString:[NSString stringWithFormat:@"%@蓝牙搜索中",[[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"]]];
            _FirstSearchType = FirstSearch;
            _swipeAgain = YES;
        }
    }

}

////断开连接对外接口
//-(void)disConnectDCBlueTooth{
//    if (_peripheralSure) {
//        [_dcSwiper disConnect];   //  如果已连接过 ,则退断开连接
//
//    }
//    //如果没搜索到 已做停止搜索处理
//}

//点击取消刷卡对外接口
-(void)cancleSwipeCard{
//    _deviceBackInfo = @"cancaleSwipeCard";
    //取消刷卡(则断开连接)

    [self popViewGoBackWithMessage:@"您取消了刷卡"];
}
//返回上级页面对内调用
-(void)popViewGoBackWithMessage:(NSString*)message{
    [self endHUD];
    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:message message:@"即将退回下订单页面"];
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"是" handler:^(PSTAlertAction *action) {
        //一旦得到异常反馈 均断开了连接,
        
        if ([message isEqualToString:@"您取消了刷卡"]) {  //主动取消刷卡 断开连接
            _deviceBreak = @"deviceIsBraekSelf";
            [_dcSwiper disConnect];
        }
        
        //退回下订单页面
        [_viewController.navigationController popViewControllerAnimated:YES];
    }]];
    
    [gotoPageController showWithSender:nil controller:_viewController animated:YES completion:NULL];
    
}




//搜索超时对内调用
-(void)stopSearchDCBlueToothWithTimeOut:(NSString*)match{
    
    if ([_isMatched isEqualToString:@"YES"]) {
        
        NSLog(@"跳过跳过跳过跳过跳过跳过跳过跳过跳过跳过跳过跳过");
        
    }
    else if([_isMatched isEqualToString:@"NO"]){
        if ([_dcSwiper isBTConnected]) {  //如果蓝牙已经连接 则不要提示
            
        }else{
            if (_FirstSearchType == FirstSearch) {   //为防止多次调用 这里只让第一次调用
                _swipeAgain = NO;      //断开后重置
                [self endHUD];
                [self showHUDWithString:@"未搜索到绑定的蓝牙,即将退回"];
                [self endHUDWithAfterDelay:1.5];
                [self performSelector:@selector(stopSearchDCBlueToothWithTimeOutToPopviewController) withObject:nil afterDelay:1.5];
                _FirstSearchType = NotFirstSearch;
            }

        }
       
    }
}
-(void)stopSearchDCBlueToothWithTimeOutToPopviewController{
    [_dcSwiper stopScanBlueDevice]; //停止搜索
    [_viewController.navigationController popViewControllerAnimated:YES];

}

#pragma mark - dcwiperapi delegate  == SDK的代理方法集合
//当扫描设备是反馈结果
//(多次调用 获取设备 name )(每当搜索到新的蓝牙才会调用,以前的蓝牙搜索到了,关闭再打开是不会再调用此方法的!)
- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral{
    
    
    NSString *bdm = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
    
    [[NSUserDefaults standardUserDefaults] boolForKey:@"uuidName"];
    
    NSLog(@"***** bdm ******* %@",bdm);
    NSLog(@"name name name name name  ===  %@",peripheral.name);
    
    if ([peripheral.name isEqualToString:bdm]) {
        [_BTNameDict setObject:peripheral forKey:peripheral.name];
        _peripheralSure = [_BTNameDict objectForKey:peripheral.name];
        //开始连接
        [_dcSwiper connectBluetoothDevice:_peripheralSure];
        //检测到 则停止搜索
        _isMatched = @"YES"; //匹配到
    }
    else
    {
        _isMatched = @"NO";
    }
    
    
    if ([_isMatched isEqualToString:@"YES"]) {
        
    }else{
        //这个方法是单线程的 只有在onFindBluetoothDevice:方法调完以后 才会执行@selector(方法)
        [self performSelector:@selector(stopSearchDCBlueToothWithTimeOut:) withObject:nil afterDelay:5];
    }

}



//当设备连接成功时反馈
- (void)onDidConnectBluetoothDevice:(CBPeripheral *)peripheral
{
    
    [_dcSwiper stopScanBlueDevice];  //停止搜索
    NSLog(@"+++++++++++++设备连接成功%@",peripheral);
//    [self showAlertView:@"设备连接成功" messgae:peripheral.name];

    NSLog(@"-=-=-=-=-=orderId...%@-=-=-=-=-=-transLogo...%@=-=-=-=-=-=-=cash...%d=-=-=-=-=-=-",_orderId,_transLogo,_cash);
    [_dcSwiper cancelPinInput];//取消刷卡 (先复位 再刷卡)
  
    
}
//当点击断开连接时反馈(且一旦检测到失去连接,就反馈)
- (void)onDisconnectBluetoothDevice:(CBPeripheral *)peripheral
{
    NSLog(@"+++++++++++++设备断开");
//    [self showAlertView:@"设备已经断开" messgae:peripheral.name];

     _swipeAgain = NO;  //主动或被动检测断蓝牙设备断开后 必须重新搜索
     [self endHUD];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"startswipe" object:nil userInfo:[NSDictionary dictionaryWithObject:@"no" forKey:@"showSwipe"]];

    if ([_deviceBreak isEqualToString:@"deviceIsBraekSelf"]) { //如果选择了取消刷卡
        _deviceBreak = @"";
    }
    else{//判断设备是否已经断开(或刷卡到一半过程中主动断开)
        
        PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"您的设备已断开" message:@"即将退回下订单页面"];
        [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"是" handler:^(PSTAlertAction *action) {
            //一旦得到异常反馈 均断开了连接,
            _deviceBackInfo = DEVICEBACKINFO; //重新初始
            //退回下订单页面 (主动断开连接 则使用通知来popview)
            [_viewController.navigationController popViewControllerAnimated:YES];
        }]];
        [gotoPageController showWithSender:nil controller:_viewController animated:YES completion:NULL];
    }

}



//当设备获取信息时反馈
//参数deviceInfoDict 包含 psamNo & terminalld
- (void)DCEMVReturnDeviceInfo:(NSDictionary *)deviceInfoDict{
    NSLog(@"+++++++++++++设备信息%@",deviceInfoDict);
//    self.showLab.text = [NSString stringWithFormat:@"%@",deviceInfoDict];
}


//以下4个代理方法(刷卡一次性调用,想要调用请下次在点击刷卡按钮)
//当设备即将刷卡时,等待刷卡的反馈
- (void)onWaitingForCard
{
    
    NSLog(@"+++++++++++++刷卡前提示:请刷卡");
//    [self showAlertView:@"刷卡提示" messgae:@"请刷卡！"];
    //此处修改ui界面的变化  提示请刷卡
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startswipe" object:nil userInfo:[NSDictionary dictionaryWithObject:@"yes" forKey:@"showSwipe"]];
    [self showHUDWithString:@"请刷卡"];
}
//当刷卡进行时获取卡信息的反馈
-(void)onDetectCard
{
    [self endHUD];
    NSLog(@"+++++++++++++正在刷卡,获取卡信息数据");
    [self showHUDWithString:@"正在刷卡中,请稍后"];
    
}
//当刷IC卡的时候反馈
-(void)onDCEMVICData:(NSDictionary *)icInfo{
    NSLog(@"+++++++++++++刷IC卡返回信息%@",icInfo);
    [self endHUD];
    
    if ([_delegate respondsToSelector:@selector(dcBlueToothManagerResponseByCardInfo:withType:)]) {
        [_delegate dcBlueToothManagerResponseByCardInfo:icInfo withType:ICCard];
    }
    
//    self.showLab.font = [UIFont systemFontOfSize:5];
//    self.showLab.text = [NSString stringWithFormat:@"%@",icInfo];
    
}
//当刷磁条卡Track时反馈
-(void)onDCEMVTrackData:(NSDictionary *)trackInfo{
    NSLog(@"+++++++++++++刷磁条Track卡返回信息%@",trackInfo);
    [self endHUD];
    
    if ([_delegate respondsToSelector:@selector(dcBlueToothManagerResponseByCardInfo:withType:)]) {
        [_delegate dcBlueToothManagerResponseByCardInfo:trackInfo withType:TrackCard];
    }
//    self.showLab.font = [UIFont systemFontOfSize:5];
//    self.showLab.text = [NSString stringWithFormat:@"%@",trackInfo];
}

//当刷卡后获取卡号的反馈
-(void)onDCCardNumber:(NSString *)cardNumber{
    [self endHUD];
    [self showAlertView:cardNumber messgae:@"确认卡号"];
}


//当取消刷卡时反馈
-(void)onDCEMVPOSCancel{
    [self endHUD]; //隐藏 '蓝牙搜索中'HUD
    //@"取消/复位"
//    [self showHUDWithString:@"复位成功"];
    
    //刷卡前,都要让蓝牙复位!
    [_dcSwiper startPOS:_orderId transLogo:_transLogo cash:_cash transactType:DCEMVTransactionType_Payment];  //刷卡
    
}




//当获取电量时反馈
-(void)DCEMVBatteryLow:(DCEMVBatteryStatus)batteryStatus{
    [self showAlertView:@"电量" messgae:[NSString stringWithFormat:@"%d",batteryStatus]];
}





//当各种异常情况出现时反馈
- (void)onDCEMVError:(DCEMVErrorType)DCEMVErrorType errorMessage:(NSString *)errorMessage
{
//    [self endHUD];
    switch (DCEMVErrorType) {
        case DCEMVErrorType_ERROR_NotIccCard:
//            _deviceBackInfo = @"icCardPleaseIn";
            //请插入ic卡
            [self popViewGoBackWithMessage:@"请插入ic卡"];
            
            break;
        case DCEMVErrorType_ERROR_BadSwipe:
//            _deviceBackInfo = @"magneticCardFailed";
             //读磁条卡失败 断开连接
            [self popViewGoBackWithMessage:@"读磁条卡失败"];
            
            break;
        case DCEMVErrorType_ERROR_TIMEOUT:
//            _deviceBackInfo = @"TimeOut";
             //超时 断开连接
            [self popViewGoBackWithMessage:@"蓝牙连接超时"];
            
            break;
            
        case DCEMVErrorType_ERROR_DATA:
//            _deviceBackInfo = @"dataError";
            //数据域错误
            [self popViewGoBackWithMessage:@"数据域错误"];
            
            
            break;
            
        case DCEMVErrorType_ERROR_ICCARD:
//            _deviceBackInfo = @"icCardUseError";
              //IC卡操作错误
            [self popViewGoBackWithMessage:@"IC卡操作错误"];
            
            break;
            
        default:
            break;
    }
    
}



- (void)showAlertView:(NSString *)title messgae:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
@end
