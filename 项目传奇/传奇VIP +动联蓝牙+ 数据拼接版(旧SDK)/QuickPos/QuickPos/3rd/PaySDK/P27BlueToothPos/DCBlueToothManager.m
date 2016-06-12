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
#import "DCBTDataModel.h"
#import "CardInfoModel.h"
#import "Pos.h"
#import "vcom.h"

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
    DCBTDataModel             *_dcBTDataModel;
    
}
@property (nonatomic,strong) DCSwiperAPI *dcSwiper;
@property (nonatomic,strong) PSTAlertController *pstaControler;
@property (nonatomic, strong)vcom *mVcom;
@end

@implementation DCBlueToothManager
@synthesize mVcom;
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
        
        
        mVcom = [vcom getInstance];
        [mVcom setEventListener:self];
        [mVcom open];
        //    [mVcom setVloumn:85];
        [mVcom setDebug:YES];
        //    初始化爱刷刷卡头
        [mVcom setCommmunicatinMode:BLE_DianFB];


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
- (void)onDCEMVCardData:(NSDictionary *)cardDic
{
    NSLog(@"+++++++++++++刷卡返回信息%@",cardDic);
    [self endHUD];
    _dcBTDataModel = [[DCBTDataModel alloc]initDCBTDataModelWithDict:cardDic];
    
    //    目前的情况是 我们这边有两个版本 一个是拼接的版本 一个是拆分的版本 拆分的版本缺少等效信息的字段内容 未拆分的版本这边我们要等后天反馈信息
    
    
    //1磁数据
    NSString *track1LengthM = _dcBTDataModel.track1Length;
    int track1Length  = [track1LengthM intValue];
    
    //2磁数据
    NSString *track2LengthM = _dcBTDataModel.track2Length;
    int track2Length  = [track2LengthM intValue];
    //3磁数据
    NSString *track3LengthM = _dcBTDataModel.track3Length;
    int track3Length  = [track3LengthM intValue];
    
    //获取psam卡号
    NSString *psam = _dcBTDataModel.psamNo;
    //获取设备号
    //    NSString *head = [mVcom HexValue:vs->hardSerialNo Len:vs->hardSerialNoLen];
    //获取ksn
    
    NSString *ksnNotPsam = _dcBTDataModel.ksn;
    NSString *ksn        = [NSString stringWithFormat:@"%@%@",ksnNotPsam,psam];
    //获取磁道明文
    //        NSString *trackPlain = [mVcom HexValue:vs->trackPlaintext Len:vs->trackPlaintextLen];
    //获取磁道密文
    NSString *encTracks = _dcBTDataModel.encTracks;
    //卡号
    NSString *maskedPAN = _dcBTDataModel.cardNum;
    //获取mac
    NSString *mac = _dcBTDataModel.mac;
    
    
    //获取PAN
    NSString *PAN = _dcBTDataModel.pan;
    //获取55域数据
    NSString *data55 = _dcBTDataModel.emvDataInfo;
    //获取卡有效期
    NSString *expiryDate = _dcBTDataModel.expiryDate;
    //猎取卡序列号
    NSString *serialNum = _dcBTDataModel.cardSerial;
    //随机数
    NSString *randomNumber = _dcBTDataModel.randomNumber;
    //卡类型:（0表示纯磁条卡，1 IC卡，2表示双介质卡，）
    NSString *cardType = _dcBTDataModel.cardType;
    int       type = [cardType intValue];
    
    NSString *cardHolderName = @"";
    NSString *cvm = @"";
    NSString *readBuf = @"";
    
    
    
    NSString* string =[[NSString alloc] initWithFormat:@"ksn:%@\n encTracks:%@ \n track1Length:%d \n track2Length:%d \n track3Length:%d \n randomNumber:%@ \n cardNum:%@ \n PAN:%@ \n expiryDate:%@ \n cardHolderName:%@ \n mac:%@ \n cardType:%d \n cardSerial:%@ \n emvDataInfo:%@ \n cmv:%@  \n readBuf:%@",ksn,encTracks,track1Length,track2Length,track3Length,randomNumber, maskedPAN,PAN,expiryDate,cardHolderName,mac,type,serialNum,data55,cvm,readBuf];
    NSLog(@"%@",string);
    
    NSString *cardInfo = nil;
    CardInfoModel *CardInfo = nil;
    
    
    
    if (encTracks && encTracks.length > 0) {
        
        //由于动联已经对二磁信息以及三磁信息做过转换16 这里就不转换直接用
        
//        NSString *strTrack1Length = [self intToHexString:track1Length lenght:2];
//        NSString *strTrack2Length = [self intToHexString:track2Length lenght:2];
//        NSString *strTrack3Length = [self intToHexString:track3Length lenght:2];
        NSString *strTrack1Length = track1LengthM ;
        NSString *strTrack2Length = track2LengthM ;
        NSString *strTrack3Length = track3LengthM ;
        NSString *randomLenght = [self intToHexString:(int)[randomNumber length]/2 lenght:2];
        NSString *ksnLenght = [self intToHexString:(int)[ksn length]/2 lenght:2];
        //        NSString *macStr  = [self hexStringFromString:mac];
        
        if (track2Length == 0) {
            strTrack2Length = @"18";
        }
        maskedPAN = [self hexStringFromString:maskedPAN];
        //        NSString *macStr = [self hexStringFromString:mac];
        NSString *maskedPANLenght = [self intToHexString:(int)[maskedPAN length]/2 lenght:2];
        
        NSString *track2 = [encTracks substringToIndex:track2Length*2];
        NSString *track3 = [encTracks substringFromIndex:track2Length*2];
        
        NSLog(@"KSN信息 ----- > %@",ksn);
        NSLog(@"磁道信息 ----- > %@",encTracks);
        NSLog(@"二磁数据 ----- > %@",track2);
        NSLog(@"三磁数据 ----- > %@",track3);
        NSLog(@"2磁长度 ----- >%i,16:%@",track2Length,strTrack2Length);
        NSLog(@"3磁长度 ----- >%i,16:%@",track3Length,strTrack3Length);
        NSLog(@"随机数 ----- > %@",randomNumber);
        NSLog(@"随机数长度 ----- > %@",randomLenght);
        NSLog(@"卡号 ----- > %@",maskedPAN);
        NSLog(@"卡号长度 ----- > %@",maskedPANLenght);
        NSLog(@"卡有效期 ----- > %@",expiryDate);
        NSLog(@"MAC ----- > %@",mac);
        NSLog(@"所有信息 ----- > %@",readBuf);
        
        if ([expiryDate length] == 4) {
            expiryDate = [mVcom HexValue:(char*)[expiryDate cStringUsingEncoding:NSASCIIStringEncoding] Len:(int)[expiryDate length]];
        }
        
        
        if (serialNum.length == 2) {
            serialNum = [@"0" stringByAppendingString:serialNum];
            serialNum = [mVcom HexValue:(char*)[serialNum cStringUsingEncoding:NSASCIIStringEncoding] Len:[serialNum length]];
        } else if (serialNum.length == 0 && data55.length > 0) {
            serialNum = @"303030";
        }
        
        
        
        CardInfo = [[CardInfoModel alloc]init];
        [CardInfo setTrack:encTracks];
        [CardInfo setTrack2Lenght:[NSString stringWithFormat:@"%d",track2Length]];
        [CardInfo setTrack3Lenght:[NSString stringWithFormat:@"%d",track3Length]];
        //    [CardInfo setDeviceNo:[NSString stringWithFormat:@"%@",DeviceNo]];
        //    [CardInfo setPsamNO:[NSString stringWithFormat:@"%@",]];
        [CardInfo setRandom:[NSString stringWithFormat:@"%@",randomNumber]];
        [CardInfo setCardNO:[NSString stringWithFormat:@"%@",maskedPAN]];
        [CardInfo setExpiryDate:[NSString stringWithFormat:@"%@",expiryDate]];
        [CardInfo setMac:[NSString stringWithFormat:@"%@",mac]];
        [CardInfo setSequensNo:serialNum];
        [CardInfo setData55:data55];
        [CardInfo setHasPassword:YES];
        
        NSString *trankLenght = [self intToHexString:[encTracks length]/2 lenght:2];
        
        NSString *info = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",strTrack1Length, strTrack2Length, strTrack3Length, randomLenght, ksnLenght, maskedPANLenght, track2, track3,randomNumber,ksn,maskedPAN,expiryDate,mac];
        
        cardInfo = [NSString stringWithFormat:@"FF00%@%@",[self intToHexString:(int)[info length]/2 lenght:4],info];
        
        [CardInfo setCardInfo: [NSString stringWithFormat:@"%@",cardInfo]];
        
         NSLog(@"=====>> cardInfo=====>%@",cardInfo);
        
        //磁条卡刷卡
        if ([_delegate respondsToSelector:@selector(dcBlueToothManagerResponseByCardInfo:)]) {
            [_delegate dcBlueToothManagerResponseByCardInfo:CardInfo];
        }
    }
    //ic卡刷卡
    else{
        //ic刷卡 由于此sdk 并未返回磁道信息 所以ic卡刷卡暂不能成功 
        
        NSString *strTrack1Length = track1LengthM ;
        NSString *strTrack2Length = track2LengthM ;
        NSString *strTrack3Length = track3LengthM ;
        NSString *randomLenght = [self intToHexString:(int)[randomNumber length]/2 lenght:2];
        NSString *ksnLenght = [self intToHexString:(int)[ksn length]/2 lenght:2];
        //        NSString *macStr  = [self hexStringFromString:mac];
        
        if (track2Length == 0) {
            strTrack2Length = @"18";
        }
        maskedPAN = [self hexStringFromString:maskedPAN];
        //        NSString *macStr = [self hexStringFromString:mac];
        NSString *maskedPANLenght = [self intToHexString:(int)[maskedPAN length]/2 lenght:2];
        
        NSString *track2 = [encTracks substringToIndex:track2Length*2];
        NSString *track3 = [encTracks substringFromIndex:track2Length*2];
        
        NSLog(@"KSN信息 ----- > %@",ksn);
        NSLog(@"磁道信息 ----- > %@",encTracks);
        NSLog(@"二磁数据 ----- > %@",track2);
        NSLog(@"三磁数据 ----- > %@",track3);
        NSLog(@"2磁长度 ----- >%i,16:%@",track2Length,strTrack2Length);
        NSLog(@"3磁长度 ----- >%i,16:%@",track3Length,strTrack3Length);
        NSLog(@"随机数 ----- > %@",randomNumber);
        NSLog(@"随机数长度 ----- > %@",randomLenght);
        NSLog(@"卡号 ----- > %@",maskedPAN);
        NSLog(@"卡号长度 ----- > %@",maskedPANLenght);
        NSLog(@"卡有效期 ----- > %@",expiryDate);
        NSLog(@"MAC ----- > %@",mac);
        NSLog(@"所有信息 ----- > %@",readBuf);
        
        if ([expiryDate length] == 4) {
            expiryDate = [mVcom HexValue:(char*)[expiryDate cStringUsingEncoding:NSASCIIStringEncoding] Len:(int)[expiryDate length]];
        }
        
        
        if (serialNum.length == 2) {
            serialNum = [@"0" stringByAppendingString:serialNum];
            serialNum = [mVcom HexValue:(char*)[serialNum cStringUsingEncoding:NSASCIIStringEncoding] Len:[serialNum length]];
        } else if (serialNum.length == 0 && data55.length > 0) {
            serialNum = @"303030";
        }
        
        
        
        CardInfo = [[CardInfoModel alloc]init];
        [CardInfo setTrack:encTracks];
        [CardInfo setTrack2Lenght:[NSString stringWithFormat:@"%d",track2Length]];
        [CardInfo setTrack3Lenght:[NSString stringWithFormat:@"%d",track3Length]];
        //    [CardInfo setDeviceNo:[NSString stringWithFormat:@"%@",DeviceNo]];
        //    [CardInfo setPsamNO:[NSString stringWithFormat:@"%@",]];
        
        randomNumber = [data55 substringFromIndex:data55.length-8];   //从data55 获取ic卡信息加密随机数
        [CardInfo setRandom:[NSString stringWithFormat:@"%@",randomNumber]];
        [CardInfo setCardNO:[NSString stringWithFormat:@"%@",maskedPAN]];
        [CardInfo setExpiryDate:[NSString stringWithFormat:@"%@",_dcBTDataModel.expiryDate]]; //ic卡刷卡传原始有效期 不做处理
        [CardInfo setMac:[NSString stringWithFormat:@"%@",mac]];
        [CardInfo setSequensNo:serialNum];
        [CardInfo setData55:data55];
        [CardInfo setHasPassword:YES];
        
        NSString *trankLenght = [self intToHexString:[encTracks length]/2 lenght:2];
        
        NSString *info = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",strTrack1Length, strTrack2Length, strTrack3Length, randomLenght, ksnLenght, maskedPANLenght, track2, track3,randomNumber,ksn,maskedPAN,expiryDate,mac];
        
        cardInfo = [NSString stringWithFormat:@"FF00%@%@",[self intToHexString:(int)[info length]/2 lenght:4],info];
        
        [CardInfo setCardInfo: [NSString stringWithFormat:@"%@",cardInfo]];
        
        NSLog(@"=====>> cardInfo=====>%@",cardInfo);

        
        if ([_delegate respondsToSelector:@selector(dcBlueToothManagerResponseByCardInfo:)]) {
            [_delegate dcBlueToothManagerResponseByCardInfo:CardInfo];
        }
    }
    
    
   
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
    
    NSLog(@"订单号:%@   流水号:%@",_orderId,_transLogo);
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

//字符串转16进制
- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
// int数值转16进制数值 返回16进制表示的字符串,可定义长度,不足补0
- (NSString*) intToHexString:(int)num lenght:(int)lenght{
    NSString *format = [NSString stringWithFormat:@"%%0%iX",lenght];
    return [NSString stringWithFormat:format,num];
}



- (void)showAlertView:(NSString *)title messgae:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
@end
