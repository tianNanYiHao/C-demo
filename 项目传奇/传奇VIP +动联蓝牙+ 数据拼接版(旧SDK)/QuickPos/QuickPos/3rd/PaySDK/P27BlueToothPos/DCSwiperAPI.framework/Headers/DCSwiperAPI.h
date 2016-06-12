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
  ERROR_FAIL_ICCARD,          //IC卡操作错误
  ERROR_FAIL_TIMEOUT,       //超时
  ERROR_FAIL_DATA,         //数据错误
  ERROR_FAIL_NEEDIC,      //请插IC卡
  ERROR_FAIL_MCCARD     //磁条卡刷卡失败
   
}ErrorFile;


typedef enum {
    
    DCEMVErrorType_OK = 0,         //签到成功

    DCEMVErrorType_ERROR_ICCARD,  //IC卡操作错误
    DCEMVErrorType_ERROR_TIMEOUT,   //超时
    DCEMVErrorType_ERROR_DATA,   //数据错误
    DCEMVErrorType_ERROR_NotIccCard,//插入的不是IC卡
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

typedef enum
{
    STATE_ACTIVE = 0,
    STATE_IDLE = 1,
    STATE_BUSY = 2,
    STATE_UNACTIVE = -1
}DeviceBlueState;



typedef enum {
    DCEMVBatteryStatus_CriticallyLow, //电量极低
    DCEMVBatteryStatus_Low,//电量低
    DCEMVBatteryStatus_Normal  //有电(正常)
} DCEMVBatteryStatus;




typedef enum {
    DCEMVTransactionType_Payment,//消费
    DCEMVTransactionType_Inquiry,//查询
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

//扫描设备结果
//-(void)onFindBlueDevice:(NSDictionary *)dic;
- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral;

//连接设备结果
//-(void)onDidConnectBlueDevice:(NSDictionary *)dic;
- (void)onDidConnectBluetoothDevice:(CBPeripheral *)peripheral;

//失去连接到设备
- (void)onDisconnectBluetoothDevice:(CBPeripheral *)peripheral;

-(void)onDetectCard;

//等待刷卡
- (void)onWaitingForCard;


//获取设备信息
/*
 设备信息返回
 参数:deviceInfoDict
 包含：

 terminalId = AAAA9527000111943953;-----终端id  
 psamNo = 9527000111943953;//psam卡号           

 */
//回调为：
- (void)DCEMVReturnDeviceInfo:(NSDictionary *)deviceInfoDict;



//异常错误
- (void)onDCEMVError:(DCEMVErrorType)DCEMVErrorType errorMessage:(NSString *)errorMessage;

//取消交易
- (void)onDCEMVPOSCancel;


/**
 *  刷卡或插卡返回
 *
 *  @param cardDic
 */
- (void)onDCEMVCardData:(NSDictionary *)cardDic;

/*
 电量状态
 参数:batteryStatus
 */
- (void)DCEMVBatteryLow:(DCEMVBatteryStatus)batteryStatus;


//返回卡号
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
    int intDeviceBlueState;

}

@property(nonatomic) id<DCSwiperAPIDelegate> delegate;
@property (nonatomic) BOOL isConnectBlue;
@property (nonatomic, retain) NSDictionary *dicCurrect;
@property(nonatomic) cardType  currentCardType;


//获取sdk版本号
- (NSString *)getApiVersion;


/*
 SDK初始化
 获取实例
 */
+ (DCSwiperAPI *)sharedDCEMV;


//获取设备状态
- (DCEMVState)getDCEMVState;


//获取设备信息
- (void)getDeviceInfo;


//获取设备电量
- (void)getDeviceElectric;


//获取银行卡卡号     
- (void)getCardNumber;

/*
 启动刷卡
 参数:
 orderId--订单号 16位字符
 transLogo--流水号 6位字符
 cash -- 交易金额（单位：分）
 transactType-- 交易类型 消费显示金额  余额查询不要显示金额
 
 插IC卡的回调：- (void)onYJEMVICData:(NSDictionary *)icInfo;
 刷磁条卡的回调：- (void)onYJEMVTrackData:(NSDictionary *)trackInfo;
 */
- (void)startPOS:(NSString *)orderId transLogo:(NSString *)transLogo cash:(NSInteger)cash transactType:(DCEMVTransactionType)transactType;



//通知设备交易结果
- (void)sendPayResult:(NSString *)result succeed:(BOOL)succeed;


//取消交易  取消刷卡  (不分词条IC卡)
- (void)cancelPinInput;


//蓝牙是否已连接
- (BOOL)isBTConnected;

/*
 开始搜索
 搜索蓝牙设备
 */
-(void)scanBlueDevice;



/*
 停止搜索
 停止扫描蓝牙
 */
-(void)stopScanBlueDevice;


/*
 连接蓝牙设备
 */
-(BOOL)connectBluetoothDevice:(CBPeripheral *)peripheral;


/*
 断开蓝牙设备
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
