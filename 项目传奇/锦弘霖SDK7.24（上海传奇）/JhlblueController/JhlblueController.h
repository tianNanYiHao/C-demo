//
//  JhlblueController.h
//  JhlblueController
//
//  Created by gui hua on 16/4/5.
//  Copyright © 2016年 szjhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>




#define GETCARD_CMD  0x12
#define GETTRACK_CMD 0x20
#define GETTRACKDATA_CMD 0x22  //0xE1  用户取消  0xE2 超时退出 E3 IC卡数据处理失败 0xE4 无IC卡参数 0xE5 交易终止 0xE6 操作失败,请重试

#define CHECK_IC_CMD 0x24
#define MAINKEY_CMD  0x34
#define PINBLOCK_CMD 0x36
#define GETMAC_CMD   0x37
#define WORKKEY_CMD  0x38
#define GETSNVERSION_CMD 0x40
#define GETTERNUMBER_CMD 0x41
#define WRITETERNUMBER_CMD   0x42
#define YY_GETTRACK_CMD 0xff
#define GAINPARAMETER_CMD  0x50
#define SWIPREAD_CMD       0xA0
#define MAGN_CANCEL_CMD     0x99  //取消刷卡

#define WriteAidParm_CMD   0x33  //AID
#define ClearAidParm_CMD   0x3A  //清空AID
#define WriteCpkParm_CMD   0x32  //公钥
#define ClearCpkParm_CMD   0x39  //清空公钥
#define ProofIcParm_CMD    0x23   //二次论证I卡数据
#define BATTERY_CMD        0x45   //获取电池电量

#define IC_STATUS_CMD      0x13   //判断卡片知否在位
#define IC_SOPEN_CMD       0x14   //IC卡打开上电
#define IC_SCLOSE_CMD      0x15   //关闭IC卡
#define IC_SWRITE_CMD      0x16   //发送APUD
#define ICBARUSH_CMD       0x18   //手刷 蓝牙手刷
#define PASS_INPUT_CMD     0x19   //输入密码加密





#define  SWIPE_SUCESS  0x00    //正常交易
#define  SWIPE_DOWNGRADE  0xb0  //降级
#define SWIPE_ICCARD_INSETR  0xb1 //主界面插入IC卡
#define SWIPE_ICCARD_SWINSETR  0xb2 //交易功能中插入IC卡
#define SWIPE_WAIT_BRUSH  0xb3 //等待用户刷卡/插卡
#define SWIPE_CANCEL   0xe1  //等待用户刷卡/插卡
#define SWIPE_TIMEOUT_STOP 0xe2  //超时退出
#define SWIPE_IC_FAILD  0xe3 //IC卡处理失败
#define SWIPE_NOICPARM  0xe4 //无IC卡参数
#define SWIPE_STOP  0xe5 //交易终止
#define SWIPE_IC_REMOVE  0xe6 //IC卡移除
#define SWIPE_LOW_POWER  0x4c //电量低
#define BLUE_POWER_OFF  0x46 //关机
#define BLUE_DATA_WAITE  0x47 // 等待接收数据中,不允许重复发送
#define BLUE_DEVICE_ERROR  0x48 // 设备非法,不匹配当前SDK
#define BLUE_SCAN_NODEVICE -1 //无设备
#define BLUE_CONNECT_FAIL 0x00 //设备连接失败
#define BLUE_CONNECT_ING 0x02 //蓝牙正在连接
#define BLUE_CONNECT_SUCESS 0x01 //设备连接成功
#define BLUE_POWER_STATE_ON 0x06 // 启动蓝牙
#define BLUE_POWER_STATE_OFF 0x07 //关闭蓝牙



typedef struct
{
    
    __unsafe_unretained NSString *DevcieSn;  //设备SN号
    __unsafe_unretained NSString *AppVersion;  //设备应用版本
    __unsafe_unretained NSString *BootVersion; //设备底层固件版本
    __unsafe_unretained NSString *Model;  //设备类型
    
}DeviceInfoData;



typedef struct
{
    int iCardtype;				//刷卡卡类型 ==0 磁条卡 ==1 IC卡
    __unsafe_unretained NSString *TrackPAN;		//域2	主帐号
    __unsafe_unretained NSString *CardValid;				//域14	卡有效期
    __unsafe_unretained  NSString *szServiceCode;			//服务代码
    __unsafe_unretained  NSString *CardSeq;				//域23	卡片序列号
    __unsafe_unretained  NSString *szEntryMode;			//域22	服务点输入方式
    int      nTrack2Len;                    //2磁道数据大小
    __unsafe_unretained  NSString *szTrack2Data;				//域35	磁道2数据
    int      nEncryTrack2Len;                   //2磁道加密数据大小
    __unsafe_unretained  NSString *szEncryTrack2Data;			//域35	磁道2加密数据
    int      nTrack3Len;                    //3磁道数据大小
    __unsafe_unretained NSString *szTrack3Data;			//域36	磁道3数据
    int      nEncryTrack3Len;                    //3加密磁道数据大小
    __unsafe_unretained NSString *szEncryTrack3Data;			//域36	磁道3加密数据
    __unsafe_unretained  NSString *sPIN;                     //域52	个人标识数据(pind ata)
    int      IccdataLen;
    __unsafe_unretained NSString *Field55Iccdata;			//的55域信息
    double    szAmount;			//金额
    __unsafe_unretained  NSString *szAsciiPin;        //密码
    __unsafe_unretained  NSString *szAsciiSn;        //SN号
    __unsafe_unretained  NSString *szRadom;          //随机数
    BOOL   bDowngrade;         //是否降级
    
}FieldTrackData;




@protocol  JhlblueControllerDelegate;

@interface JhlblueController : NSObject

@property (assign) id<JhlblueControllerDelegate> delegate;

+ (id)sharedInstance;
- (void)LogIsEnable:(BOOL)isEnable;
-(NSString *)GetSDKVersion;
//初始化
- (Boolean)InitBlue;


//================蓝牙部分================
//蓝牙是否可用
- (BOOL)buleToothIsEnable;
//蓝牙是否已连接
- (BOOL)isBTConnected;
//蓝牙搜索,搜索时间按秒,搜索返回类型 0 是列表一起返回  1:收到一个返回一个
- (void)scanBTDevice:(long)nScanTimer nScanType:(int) nscantype;
//停止搜索
- (void)stopScanBT;
- (void)connectBT:(CBPeripheral *)dataPath connectTimeout:(int)connectTimeout;;
//断开蓝牙连接
- (void)disconnectBT;

//金融交易相关函数接口
-(int)GetSnVersion;
-(int)GetDeviceInfo;



/********************************************************************
 
	函 数 名：WriteMainKey
	功能描述：写入主密钥
	入口参数：
    NSString* 	MainDatakey		--主密钥数据16个字节 32位字符
	返回说明：成功/失败
 **********************************************************/

-(int)WriteMainKey:(NSString*)MainDatakey;
/********************************************************************
 
	函 数 名：WriteWorkKey
	功能描述：写入工作密钥
	入口参数：
     NSString* 	DataWorkkey  16字节PIN密钥+4个字节校验码 +16字节MAC +4个字节MAC校验码 +磁道加密密钥+磁道加密密钥校验码  ==60 个字节 120字符
 
	返回说明：成功/失败
 **********************************************************/
-(int)WriteWorkKey:(NSString*)DataWorkkey;



/********************************************************************
	函 数 名：InputPassword
	功能描述： 密码加密,返回消费需要上送数据22域+35+36+IC磁道数据+PINBLOCK+磁道加密随机数
 秒
 NSString 	bPassKey		-密码数据例如:12345
	返回说明：
 **********************************************************/
-(int)InputPassword:(NSString*)bPassKeys;

/********************************************************************
	函 数 名：MagnCard
	功能描述：蓝牙设备上输提 刷卡      无输入金额  无密码（例如信用卡预授权完成等交易）
	入口参数：
 long 	timeout 		--刷卡交易超时时间(毫秒)
 int    nMtype          --刷卡类型
 ==0x01  设备上输提示输入金额 刷卡  输入密码
 ==0x02 蓝牙设备上输提 示输入金额 刷卡  无密码
 ==0x03 蓝牙设备上输提 刷卡  + 输入密码   无输入金额（例如查询余额）
 ==0x04 蓝牙设备上输提 刷卡    无输入金额  无密码（例如信用卡预授权完成等交易）
 返回说明：
 **********************************************************/
-(int)MagnCard:(long)timeout :(long)lAmount :(int ) nMtype;



/*
 函 数 名：MagnCancel
 功能描述：取消当前刷卡
 入口参数：
 返回说明：成功/失败
 **********************************************************/
-(int)MagnCancel;

/*
 函 数 名：ReadBattery
 功能描述：获取电池电量
 入口参数：
 返回说明：成功/失败
 **********************************************************/
-(int)ReadBattery;

/*
 函 数 名：ProofIcData
 功能描述：交易后论证
 入口参数：
 NSString 	IcData	--交易后论证数据
 返回说明：成功/失败
 **********************************************************/
-(int)ProofIcData:(NSString*)IcData;


/********************************************************************
 
	函 数 名：GetMac
	功能描述：获取MAC
	入口参数：
 int		len		--数据长度 字节算大小
 int 	Datakey		--计算MAC数据
	返回说明：成功/失败
 **********************************************************/

-(int)GetMac:(int)len :(NSString*)MacDatakey;

/*
 函 数 名：WriteTernumber
 功能描述：写入终端号商户号
 入口参数：
 NSString 	DataTernumber	--终端号+商户号=23字节 ASCII
 返回说明：成功/失败
 **********************************************************/
-(int)WriteTernumber:(NSString*)DataTernumber;

/*
 函 数 名：ReadTernumber
 功能描述：读取终端号商户号
 返回说明：成功/失败 终端号+商户号=23字节 ASCII
 **********************************************************/
-(int)ReadTernumber;



/********************************************************************
 函 数 名：SetEncryMode
 功能描述：设置加密模式
 入口参数：
 int 	CardEncryMode 	加密模式
 
 //磁道加密算法，0表示银联标准的只加密后8字节，1/2表示不包含长度补0/F组成8的倍数据加密，3/4表示包含长度补0/F组成8的倍数据加密，5表示特殊加密）  6 通过主密钥加密磁道   7 三磁道为空的情况下,补全部FF
 //8 磁道随机数全部加密
 
 int  MacEncryMode 设置工作密钥MAC算法    ==00 DES加密 01 3DES加密
 int  MacType MAC算法    ==00 DES加密 01 3DES加密
 返回说明：
 **********************************************************/

-(BOOL)SetEncryMode:(int)TrackEncryMode   :(int) MacEncryMode :(int) MacType;



@end


@protocol JhlblueControllerDelegate<NSObject>
@optional

#pragma mark ===============功能交易部分的回调===============
//返回设备信息
- (void)onDeviceInfo:(DeviceInfoData)DeviceInfoList;
- (void)onTimeout; //超时
//功能操作结果
- (void)onResult:(int) Code:(int) nResult :(NSString *)MsgData;
- (void)swipCardState:(int ) nResult;  //刷卡提示
- (void)onReadCardData:(FieldTrackData) FildCardData;

#pragma mark ===============蓝牙部分的回调===============
//发现新的蓝牙
- (void)onFindNewPeripheral:(CBPeripheral *)newPeripheral;
//蓝牙已连接
- (void)onConnected:(CBPeripheral *)connectedPeripheral;
//蓝牙搜索超时
- (void)onScanTimeout;
//搜索到的蓝牙设备
- (void)onDeviceFound:(NSArray *)DeviceList;
//蓝牙状态
- (void)onBlueState:(int)nState;   //-1断开  1：连接成功  2:蓝牙已断开  3:蓝牙手动启动  4:蓝牙关闭
@end



