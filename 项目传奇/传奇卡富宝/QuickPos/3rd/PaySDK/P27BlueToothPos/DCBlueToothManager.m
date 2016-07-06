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
#define UUIDNAME   [[NSUserDefaults standardUserDefaults] objectForKey:@"SerialNumber"]
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



-(void)searchDCBlueTooth{
    
    if (_swipeAgain) {
        [_dcSwiper cancelTrade];
        
    }else{
        if (_BTNameArray.count>0) {
            [_BTNameArray removeAllObjects];
        }
        if (_dcBlueToothManager) {
            [_dcSwiper scanBlueDevice];
            [self showHUDWithString:[NSString stringWithFormat:@"%@蓝牙搜索中",[[NSUserDefaults standardUserDefaults] objectForKey:@"SerialNumber"]]];
            _FirstSearchType = FirstSearch;
            _swipeAgain = YES;
        }
    }

}
-(void)disConnectDCBlueTooth{
    [_dcSwiper disConnect];
}

-(void)cancleSwipeCard{
  [self popViewGoBackWithMessage:@"您取消了刷卡"];
}

-(void)popViewGoBackWithMessage:(NSString*)message{
    [self endHUD];
    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:message message:@"即将退回下订单页面"];
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"是" handler:^(PSTAlertAction *action) {
        
        if ([message isEqualToString:@"您取消了刷卡"]) {
            _deviceBreak = @"deviceIsBraekSelf";
            [_dcSwiper disConnect];
        }

        [_viewController.navigationController popViewControllerAnimated:YES];
    }]];
    
    [gotoPageController showWithSender:nil controller:_viewController animated:YES completion:NULL];
    
}

-(void)stopSearchDCBlueToothWithTimeOut:(NSString*)match{
    
    if ([_isMatched isEqualToString:@"YES"]) {
        
    }
    else if([_isMatched isEqualToString:@"NO"]){
        if ([_dcSwiper isBTConnected]) {
            
        }else{
            if (_FirstSearchType == FirstSearch) {
                _swipeAgain = NO;
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
- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral{
    
    
    NSString *bdm = [[NSUserDefaults standardUserDefaults] objectForKey:@"SerialNumber"];
    
    [[NSUserDefaults standardUserDefaults] boolForKey:@"SerialNumber"];
    
    NSLog(@"***** bdm ******* %@",bdm);
    NSLog(@"name name name name name  ===  %@",peripheral.name);
    
    if ([peripheral.name isEqualToString:bdm]) {
        [_BTNameDict setObject:peripheral forKey:peripheral.name];
        _peripheralSure = [_BTNameDict objectForKey:peripheral.name];
        [_dcSwiper connectBluetoothDevice:_peripheralSure];
        _isMatched = @"YES";
    }
    else
    {
        _isMatched = @"NO";
    }
    
    
    if ([_isMatched isEqualToString:@"YES"]) {
        
    }else{
        [self performSelector:@selector(stopSearchDCBlueToothWithTimeOut:) withObject:nil afterDelay:5];
    }

}


- (void)onDidConnectBluetoothDevice:(CBPeripheral *)peripheral
{
    [_dcSwiper stopScanBlueDevice];
    [_dcSwiper cancelTrade];
  
}
- (void)onDisconnectBluetoothDevice:(CBPeripheral *)peripheral
{
     _swipeAgain = NO;
     [self endHUD];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"startswipe" object:nil userInfo:[NSDictionary dictionaryWithObject:@"no" forKey:@"showSwipe"]];

    if ([_deviceBreak isEqualToString:@"deviceIsBraekSelf"]) { //如果选择了取消刷卡
        _deviceBreak = @"";
    }
    else{
        PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:@"您的设备已断开" message:@"即将退回下订单页面"];
        [gotoPageController addAction:[PSTAlertAction actionWithTitle:@"是" handler:^(PSTAlertAction *action) {
            _deviceBackInfo = DEVICEBACKINFO;
            [_viewController.navigationController popViewControllerAnimated:YES];
        }]];
        [gotoPageController showWithSender:nil controller:_viewController animated:YES completion:NULL];
    }
}
- (void)DCEMVReturnDeviceInfo:(NSDictionary *)deviceInfoDict{
}

- (void)onWaitingForCard
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startswipe" object:nil userInfo:[NSDictionary dictionaryWithObject:@"yes" forKey:@"showSwipe"]];
    [self showHUDWithString:@"请刷卡"];
}
-(void)onDetectCard
{
    [self endHUD];
    [self showHUDWithString:@"正在刷卡中,请稍后"];
    
}
- (void)onDCEMVCardData:(NSDictionary *)cardDic
{
    [self endHUD];
    _dcBTDataModel = [[DCBTDataModel alloc]initDCBTDataModelWithDict:cardDic];
    //磁条卡打包信息
    NSString *trackInfo = _dcBTDataModel.encTrackAll;
    
    //ic卡打包信息
    NSString *icCardInfo = _dcBTDataModel.encICAll;

    //ic卡Track等效信息
    NSString *track2  = _dcBTDataModel.encTrack2;
    
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
    NSString *encTrack = _dcBTDataModel.encTrack;
    //卡号
    NSString *maskedPAN = _dcBTDataModel.cardNum;
    //获取mac
    NSString *mac = _dcBTDataModel.mac;
    
    
    //获取PAN
    NSString *PAN = _dcBTDataModel.pan;
   
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
    
    
    NSString *cardInfo = nil;
    CardInfoModel *CardInfo = nil;
    CardInfo = [[CardInfoModel alloc]init];
    
    //区分ic 磁条卡
    NSString *data55 = [NSString new];
    if ([cardType isEqualToString:@"0"]) {
        CardInfo.cardInfo = trackInfo;
        //获取55域数据
        data55 = _dcBTDataModel.emvDataInfo;
    }else if([cardType isEqualToString:@"1"]){
        CardInfo.cardInfo = icCardInfo;
        //获取55域数据
        data55 = _dcBTDataModel.emv55DataInfo;
        
    }
    
    [CardInfo setTrack:encTrack];
    [CardInfo setTrack2Lenght:[NSString stringWithFormat:@"%d",track2Length]];
    [CardInfo setTrack3Lenght:[NSString stringWithFormat:@"%d",track3Length]];
    //    [CardInfo setDeviceNo:[NSString stringWithFormat:@"%@",DeviceNo]];
    //    [CardInfo setPsamNO:[NSString stringWithFormat:@"%@",]];
    [CardInfo setRandom:[NSString stringWithFormat:@"%@",randomNumber]];
    [CardInfo setCardNO:[NSString stringWithFormat:@"%@",maskedPAN]];
    [CardInfo setCardNum:_dcBTDataModel.cardNum];
    [CardInfo setExpiryDate:[NSString stringWithFormat:@"%@",expiryDate]];
    [CardInfo setMac:[NSString stringWithFormat:@"%@",mac]];
    [CardInfo setSequensNo:serialNum];
    [CardInfo setData55:data55];
    [CardInfo setHasPassword:YES];

    
    NSString* string =[[NSString alloc] initWithFormat:@"ksn:%@\n encTracks:%@ \n track1Length:%d \n track2Length:%d \n track3Length:%d \n randomNumber:%@ \n cardNum:%@ \n PAN:%@ \n expiryDate:%@ \n cardHolderName:%@ \n mac:%@ \n cardType:%d \n cardSerial:%@ \n emvDataInfo:%@ \n cmv:%@  \n readBuf:%@",ksn,encTrack,track1Length,track2Length,track3Length,randomNumber, maskedPAN,PAN,expiryDate,cardHolderName,mac,type,serialNum,data55,cvm,readBuf];
    NSLog(@"%@",string);
    
    if ([_delegate respondsToSelector:@selector(dcBlueToothManagerResponseByCardInfo:)]) {
        [_delegate dcBlueToothManagerResponseByCardInfo:CardInfo];
    }
}

-(void)onDCCardNumber:(NSString *)cardNumber{
    [self endHUD];
    [self showAlertView:cardNumber messgae:@"确认卡号"];
}


-(void)onDCEMVPOSCancel{
    [self endHUD];
    [_dcSwiper startPOS:_orderId transLogo:_transLogo cash:_cash transactType:_actionType];  //刷卡
    
}

-(void)DCEMVBatteryLow:(DCEMVBatteryStatus)batteryStatus{
    [self showAlertView:@"电量" messgae:[NSString stringWithFormat:@"%d",batteryStatus]];
}

- (void)onDCEMVError:(DCEMVErrorType)DCEMVErrorType errorMessage:(NSString *)errorMessage
{

    switch (DCEMVErrorType) {
        case DCEMVErrorType_ERROR_NotIccCard:
            [self popViewGoBackWithMessage:@"请插入ic卡"];
            
            break;
        case DCEMVErrorType_ERROR_BadSwipe:
            [self popViewGoBackWithMessage:@"读磁条卡失败"];
            
            break;
        case DCEMVErrorType_ERROR_TIMEOUT:
            [self popViewGoBackWithMessage:@"蓝牙连接超时"];
            break;
            
        case DCEMVErrorType_ERROR_DATA:
            [self popViewGoBackWithMessage:@"数据域错误"];
            
            
            break;
            
        case DCEMVErrorType_ERROR_ICCARD:
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
