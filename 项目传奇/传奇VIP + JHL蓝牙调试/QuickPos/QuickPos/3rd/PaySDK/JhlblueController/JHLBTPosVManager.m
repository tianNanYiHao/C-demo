//
//  JHLBTPosVManager.m
//  BluetoothTest
//
//  Created by Aotu on 16/6/7.
//  Copyright © 2016年 szjhl. All rights reserved.
//

#import "JHLBTPosVManager.h"

#import "JhlblueController.h"
#import "PSTAlertController.h"
#import "MBProgressHUD.h"


#define WAIT_TIMEOUT 30000 //等待刷卡时间 默认超时时间30秒

@interface JHLBTPosVManager ()<JhlblueControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD             *_hud;
    NSMutableArray *deviceList;   //查询到的设备名称列表
    NSMutableArray *connectedList;  //连接成功的列表
    
    NSMutableArray      *_nameArray; //存储搜索到的蓝牙名
    NSInteger            _index;     //下标
    NSInteger            _timeOutType; //超时类型
    int                  _typeKind;    //刷卡模式
    NSString            *_amount;      //金额 123 = 1.23
    
    
}
@end

@implementation JHLBTPosVManager
/**
 *  检查设备打开线程 获取设备信息
 
 */

-(void)showHUDWihtMessage:(NSString*)message{
    _hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:_hud];
    _hud.labelText = message;
    _hud.delegate = self;
    [_hud show:YES];
    
}
-(void)hidHUD{
    [_hud hide:YES];
}
-(void)hidHUDWithDelay:(int)delay{
    [_hud hide:YES afterDelay:delay];
}
-(void)popGoBackDelayWithTime:(int)delay{
    [self performSelector:@selector(goBackTOPop) withObject:nil afterDelay:delay];
}
-(void)requestBySwipCardStateWithMessage:(NSString*)message{
    [[JhlblueController sharedInstance] disconnectBT];
    [self showHUDWihtMessage:message];
    [self hidHUDWithDelay:2];
    [self popGoBackDelayWithTime:2];
}






-(instancetype)initwithType:(int)type withAmount:(NSString *)amount{
   
        _typeKind = type;
        _amount = amount;
        _index = -1;
    
        deviceList = [[NSMutableArray alloc] init];
        connectedList = [[NSMutableArray alloc] init];
        _nameArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        //设置回调与初始化蓝牙
        [[JhlblueController sharedInstance]  setDelegate:self];
        [[JhlblueController sharedInstance]  InitBlue];
        [[JhlblueController sharedInstance]  SetEncryMode:0x01 :0x01 :0x01];  //设置加密方式
        
        NSLog(@"是否连接状态== %d == ",[[JhlblueController sharedInstance] isBTConnected]);
        
        
        //1.查找设备
        if ([[JhlblueController sharedInstance] isBTConnected])  //判断是否连接状态
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[JhlblueController sharedInstance] isBTConnected]){
                    //1.1 先判断是否需要 断开连接 = YES
                    [self showHUDWihtMessage:@"正在断开,请稍后..."];
                    [[JhlblueController sharedInstance] disconnectBT];
                }else{
                    NSLog(@"未连接设备,无需断开...");
                }
                
            });
        }else //2.否则,连接蓝牙
        {
            [self showHUDWihtMessage:@"正在搜索蓝牙设备..."];
            [[JhlblueController sharedInstance] scanBTDevice:3 nScanType:0x00];  //0 是列表返回  1:收到一个即时返回一个
            _timeOutType = timeOutType1;
          
            
        }

    
    
    
    
    return self;
}

#pragma mark ===============蓝牙部分的回调===============


//0x01 发现新的蓝牙  //搜索模式为一个个返回时回调(多次)
- (void)onFindNewPeripheral:(CBPeripheral *)newPeripheral
{
    NSLog(@"%s,findNewBt:%@",__func__,newPeripheral.name);
}
//0x01 搜索到的蓝牙设备  //搜索模式为列表返回时回调
- (void)onDeviceFound:(NSArray *)DeviceList
{
    
    NSLog(@"DeviceList === %@",DeviceList);
    
    if (DeviceList.count > 0) {  //如果存在数组
        NSString *bdm = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
        NSLog(@"====bdm==== %@",bdm);
        CBPeripheral *dataPath= nil;
        
        
        if (_nameArray.count >0) {
            [_nameArray removeAllObjects];
        }
        NSString *name = [NSString new];
        for (int i = 0; i<DeviceList.count; i++) {
            dataPath = DeviceList[i];
            name = dataPath.name;
            [_nameArray addObject:name];
        }
        
        if (_nameArray.count > 0) {
            NSString *nameRight = [NSString new];
            for (int j = 0; j < _nameArray.count; j++) {
                nameRight = _nameArray[j];
                if ([nameRight isEqualToString:bdm]) {
                    _index = j;
                    if (!j) {
                        _index = 0;
                    }
                }
            }
        }

        if ((_index && _index > 0) || _index == 0) {
            [[JhlblueController sharedInstance] connectBT:DeviceList[_index] connectTimeout:10];  //10秒超时 //连接蓝牙
            _index = -1;
        }
        else {
            [self hidHUD];
            [self showHUDWihtMessage:@"未搜索到蓝牙,请重新搜索"];
            [self hidHUDWithDelay:2];
            [self popGoBackDelayWithTime:2];
        }

    }else{    //如果不存在
        [self hidHUD];
        [self showHUDWihtMessage:@"未搜索到任何蓝牙,请重新搜索"];
        [self hidHUDWithDelay:2];
        [self popGoBackDelayWithTime:2];
    }
    
    
    
    
}
//检测到蓝牙已连接时回调
- (void)onConnected:(CBPeripheral *)connectedPeripheral
{
    NSLog(@"%s,result:%@",__func__,connectedPeripheral.name);
    NSLog(@"====  蓝牙设备连接成功 ====");
    //显示刷卡页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startswipeByJHL" object:nil];
    //选择刷卡模式 刷卡
    [[JhlblueController sharedInstance]  MagnCard:WAIT_TIMEOUT:[_amount intValue]:_typeKind];
}



/*
 判断是否处于连接状态  -1 连接后断开i  00 未找到设备  01 连接成功 02 正在连接  03 连接失败
 */
//连接状态反馈
-(void)onBlueState:(int)nState
{
  
    NSLog(@"nState ==== %d",nState);
    
    
    if (nState ==BLUE_SCAN_NODEVICE)
    {
        NSLog(@"设备连接已断开,当前无设备");
        
    }
    else if (nState ==BLUE_CONNECT_FAIL){
        [self showHUDWihtMessage:@"连接设备失败"];
        [self hidHUDWithDelay:2];
    }
    else if (nState ==BLUE_CONNECT_SUCESS)
    {
        //搜索 直到连接成功才hid
        [self hidHUD];
        [self showHUDWihtMessage:@"设备连接成功"];
        
    }
    else if (nState ==BLUE_CONNECT_ING){
        [self showHUDWihtMessage:@"蓝牙正在连接..."];
        [self hidHUDWithDelay:2];
    }
    else if (nState ==BLUE_POWER_STATE_ON){   //当手机蓝牙开启时检测回调
        NSLog(@"检测到手机蓝牙处于开启状态");
    }
    else if (nState ==BLUE_POWER_STATE_OFF){  //当手机蓝牙关闭时检测回调
        _timeOutType = timeOutType2; //
        
        if ([[JhlblueController sharedInstance] isBTConnected]){
            [[JhlblueController sharedInstance] disconnectBT];  //断开连接
        }
        
        PSTAlertController *psta = [PSTAlertController alertWithTitle:@"" message:@"检测到您已关闭蓝牙"];
        [psta addAction:[PSTAlertAction actionWithTitle:@"去开启" handler:^(PSTAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }]];
        [psta addAction:[PSTAlertAction actionWithTitle:@"取消" handler:^(PSTAlertAction * _Nonnull action) {
        }]];
        [psta showWithSender:nil controller:_viewController animated:YES completion:NULL];
        NSLog(@"检测到手机蓝牙处于关闭状态");
    }
    
}
//搜索蓝牙超时
-(void)onScanTimeout{  //超时分两个情况判断 1.正常搜索超时 2.手机蓝牙功能未开启的搜索超时
    
    if (_timeOutType == timeOutType1) {
        [self hidHUD]; //用来隐藏搜索蓝牙的HUD
        [self showHUDWihtMessage:@"蓝牙搜索超时,请重新搜索"];
        [self hidHUDWithDelay:2];
    }
    else if (_timeOutType == timeOutType2){
        [self hidHUD]; //用来隐藏搜索蓝牙的HUD
        [self showHUDWihtMessage:@"搜索超时,请确认蓝牙是否开启"];
        [self hidHUDWithDelay:2];
    }
    [self popGoBackDelayWithTime:2];
    
}
-(void)goBackTOPop{
    [_viewController.navigationController popViewControllerAnimated:YES];
}





#pragma mark ===============功能交易部分的回调===============



//返回设备信息
- (void)onDeviceInfo:(DeviceInfoData)DeviceInfoList
{
    
    NSString * SN =@"SN:";
    NSLog(@"设备信息 %s DeviceSN:%@,Appversion:%@,BootVersion:%@,Model:%@",__func__,DeviceInfoList.DevcieSn,DeviceInfoList.AppVersion,DeviceInfoList.BootVersion,DeviceInfoList.Model);
    
//    self.LabTip.text = @"GET  SN  Sucess";
    SN = [SN stringByAppendingString:DeviceInfoList.DevcieSn];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:SN delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    self.TextViewTip.text = SN;
    [alert show];
    
}

- (void)onTimeout //超时
{
    
    NSLog(@"%s,onTimeout:%@",__func__,@"onTimeout");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取超时" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
//功能操作结果
- (void)onResult:(int) Code:(int) nResult :(NSString *)MsgData
{
    
    switch (Code) {
        case ICBARUSH_CMD:
        case GETCARD_CMD:	 //刷卡完成,请求输入密码
        {
            [[JhlblueController sharedInstance] InputPassword:@"12346"];
//            self.TextViewTip.text =@"正在加密数据....";
        }
            break;
            
       	case  MAINKEY_CMD:  //主密钥
        {
            if (nResult ==0x00){
//                self.TextViewTip.text =@"主密钥设置成功";
            }else{
//                self.TextViewTip.text =[@"主密钥设置失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            }
        }
            break;
            
        case  WORKKEY_CMD:  //工作密钥
        {
            if (nResult ==0x00){
//                self.TextViewTip.text =@"工作密钥设置成功";
            }else{
//                self.TextViewTip.text =[@"工作密钥设置失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            }
        }
            break;
        case GETMAC_CMD:  //MAC值
        {
            if (nResult==0x00){
//                self.TextViewTip.text =[@"MAC获取成功:"  stringByAppendingString: MsgData];
            }else{
//                self.TextViewTip.text =[@"MAC获取失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            }
        }
            break;
            
        case WRITETERNUMBER_CMD: //设置终端号商户号成功
        {
            if (nResult==0x00){
//                self.LabTip.text =@"终端号商户号设置成功,正在获取商户号终端号";
            }else{
//                self.TextViewTip.text =[@"终端号商户号设置失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            }
            
            [[JhlblueController sharedInstance] ReadTernumber];
        }
            break;
            
        case GETTERNUMBER_CMD:
        {
            if (nResult==0x00){
//                self.TextViewTip.text =[@"终端号商户号获取成功:"  stringByAppendingString: MsgData];
            }else{
//                self.TextViewTip.text =[@"终端号商户号获取失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            }
        }
            break;
        case BATTERY_CMD:
        {
            if (nResult==0x00){
//                self.TextViewTip.text =[@"电池电量获取成功:"  stringByAppendingString: MsgData];
            }else{
//                self.TextViewTip.text =[@"电池电量获取失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            }
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    NSLog(@"%s,Code:%d,nResult:%d,MsgData:%@",__func__,Code,nResult,MsgData);
}
//刷卡提示
- (void)swipCardState:(int ) nResult
{
  
    NSLog(@"%s,nResult:%d",__func__,nResult);
    switch(nResult)
    {
        case SWIPE_SUCESS:
            NSLog(@"刷卡正常");
            break;
        case SWIPE_DOWNGRADE:
            NSLog(@"刷卡降级");
            [self hidHUD];
            [self requestBySwipCardStateWithMessage:@"刷卡降级"];
        
            break;
        case SWIPE_ICCARD_INSETR:
            NSLog(@"在待机界面插入IC卡");   // √   插入ic卡 当不执行刷卡任务时 均调用
            break;
        case SWIPE_ICCARD_SWINSETR:
            NSLog(@"交易功能插入IC");       // √  插入ic卡 当能执行刷卡时且ic卡未插入(已插入时不调用)调用 刷卡成功以后 需要重新搜索蓝牙 插入ic卡 方可再次调用
            break;
        case SWIPE_WAIT_BRUSH:
            NSLog(@"请刷卡,等待刷卡");            //  √
            [self hidHUD];// 连接成功提示Hid
            [self showHUDWihtMessage:@"请刷卡..."];
            break;
        case SWIPE_CANCEL:
            NSLog(@"用户取消");
            break;
        case SWIPE_TIMEOUT_STOP:
            NSLog(@"超时退出");
            break;
        case SWIPE_IC_FAILD:
            NSLog(@"IC卡处理数据失败");
            [self hidHUD];
            [self requestBySwipCardStateWithMessage:@"IC卡处理数据失败"];
            
            break;
        case SWIPE_NOICPARM:
            NSLog(@"无IC卡参数");
            [self hidHUD];
            [self requestBySwipCardStateWithMessage:@"无IC卡参数"];
            break;
        case SWIPE_STOP:
            NSLog(@"交易终止");  //默认30秒超时 不刷卡即交易终止       //  √
            [self hidHUD];
            [self requestBySwipCardStateWithMessage:@"刷卡等待超时,交易终止"];
            break;
        case SWIPE_IC_REMOVE:
            NSLog(@"加密失败,用户拔出IC卡");
            break;
        case SWIPE_LOW_POWER:
            NSLog(@"低电量,不允许交易");
            [self hidHUD];
            [self requestBySwipCardStateWithMessage:@"低电量,不允许交易"];
            break;
        case BLUE_POWER_OFF:
            NSLog(@"已关机");
            [self hidHUD];
            [self requestBySwipCardStateWithMessage:@"已关机"];
            break;
        case BLUE_DATA_WAITE:
            NSLog(@"设备数据处理中");
            break;
        case BLUE_DEVICE_ERROR:
            NSLog(@"设备非法,不匹配当前SDK");
            break;
        default:
            break;
    }
    
}
//读取卡数据 (刷卡成功)
- (void)onReadCardData:(FieldTrackData) FildCardData
{
    // NSLog(@"%s,onReadCardData:%@",__func__,FildCardData.CardSeq);
    [self hidHUD]; //请刷卡Hid
    [[JhlblueController sharedInstance] disconnectBT];  //当刷卡成功 即断开蓝牙连接
    NSString *PAN = [NSString new];
    NSString *szamount = [NSString new];
    PAN =[@"PAN:" stringByAppendingString:FildCardData.TrackPAN];
    szamount=[@"刷卡成功,金额:" stringByAppendingString:[NSString stringWithFormat:@"%.2f元",FildCardData.szAmount]];
    NSLog(@"PANPANPANANPANPAN%@",PAN);
    NSLog(@"%@",szamount);
    
    NSLog(@"PAN:%@",FildCardData.TrackPAN);
    NSLog(@"CardValid(有效期):%@",FildCardData.CardValid);
    NSLog(@"ServiceCode(服务代码):%@",FildCardData.szServiceCode);
    NSLog(@"CardSeq(IC卡片序列号):%@",FildCardData.CardSeq);
    NSLog(@"EntryMode(服务点输入方式):%@", FildCardData.szEntryMode);
    NSLog(@"Track2(二磁道数据):%@",FildCardData.szTrack2Data);
    NSLog(@"szEncryTrack2(二磁道加密数据):%@",FildCardData.szEncryTrack2Data);
    NSLog(@"Track3(三磁道数据):%@",FildCardData.szTrack3Data);
    NSLog(@"szEncryTrack3(三磁道加密数据):%@",FildCardData.szEncryTrack3Data);
    NSLog(@"PINBLOCK(密码密文):%@",FildCardData.sPIN);
    NSLog(@"Field55Ic(IC卡数据):%@",FildCardData.Field55Iccdata);
    NSLog(@"Amount(交易金额):%@",[NSString stringWithFormat:@"%.2f元",FildCardData.szAmount]);
    NSLog(@"AsciiPin(明文密码):%@", FildCardData.szAsciiPin);
    NSLog(@"AsciiSn(SN号):%@",FildCardData.szAsciiSn);
    NSLog(@"Radom(随机数):%@",FildCardData.szRadom);
    
    
    //Demo专门提示降级 所以要做处理
    if (FildCardData.bDowngrade ==TRUE){
        NSLog(@"是否降级:%@",@"降级");
        [self requestBySwipCardStateWithMessage:@"刷卡降级"];
    }else{
        NSLog(@"是否降级:%@",@"正常");
    }
    
    
    [self showHUDWihtMessage:@"刷卡成功"];
    [self hidHUDWithDelay:2];
    [self popGoBackDelayWithTime:2];
    
}





@end
