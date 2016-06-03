//
//  DCBlueToothManager.m
//  P27BlueToothPosManager
//
//  Created by Aotu on 16/5/26.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "DCBlueToothManager.h"
#import <DCSwiperAPI/DCSwiperAPI.h>


@interface DCBlueToothManager ()<DCSwiperAPIDelegate>

@property (nonatomic,strong) DCSwiperAPI *dcSwiper;

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
    }
    return self;
}


#pragma mark - dcwiperapi delegate  == SDK的代理方法集合
//当扫描设备是反馈结果
//(多次调用 获取设备 name )(每当搜索到新的蓝牙才会调用,以前的蓝牙搜索到了,关闭再打开是不会再调用此方法的!)
- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral{
    
//    [_BTNameDict setObject:peripheral forKey:peripheral.identifier.UUIDString];
//    NSLog(@"_BTNameDict =====>> %@",_BTNameDict);
//    NSString *name = peripheral.name;
//    NSString *identifier = peripheral.identifier.UUIDString;
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",identifier,@"identifier" ,nil];
//    
//    
//    [_BTNameArray addObject:dict];
//    [_tableview reloadData];
//    NSLog(@"_BTNameArray ======>> %@",_BTNameArray);
    
}



//当设备连接成功时反馈
- (void)onDidConnectBluetoothDevice:(CBPeripheral *)peripheral
{
    NSLog(@"+++++++++++++设备连接成功");
    [self showAlertView:@"设备连接成功" messgae:peripheral.name];
    
}
//当点击断开连接时反馈(且一旦检测到失去连接,就反馈)
- (void)onDisconnectBluetoothDevice:(CBPeripheral *)peripheral
{
    NSLog(@"+++++++++++++设备断开");
    [self showAlertView:@"设备已断开连接" messgae:peripheral.name];
    
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
    [self showAlertView:@"刷卡提示" messgae:@"请刷卡！"];
}
//当刷卡进行时获取卡信息的反馈
-(void)onDetectCard
{
    NSLog(@"+++++++++++++正在刷卡,获取卡信息数据");
//    [self showHUDWithString:@"正在刷卡中,请稍后"];
    
}
//当刷IC卡的时候反馈
-(void)onDCEMVICData:(NSDictionary *)icInfo{
    NSLog(@"+++++++++++++刷IC卡返回信息%@",icInfo);
//    [self endHUD];
//    self.showLab.font = [UIFont systemFontOfSize:5];
//    self.showLab.text = [NSString stringWithFormat:@"%@",icInfo];
    
}
//当刷磁条卡Track时反馈
-(void)onDCEMVTrackData:(NSDictionary *)trackInfo{
    NSLog(@"+++++++++++++刷磁条Track卡返回信息%@",trackInfo);
//    [self endHUD];
//    self.showLab.font = [UIFont systemFontOfSize:5];
//    self.showLab.text = [NSString stringWithFormat:@"%@",trackInfo];
}

//当刷卡后获取卡号的反馈
-(void)onDCCardNumber:(NSString *)cardNumber{
//    [self endHUD];
    [self showAlertView:cardNumber messgae:@"确认卡号"];
}


//当取消刷卡时反馈
-(void)onDCEMVPOSCancel{
    [self showAlertView:@"取消/复位" messgae:@"成功"];
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
            [self showAlertView:nil messgae:@"请插入ic卡"];
            break;
        case DCEMVErrorType_ERROR_BadSwipe:
            [self showAlertView:nil messgae:@"读磁条卡失败"];
            break;
        case DCEMVErrorType_ERROR_TIMEOUT:
            [self showAlertView:nil messgae:@"超时"];
            break;
            
        case DCEMVErrorType_ERROR_DATA:
            [self showAlertView:nil messgae:@"数据域错误"];
            break;
            
        case DCEMVErrorType_ERROR_ICCARD:
            [self showAlertView:nil messgae:@"IC卡操作错误"];
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
