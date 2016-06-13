//
//  DCSwiperAPI.h
//  DCSwiperAPI
//
//  Created by dc on 16/1/6.
//  Copyright © 2016年 dc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


typedef enum {
    
  ERROR_OK = 0,               //签到成功
  ERROR_FAIL_ICCARD,          //IC卡操作错误或写入密钥错误
  ERROR_FAIL_TIMEOUT,       //超时
  ERROR_FAIL_DATA,         //数据错误
  ERROR_FAIL_NEEDIC,      //请插IC卡
  ERROR_FAIL_MCCARD     //磁条卡刷卡失败
   
}ErrorFile;


typedef enum {
    
    DCEMVErrorType_OK = 0,         //签到成功

    DCEMVErrorType_ERROR_ICCARD,  //IC卡操作错误或写入密钥错误
    DCEMVErrorType_ERROR_TIMEOUT,   //超时
    DCEMVErrorType_ERROR_DATA,   //数据错误
    DCEMVErrorType_ERROR_NotIccCard,//请插IC卡
    DCEMVErrorType_ERROR_BadSwipe,//磁条卡刷卡失败

} DCEMVErrorType;


//设备状态
typedef enum {
    DCEMVState_CommLinkUninitialized = 0,//设备未初始化
    DCEMVState_Idle,//设备空闲
    DCEMVState_Busy,//设备处理中（上一指令未完成）
    DCEMVState_Printing,//正在打印
    DCEMVState_WaitingForResponse = -1//等待设备响应
    
} DCEMVState;

//蓝牙状态
typedef enum
{
    STATE_ACTIVE = 0,//活跃的
    STATE_IDLE = 1,//闲置的
    STATE_BUSY = 2,//繁忙的
    STATE_UNACTIVE = -1//非活跃状态
}DeviceBlueState;



typedef enum {
    DCEMVBatteryStatus_CriticallyLow, //电量极低
    DCEMVBatteryStatus_Low,//电量低
    DCEMVBatteryStatus_Normal  //有电(正常)
} DCEMVBatteryStatus;




typedef enum {
    DCEMVTransactionType_GetCardNo = 0,//获取卡号
    DCEMVTransactionType_Payment = 1,//消费
    DCEMVTransactionType_Inquiry = 2,//查询
} DCEMVTransactionType;



typedef enum
{
    card_mc = 1,        //磁条卡
    card_ic = 2,        //IC卡
    card_all = 3        //银行卡
}cardType;              //银行卡类型

@protocol DCSwiperAPIDelegate <NSObject>

@optional

//蓝牙未启动
- (void)dontStarBluetooth;

/**
 *  扫描到蓝牙信息，扫描一次回调一次
 *
 *  @param peripheral
 */
- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral;

/**
 *  连接设备的回调
 *
 *  @param peripheral
 */
- (void)onDidConnectBluetoothDevice:(CBPeripheral *)peripheral;

/**
 *  断开连接的回调
 *
 *  @param peripheral
 */
- (void)onDisconnectBluetoothDevice:(CBPeripheral *)peripheral;

/**
 *  读到卡片
 */
-(void)onDetectCard;

/**
 *  等待刷卡
 */
- (void)onWaitingForCard;

/**
 *  获取设备信息的回调
 *
 *  @param deviceInfoDict   terminalId = 终端id
                            psamNo = psam号
 */
- (void)DCEMVReturnDeviceInfo:(NSDictionary *)deviceInfoDict;

/**
 *  异常错误
 *
 *  @param DCEMVErrorType
 *  @param errorMessage
 */
- (void)onDCEMVError:(DCEMVErrorType)DCEMVErrorType errorMessage:(NSString *)errorMessage;

/**
 * 取消交易的回调
 */
- (void)onDCEMVPOSCancel;


/**
 *  刷卡或插卡返回
 *
 *  @param cardDic
 */
- (void)onDCEMVCardData:(NSDictionary *)cardDic;

/**
 *  获取电量的返回
 *
 *  @param batteryStatus
 */
- (void)DCEMVBatteryLow:(DCEMVBatteryStatus)batteryStatus;


/**
 *  获取卡号的返回
 *
 *  @param cardNumber 卡号
 */
- (void)onDCCardNumber:(NSString *)cardNumber;


/**
 *  导入主密钥返回
 *
 *  @param isSuccess YES OR NO
 */
-(void)onDidLoadMainKey:(BOOL)isSuccess;

/**
 *  签到回调（更新工作秘钥）
 *
 *  @param isSuccess 成功
 */
-(void)onDidUpdateKey:(BOOL)isSuccess;





//加密Pin结果
-(void)onEncryptPinBlock:(NSString *)encPINblock;
//
//读取ksn结果
-(void)onDidGetDeviceKsn:(NSDictionary *)dic;
//
//mac计算结果
-(void)onDidGetMac:(NSString *)strmac;

@end


@interface DCSwiperAPI : NSObject
{
    int intDeviceBlueState;//当前蓝牙状态
}

@property(nonatomic,weak) id<DCSwiperAPIDelegate> delegate;
@property (nonatomic) BOOL isConnectBlue;
@property(nonatomic) cardType  currentCardType;


/**
 *  获取sdk版本号
 *
 *  @return
 */
- (NSString *)getApiVersion;

/**
 *  SDK初始化
 *
 *  @return
 */
+ (DCSwiperAPI *)sharedDCEMV;

/**
 *  获取设备状态
 *
 *  @return
 */
- (DCEMVState)getDCEMVState;

/**
 *  获取设备信息
 */
- (void)getDeviceInfo;

/**
 *  获取设备电量
 */
- (void)getDeviceElectric;

/**
 *  获取银行卡卡号
 */
- (void)getCardNumber;

/**
 *  刷卡或插卡
 *
 *  @param orderId      订单号 16位字符
 *  @param transLogo    流水号 6位字符
 *  @param cash         交易金额
 *  @param transactType 交易类型
 */
- (void)startPOS:(NSString *)orderId transLogo:(NSString *)transLogo cash:(NSInteger)cash transactType:(DCEMVTransactionType)transactType;

/**
 *  取消交易/复位
 */
- (void)cancelTrade;


/**
 *  /蓝牙是否连接
 *
 *  @return 
 */
- (BOOL)isBTConnected;

/**
 *  搜索蓝牙
 */
-(void)scanBlueDevice;

/**
 *  停止搜索
 */
-(void)stopScanBlueDevice;

/**
 *  连接蓝牙对象
 *
 *  @param peripheral
 */
-(void)connectBluetoothDevice:(CBPeripheral *)peripheral;

/**
 *  断开蓝牙连接
 */
-(void)disConnect;

/**
 *  写入主密钥
 *
 *  @param mainKey
 */
-(void)loadMainKey:(NSString *)mainKey;

/**
 *   写入工作密钥
 *
 *  @param pinKey、（32位密钥 + 8位checkValue = 40位）
 */
-(void)updateKey:(NSString *)pinKey;





/*
 获取ksn编号,
 */
// -(void)getDeviceKsn;

/*
 加密pin
 */
//-(void)encryptPin:(NSString *)Pin;


/*
 计算mac
 (消费与查余额时 macdata 位数不同，所以接口对于传入参数的位数最好不要做限制，​若有需要，sdk自行补位）
 */
//-(void)getMacValue:(NSString *)data;




@end
