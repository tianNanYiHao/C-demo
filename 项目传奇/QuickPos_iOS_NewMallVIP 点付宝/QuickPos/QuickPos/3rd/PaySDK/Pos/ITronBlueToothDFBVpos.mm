//
//  ITronBlueToothDFBVpos.m
//  QuickPos
//
//  Created by Aotu on 16/6/16.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "ITronBlueToothDFBVpos.h"
#import "CSwiperStateChangedListener.h"
#import "vcom.h"
#import "CardInfoModel.h"
#import "ItronCommunicationManagerBase.h"
#import "PosManager.h"
#import "MBProgressHUD.h"

@interface ITronBlueToothDFBVpos()<CSwiperStateChangedListener,CommunicationCallBack,DeviceSearchListener>
{
    ItronCommunicationManagerBase *cmManager;
    NSInteger Hcount;

    NSString     *psam;           //psam卡号
    NSString     *head;           //head
    NSString     *ksn;            //ksn
    NSString     *trackEncode;    //获取磁道密文
    NSString     *cardNo;         //获取卡号
    NSString     *mac;            //获取mac
    NSString     *data55;         //获取55域数据
    NSString     *expiryData;     //获取卡有效期
    NSString     *indexNo;        //获取卡序列号
    NSString     *random;         //获取随机数
    NSString     *cardType;       //获取卡类型
    

}
@property (nonatomic, retain) NSMutableArray*arrBTDevice;
@property (nonatomic, strong)vcom *mVcom;
@end
@implementation ITronBlueToothDFBVpos
@synthesize mVcom;

char bout11[5096];
int  boutlen11;
char* HexToBin11(char* hin)
{
    int i;
    char highbyte,lowbyte;
    int len= (int)strlen(hin);
    for (i=0;i<len/2;i++)
    {
        if (hin[i*2]>='0'&&hin[i*2]<='9')
            highbyte=hin[i*2]-'0';
        if (hin[i*2]>='A'&&hin[i*2]<='F')
            highbyte=hin[i*2]-'A'+10;
        if (hin[i*2]>='a'&&hin[i*2]<='f')
            highbyte=hin[i*2]-'a'+10;
        
        if (hin[i*2+1]>='0'&&hin[i*2+1]<='9')
            lowbyte=hin[i*2+1]-'0';
        if (hin[i*2+1]>='A'&&hin[i*2+1]<='F')
            lowbyte=hin[i*2+1]-'A'+10;
        if (hin[i*2+1]>='a'&&hin[i*2+1]<='f')
            lowbyte=hin[i*2+1]-'a'+10;
        
        bout11[i]=(highbyte<<4)|(lowbyte);
    }
    boutlen11=len/2;
    return bout11;
}
char hout99[5096];
char* BinToHex99(char* bin,int off,int len)
{
    int i;
    //	hout=(char*)hout;
    for (i=0;i<len;i++)
    {
        sprintf((char*)hout99+i*2,"%02x",*(unsigned char*)((char*)bin+i+off));
    }
    hout99[len*2]=0;
    return hout99;
}

- (id)initWithDelegate:(NSObject<PosResponse> *)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        
        [self initIRonSDK];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBlue:) name:@"closeBluetooth" object:nil];
    }
    return self;
}

- (void)closeBlue:(NSNotification *)noti{
    
    NSLog(@"准备关闭蓝牙");
    
    [cmManager closeDevice];
    [[PosManager getInstance] ResetBlue];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"closeBluetooth" object:nil];
    
    
}
-(void)initIRonSDK{
    
    mVcom = [vcom getInstance];
    [mVcom setEventListener:self];
    [mVcom open];
    //    [mVcom setVloumn:85];
    [mVcom setDebug:YES];
    //    初始化爱刷刷卡头
    [mVcom setCommmunicatinMode:BLE_DianFB];
    
    //    //必须在主线程中执行初始化蓝牙方法。
    [self performSelectorOnMainThread:@selector(initBlueTooth) withObject:nil waitUntilDone:YES];
    
}

-(void)connect
{
    //    [mVcom StartRec];
    //    [self initBlueTooth];
}
-(void)startWithData:(NSDictionary *)data
{
    [self readcard:1 data:data];
}

-(void)stop
{
    [mVcom StopRec];
    NSLog(@"停止刷卡动作");
}
-(void)close
{
    [mVcom setEventListener:nil];
    [mVcom close];
    mVcom = nil;
    NSLog(@"关闭音频收发功能");
}

- (void)initBlueTooth{
    if (!cmManager) {
        cmManager = [ItronCommunicationManagerBase getInstance];
        //    NSLog(@"Ver_SDK= %@", [cmManager GetSDKVerson]);
        cmManager.communication = self;
        [cmManager setDebug:1];
        
    }
    
    if (!self.arrBTDevice) {
        self.arrBTDevice = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [self.arrBTDevice removeAllObjects];
    [cmManager searchDevices:self timeout:15*1000];
}

- (void)discoverBLeDevice:(NSDictionary *)uuidAndName {
    
    NSLog(@"device is %@ deviceKind %@", uuidAndName,[uuidAndName class]);
    
    NSString *bdm = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
    NSString *uuidMainKeyStr = [uuidAndName objectForKey:@"mainKey"];
    NSString *uuidGetBDM = [uuidAndName objectForKey:uuidMainKeyStr];
    bdm = @"AC00097429";
    
    
    NSLog(@"***** bdm ******* %@",bdm);
    
    if ([bdm isEqualToString:uuidGetBDM]) {
        [self.arrBTDevice addObject:uuidAndName];
        
        int ret = [cmManager openDevice:uuidMainKeyStr cbDelegate:self timeout:15*1000];
        
        if (ret == 0) {
            NSLog(@"蓝牙连接成功");
            NSLog(@"%d", [cmManager isConnected]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startswipe" object:nil];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeHUD" object:nil];
            NSLog(@"蓝牙连接失败");
        }
        
    }else{
        
        [self.arrBTDevice removeAllObjects];
        
    }
    NSLog(@"_arrBTDevice %d ,,,, %@",_arrBTDevice.count,_arrBTDevice);
    
    
    if ([self.arrBTDevice count] == 0) {
        return;
    }
    [cmManager stopSearching];
}

- (void)discoverOneDevice:(CBPeripheral *)peripheral{
    
    //    int flag = [cmManager openDevice:peripheral cb:self timeout:10*1000];
    //    if(flag == 0 && [self.arrBTDevice count]==0){
    //        [self.arrBTDevice addObject:peripheral];
    //
    //        if ([super.delegate respondsToSelector:@selector(onDeviceKind:)]) {
    //            [super.delegate onDeviceKind:0];
    //        }
    ////        NSLog(@"匹配成功");
    //    }
    
}

- (void)discoverComplete{
    
    if ([self.arrBTDevice count]==0) {
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有发现蓝牙设备,请退出重试。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        //        [alert show];
        if ([super.delegate respondsToSelector:@selector(onDeviceKind:)]) {
            [super.delegate onDeviceKind:-1];
            NSLog(@"蓝牙未搜索到,发消息提示框");
        }
    }else{
        //成功的通知 (不发了)
        //         [[NSNotificationCenter defaultCenter] postNotificationName:@"closeHUD" object:nil userInfo:[NSDictionary dictionaryWithObject:@"蓝牙搜索结束" forKey:@"pipiOver"]];
        NSLog(@"arrBTDevice ==*** %d",_arrBTDevice.count);
    }
    NSLog(@"蓝牙搜索结束");
    
}
- (void)closeOk{
    [cmManager isConnected];
    [mVcom setCommmunicatinMode:0];
    
    NSLog(@"关闭了蓝牙");
}

- (void)onError:(NSInteger)code msg:(NSString *)msg{
    NSLog(@"err :%ld, %@", (long)code, msg);
}
#pragma  mark - 刷卡方法

//解析卡号、磁道信息等数据出错时，回调此接口
-(void)onDecodeDrror:(int)decodeResult{
    
}

//收到数据
//-(void) dataArrive:(vcom_Result*) vs  Status:(int)_status;
//mic插入
-(void) onMicInOut:(int) inout{
    
}

//通知监听器刷卡器插入手机
-(void) onDevicePlugged{
    NSLog(@"刷卡器插入手机");
}

//通知监听器刷卡器已从手机拔出
-(void) onDeviceUnPlugged{
    NSLog(@"刷卡器已从手机拔出");
}

//通知监听器控制器CSwiperController正在搜索刷卡器
-(void) onWaitingForDevice{
    NSLog(@"正在搜索刷卡器");
}

//通知监听器没有刷卡器硬件设备
-(void)onNoDeviceDetected{
    NSLog(@"没有刷卡器硬件设备");
}

//通知监听器可以进行刷卡动作
-(void)onWaitingForCardSwipe{
    NSLog(@"等待刷卡===");
}

// 通知监听器检测到刷卡动作
-(void)onCardSwipeDetected{
    NSLog(@"检测到刷卡动作");
}

//通知监听器开始解析或读取卡号、磁道等相关信息
-(void)onDecodingStart{
    NSLog(@"开始解析或读取卡号、磁道等相关信息");
}

#define VCOM_ERROR 1 //提供errorMsg，描述错误原因
#define VCOM_ERROR_FAIL_TO_START  2//CSwiperController创建失败
#define VCOM_ERROR_FAIL_TO_GET_KSN   3//取ksn失败
-(void)onError:(int)errorCode andMsg:(NSString*)errorMsg{
    NSLog(@"出错:%@,%i", errorMsg, errorCode);
}

//通知监听器控制器CSwiperController的操作被中断
-(void)onInterrupted{
    NSLog(@"刷卡器操作被中断");
}

//通知监听器控制器CSwiperController的操作超时
//(超出预定的操作时间，30秒)
-(void)onTimeout{
    NSLog(@"刷卡器连接超时");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeHUD" object:nil userInfo:[NSDictionary dictionaryWithObject:@"超时" forKey:@"pipiTimeOut"]];
    [self sendDeviceType:-1];
}

//通知监听器解码刷卡器输出数据完毕。
/*
 formatID　　　　　此参数保留
 ksn               刷卡器设备编码
 encTracks         加密的磁道资料。1，2，3的十六进制字符
 track1Length       磁道1的长度（没有加密数据为0）
 track2Length       磁道2的长度（没有加密数据为0）
 track3Length       磁道3的长度（没有加密数据为0）
 randomNumber     加密时产生的随机数
 maskedPAN        基本账号号码。卡号的一种格式“ddddddddXXXXXXXXdddd”(隐藏卡号
 的中间的几位数字)d 数字   X 隐藏字符
 expiryDate         到期日，格式ＹＹＭＭ
 cardHolderName　　持卡人姓名
 */
-(void)onDecodeCompleted:(NSString*) formatID
                  andKsn:(NSString*) ksn
            andencTracks:(NSString*) encTracks
         andTrack1Length:(int) track1Length
         andTrack2Length:(int) track2Length
         andTrack3Length:(int) track3Length
         andRandomNumber:(NSString*) randomNumber
            andMaskedPAN:(NSString*) maskedPAN
           andExpiryDate:(NSString*) expiryDate
       andCardHolderName:(NSString*) cardHolderName {
    
    
}

//开始刷卡
- (BOOL) readcard: (NSInteger) cmd data:(NSDictionary *)data {
    
    [mVcom StopRec];
    NSLog(@"*************************************************************************************************");
    
    //    F2F蓝牙
    
//    NSString *orderId = [data objectForKey:@"orderId"];
//    NSLog(@"%@",orderId);
//    NSString *transLogNo = [data objectForKey:@"transLogNo"];
//    NSString *cash = [data objectForKey:@"cash"];
//
//    if (! cash || [@"" isEqualToString:cash]) {
//        cash = @"0";
//    }
    
    
    
//    
//    NSMutableArray* result = [NSMutableArray array];
//    for (int i=0; i<[orderId length]; i++) {
//        int asciiCode = [orderId characterAtIndex:i] - '0' + 30;
//        [result addObject:[NSString stringWithFormat:@"%d", asciiCode]];
//    }
//    NSString *asciiOrderId = [result componentsJoinedByString:@""];
//    char append[16]= {0};
//    char* st = HexToBin((char *)[asciiOrderId UTF8String]);
//    memcpy(append,st,16);
//    
//    // 随机数
//    char *numRadom = HexToBin((char *)[transLogNo UTF8String]);
//    int numRadomLen = (int)[transLogNo length] / 2;
//    char randomdata[3]={0};
//    memcpy(randomdata, numRadom, numRadomLen);
//    
//    int cashLen = (int)[cash length];
//    char cData[100];
//    cData[0] = 0;
//    strcpy(cData,((char*)[cash UTF8String]));
//    
//    
//    Transactioninfo *tranInfo = [[Transactioninfo alloc] init];
//    NSString *ctrm = @"83030000";
//    char *temp2 = HexToBin((char*)[ctrm UTF8String]);
//    char ctr[4];
//    memcpy(ctr, temp2, [ctrm length]/2);
//    
//    [cmManager stat_EmvSwiper:1 PINKeyIndex:1 DESKeyInex:1 MACKeyIndex:1 CtrlMode:ctr ParameterRandom:randomdata ParameterRandomLen:numRadomLen cash:cData cashLen:cashLen appendData:append appendDataLen:16 time:30 Transactioninfo:tranInfo];
//    
//    //开始启动接收刷卡器数据
//    [mVcom StartRec];
    
    
    char * yy = "989898";
    NSString *str = @"31323334";
    char *temp = HexToBin11((char *)[str UTF8String]);
    //            NSString *ksn = [NSString stringWithFormat:@"%s",temp];
    char rom[100];
    memcpy(rom, temp, [str length]/2);//一定要拷贝否则会占用通一块内存
    NSLog(@"%s", rom);
    NSString *appendData = @"123";
    char *temp1 = HexToBin11((char*)[appendData UTF8String]);
    char appendDataChar[1024];
    memcpy(appendDataChar, temp1, [appendData length]/2);//一定要拷贝否则会占用通一块内存
    int appendlen =(int)[appendData length]/2;
    NSString *cash = @"00";
    int cashLen = (int)[cash length];
    char cData[100];
    cData[0] = 0;
    strcpy(cData,((char*)[cash UTF8String]));
    Transactioninfo *tranInfo = [[Transactioninfo alloc] init];
    NSString *ctrm = @"88FB0400";
    ctrm = @"007B0E01";
    char *temp2 = HexToBin11((char*)[ctrm UTF8String]);
    char ctr[4];
    memcpy(ctr, temp2, [ctrm length]/2);
    [cmManager setCustomer:36];
    [cmManager setDeviceKind:0];
    [cmManager stat_EmvSwiper:0x21 PINKeyIndex:1 DESKeyInex:1 MACKeyIndex:1 CtrlMode:ctr ParameterRandom:"123" ParameterRandomLen:0 cash:cData cashLen:cashLen appendData:"" appendDataLen:0 time:30 Transactioninfo:tranInfo];
    
    
    
    NSLog(@"##############################################################################################");
    NSLog(@"---------请刷卡---------");
    return YES;
}
// 设备检查
- (BOOL) checkDevice {
    if ( ! [mVcom hasHeadset] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未检测到刷卡器" message:@"请将手机刷卡器插入耳机孔，或点击“现在购买”" delegate:self cancelButtonTitle:@"现在购买" otherButtonTitles:@"关闭",nil];
        alert.tag = 2000;
        [alert show];
        return NO;
    }
    
    if (![self checkDeviceType])
        return NO;
    
    return YES;
}

- (BOOL)checkDeviceType{
    
    NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DeviceTypeLimit" ofType:@"plist"]];
    
    if (info == nil) {
        return YES;
    }
    
    return NO;
}
//收到数据
-(void) dataArrive:(char*)data dataLen:(int) len {
    NSLog(@"加载了,回来了");
    NSString* info = [mVcom HexValue:data Len:len];
    info = [@"FD" stringByAppendingString:info];
    
    NSLog(@"数据内容---> %@",info);
    
    //   [super.delegate posResponseDataWithCardInfoModel:info];
}

#pragma mark - CSwiperStateChangedListener 必须实现协议方法

//设备类型回调
- (void)onDeviceKind:(int) result{
    
    if ([super.delegate respondsToSelector:@selector(onDeviceKind:)]) {
        [super.delegate onDeviceKind:result];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeHUD" object:nil userInfo:[NSDictionary dictionaryWithObject:@"未搜索到匹配的蓝牙" forKey:@"pipiOverpipiNo"]];
        NSLog(@"%d!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",result);
    }
}
//通知电话中断结束设备准备好了
-(void)onDeviceReady
{
    
}
//插入ic卡
-(void)onICcardInput{
    
}
// @2014.8.8修改，把版本也传过去
- (void)onGetKsnAndVersionCompleted:(NSArray *)ksnAndVerson{
    NSLog(@"ksn & verson \n%@",ksnAndVerson);
}
-(void)onGetKsnCompleted:(NSString *)ksn {
    
}
//通知监听器可以进行艾刷刷卡动作
-(void)onWaitingForCardSwipeForAiShua {
    
}
- (void)onError:(int)errorCode ErrorMessage:(NSString *)errorMessage {
}
//解析艾刷返回的数据信息
-(void)secondReturnDataFromAiShua {
    
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
-(void)onDecodeCompleted:(NSString*) formatID
                  andKsn:(NSString*) ksn
            andencTracks:(NSString*) encTracks
         andTrack1Length:(int) track1Length
         andTrack2Length:(int) track2Length
         andTrack3Length:(int) track3Length
         andRandomNumber:(NSString*) randomNumber
           andCardNumber:(NSString *)maskedPAN
                  andPAN:(NSString*) PAN
           andExpiryDate:(NSString*) expiryDate
       andCardHolderName:(NSString*) cardHolderName
                  andMac:(NSString *)mac
        andQTPlayReadBuf:(NSString*) readBuf
                cardType:(int)type
              cardserial:(NSString *)serialNum
             emvDataInfo:(NSString *)data55
                 cvmData:(NSString *)cvm {
    
    
    
    NSString* string =[[NSString alloc] initWithFormat:@"ksn:%@\n encTracks:%@ \n track1Length:%i \n track2Length:%i \n track3Length:%i \n randomNumber:%@ \n cardNum:%@ \n PAN:%@ \n expiryDate:%@ \n cardHolderName:%@ \n mac:%@ \n cardType:%d \n cardSerial:%@ \n emvDataInfo:%@ \n cmv:%@  \n readBuf:%@",ksn,encTracks,track1Length,track2Length,track3Length,randomNumber, maskedPAN,PAN,expiryDate,cardHolderName,mac,type,serialNum,data55,cvm,readBuf];
    NSLog(@"%@",string);
    
    NSString *cardInfo = nil;
    CardInfoModel *CardInfo = nil;
    if (encTracks && encTracks.length > 0) {
        NSString *strTrack1Length = [self intToHexString:track1Length lenght:2];
        NSString *strTrack2Length = [self intToHexString:track2Length lenght:2];
        NSString *strTrack3Length = [self intToHexString:track3Length lenght:2];
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
        
        //        if ([expiryDate length] == 0) {
        //            expiryDate = @"30303030";
        //        }
        
        //        if ([serialNum length] == 0) {
        //            serialNum = nil;
        //        }
        
        if (serialNum.length == 2) {
            serialNum = [@"0" stringByAppendingString:serialNum];
            serialNum = [mVcom HexValue:(char*)[serialNum cStringUsingEncoding:NSASCIIStringEncoding] Len:[serialNum length]];
        } else if (serialNum.length == 0 && data55.length > 0) {
            serialNum = @"303030";
        }
        //
        
        
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
        
    }
    [super.delegate posResponseDataWithCardInfoModel:CardInfo];
    
}
//参数下载回调
- (void)onLoadParam:(NSString *)param{
    
}

- (void)sendDeviceType:(int)deviceType{
    if ([super.delegate respondsToSelector:@selector(onDeviceKind:)]) {
        [super.delegate onDeviceKind:deviceType];
    }
}

- (BOOL) deviceFindWith:(vcom_Result*)vs{
#define DEVICE_TYPE_POS (SUBCMD_POS  + 3 + 8 + 3)
    BOOL isFind = NO;
    char *data = vs->readbuf;
    
    int deviceType = -1;
    
    if(( data[CMD_POS] & 0xFF )==0x02 ) {
        if( (data[SUBCMD_POS] & 0xFF) == 0x00 ) {
            deviceType = DEVICE_TYPE_MINI;
            isFind = YES;
        } else if((data[SUBCMD_POS] & 0xFF) == 0x80 ) {
            
            if((data[DEVICE_TYPE_POS] & 0xFF) == 0x11 ) {
                
                deviceType = DEVICE_TYPE_BOARD;
                isFind = YES;
            }else if ((data[DEVICE_TYPE_POS] & 0xFF) == 0x17 || (data[DEVICE_TYPE_POS] & 0xFF) == 0x41 ) {
                
                deviceType = DEVICE_TYPE_PRINTER;
                isFind = YES;
            }
        }
    }
    if (isFind) {
        [self sendDeviceType:deviceType];
    }
    return isFind;
}

//收到数据
#pragma mark Communication method
//刷卡信息返回
- (void)dataArrive:(vcom_Result *)vs Status:(int)_status
{
    
    if(_status==-3){
        //设备没有响应
        NSLog(@"通信超时");
        [self performSelectorOnMainThread:@selector(updateData:) withObject:@"通信超时" waitUntilDone:YES];
        
        return;
    }else if(_status == -2){
        //耳机没有插入
        return;
    }else if(_status==-1){
        //接收数据的格式错误
    }
    else if(_status == -4 )
    {
        NSLog(@"数据内容有错误！-4");
    }
    else{
        //操作指令正确
        if(vs->res==0){
            //更新工作秘钥成功
            if (vs->rescode[0] == 0x02 &&vs->rescode[1] == 0x10) {
                [self performSelectorOnMainThread:@selector(updateData:) withObject:@"更新工作秘钥成功！" waitUntilDone:NO];
            }
            else if(vs->rescode[0] == 0x09 && vs->rescode[1] == 0x07)
            {
                
                NSString *str = [NSString stringWithFormat:@"成功--第%ld次",(long)Hcount];
                [self performSelectorOnMainThread:@selector(updateData:) withObject:str waitUntilDone:NO];
                
                if (Hcount < 200) {
                    
                    NSLog(@"发送了第 %ld 次",(long)++Hcount);
                    
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:[NSString stringWithFormat:@"发送了第 %ld 次",(long)Hcount] waitUntilDone:NO];
                    
                    [cmManager performSelectorInBackground:@selector(Request_Exit) withObject:nil];
                    
                }
                
                NSLog(@"停止命令执行成功");
                return;
            }
            else if (vs->rescode[0] == 0x09 && vs->rescode[1] == 0x26)
            {
                //                NSLog(@"更新主秘钥完成！");
            }
            else if (vs->rescode[0] == 0x02 && vs->rescode[1] == 0xa0) {
                NSLog(@"刷卡命令完成！" );
            }
            //设备有成功返回指令
            NSString *succStr = @"";
            NSMutableString *strTemp = [[NSMutableString alloc] initWithCapacity:0];
           
            //刷卡连续操作
            if(vs->pinEncryptionLen > 0)
            {
                [strTemp appendString:[NSString stringWithFormat:@"\n pinEncryption：%@", [self HexValue:vs->pinEncryption Len:vs->pinEncryptionLen]]];
                
            }
            ////磁道
            if (vs->trackPlaintextLen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n trackPlaintext:%@",[self HexValue:vs->trackPlaintext Len:vs->trackPlaintextLen]]];
            }
            if (vs->trackEncryptionLen>0) {   //获取磁道密文
                [strTemp appendString:[NSString stringWithFormat:@"\n trackEncryption:%@",[self HexValue:vs->trackEncryption Len:vs->trackEncryptionLen]]];
                
                
            }
            if (vs->cardPlaintextLen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n cardPlaintext:%s", vs->cardPlaintext]];
                
            }
            if (vs->cardEncryptionLen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n cardEncryption:%@", [self HexValue:vs->cardEncryption Len:vs->cardEncryptionLen]]];
                
            }
            if (vs->panLen>0) {
                //                NSLog(@"%d", vs->panLen);
                [strTemp appendString:[NSString stringWithFormat:@"\n pan码:%@",[self HexValue:vs->pan Len:vs->panLen] ]];
            }
            if (vs->carddate>0) {    //这个是我补的 非demo
                [strTemp appendString:[NSString stringWithFormat:@"\n pan码:%@",[self HexValue:vs->carddate Len:vs->carddateLen] ]];

            }
            if (vs->traderNoInPsamLen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n shnoInPsam:%@",[self HexValue:vs->traderNoInPsam Len:vs->traderNoInPsamLen] ]];
                
            }
            if (vs->termialNoInPsamLen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n zdnoInPsam:%@",[self HexValue:vs->termialNoInPsam Len:vs->termialNoInPsamLen] ]];
                
            }
            if (vs->userInputLen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n userInput:%@",[self HexValue:vs->userInput Len:vs->userInputLen] ]];
            }
            if (vs->cdnolen>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n cdno:%s",vs->cdno]];
                NSString *str1=[NSString stringWithCString:vs->cdno  encoding:NSUTF8StringEncoding];
                NSLog(@"str1 is %@", str1);
                
            }
            if (vs->orderLen > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n ordersData:%@", [self HexValue:vs->Return_orders Len:vs->orderLen]]];
            }
            if (vs->track2Len > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n Track2:%@",[self HexValue:vs->Track2 Len:vs->track2Len] ]];
            }
            if (vs->track3Len > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n Track3:%@",[self HexValue:vs->Track3 Len:vs->track3Len] ]];
            }
            if (vs->cvmLen > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n cvm:%@",[self HexValue:vs->cvmData Len:vs->cvmLen] ]];
            }
            if (vs->deviceLen > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n deviceKind:%@",[self HexValue:vs->deviceKind Len:vs->deviceLen] ]];
                
            }
            if (vs->cardTypeLen > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n cardType:%@",[self HexValue:vs->cardType Len:vs->cardTypeLen] ]];
            }
            if (vs->data55Len>0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n data55:%@",[self HexValue:vs->data55 Len:vs->data55Len] ]];
                NSString * st55 = [NSString stringWithFormat:@"\n data55:%@",[self HexValue:vs->data55 Len:vs->data55Len] ];
                [self check5f24:st55];
                //                NSLog(@"得到的55域：%@",st55);
                //                NSRange rg = [st55 rangeOfString:@"5f2403"];
                //                if (rg.location != NSNotFound) {
                //                    NSString *str1 = [st55 substringWithRange:NSMakeRange(rg.location, 6)];
                //                    st55 = [st55 stringByReplacingOccurrencesOfString:str1 withString:@""];
                //                    //修改len+value
                //                    str1 = [str1 stringByReplacingOccurrencesOfString:@"03" withString:@"02"];
                //                    str1 = [str1 substringToIndex:5];
                //                    st55 = [NSString stringWithFormat:@"%@%@",st55,str1];
                //                }
                //                NSLog(@"处理后的55域：%@",st55);
                
                
            }
            if (vs->ICReturnDataLen > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n ICReturnData:%@",[self HexValue:vs->ICReturnData Len:vs->ICReturnDataLen] ]];
                
            }
            if (vs->psamno > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n ICReturnData:%@",[self HexValue:vs->psamno Len:vs->psamnoLen] ]];
                //获取psam卡号
                NSString *psam = [mVcom HexValue:vs->psamno  Len:vs->psamnoLen];
                
            }
            if (vs->hardSerialNoLen > 0) {   //获取设备号
                [strTemp appendString:[NSString stringWithFormat:@"\n ICReturnData:%@",[self HexValue:vs->hardSerialNo Len:vs->hardSerialNoLen] ]];
                
            }
            if (vs->loadLen > 0) {
                [strTemp appendString:[NSString stringWithFormat:@"\n loadData:%@",[self HexValue:vs->loadData Len:vs->loadLen] ]];
                
            }
            if (vs->xulieDataLen)
            {
                [strTemp appendString:[NSString stringWithFormat:@"\n xulieData:%@",[self HexValue:vs->xulieData Len:vs->xulieDataLen] ]];
                
            }
            if (![strTemp isEqualToString:@""]) {
                [self performSelectorOnMainThread:@selector(updateData:) withObject:strTemp waitUntilDone:NO];
            }
            
            
        }
        else
        {
            NSLog(@"cmd exec error:%d\n",vs->res);
            switch (vs->res) {
                case 1:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"通信超时" waitUntilDone:NO];
                    break;
                case 2:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"PSAM卡认证失败" waitUntilDone:NO];
                    break;
                case 3:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"Psam卡上电失败或者不存在" waitUntilDone:NO];
                    break;
                case 4:
                    [self performSelectorOnMainThread:@selector(refreshStatusNotSupportCmdFormPosToPhone1) withObject:nil waitUntilDone:NO];
                    break;
                case 10:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"用户退出" waitUntilDone:NO];
                    break;
                case 11:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"MAC校验失败" waitUntilDone:NO];
                    break;
                case 12:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"终端加密失败" waitUntilDone:NO];
                    break;
                case 14:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"用户按了取消健" waitUntilDone:NO];
                    break;
                case 15:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"Psam卡状态异常" waitUntilDone:NO];
                    break;
                case 0x20:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"不匹配的主命令码" waitUntilDone:NO];
                    break;
                case 0x21:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"不匹配的子命令码" waitUntilDone:NO];
                    break;
                case 0x50:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"获取电池电量失败" waitUntilDone:NO];
                    break;
                case 0x80:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"数据接收正确" waitUntilDone:NO];
                    break;
                case 0x86:
                    NSLog(@"ic卡操作失败");
                    break;
                case 0x40:
                    [self performSelectorOnMainThread:@selector(refreshStatusNoPaperInPrinterToPhone1) withObject:nil waitUntilDone:NO];
                    break;
                case 0xe0:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"重传数据无效" waitUntilDone:NO];
                    break;
                case 0xe1:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"终端设置待机信息失败" waitUntilDone:NO];
                    break;
                case 0xf0:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"不识别的包头" waitUntilDone:NO];
                    break;
                case 0xf1:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"不识别的主命令码" waitUntilDone:NO];
                    break;
                    
                case 0xf2:
                    [self performSelectorOnMainThread:@selector(refreshStatusNotVerifySubCmdToPhone1) withObject:nil waitUntilDone:NO];
                    break;
                case 0xf3:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"该版本不支持此指令" waitUntilDone:NO];
                    break;
                    
                case 0xf4:
                    [self performSelectorOnMainThread:@selector(refreshStatusRandomLengthErrToPhone1) withObject:nil waitUntilDone:NO];
                    break;
                case 0xf5:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"不支持的部件" waitUntilDone:NO];
                    break;
                case 0xf6:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"不支持的模式" waitUntilDone:NO];
                    break;
                case 0xf7:
                    [self performSelectorOnMainThread:@selector(refreshStatusDataLengthErrToPhone1) withObject:nil waitUntilDone:NO];
                    break;
                    
                case 0xfc:
                    [self performSelectorOnMainThread:@selector(refreshStatusDataConentErrToPhone1) withObject:nil waitUntilDone:NO];
                    break;
                case 0xfd:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"终端ID错误" waitUntilDone:NO];
                    break;
                case 0xfe:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"MAC_TK校验失败" waitUntilDone:NO];
                    break;
                case 0xff:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:@"校验和错误" waitUntilDone:NO];
                    break;
                default:
                    [self performSelectorOnMainThread:@selector(updateData:) withObject:nil waitUntilDone:NO];
                    break;
            }
            /* 失败和中间状态代码
             01
             命令执行超时
             02
             PSAM卡认证失败
             03
             Psam卡上电失败或者不存在
             04
             Psam卡操作失败
             0A
             用户退出
             0B
             MAC校验失败
             0C
             终端加密失败
             0E
             用户按了取消健
             0F
             Psam卡状态异常
             20
             不匹配的主命令码
             21
             不匹配的子命令码
             50
             获取电池电量失败
             80
             数据接收正确
             E0
             重传数据无效
             E1
             终端设置待机信息失败
             F0
             不识别的包头
             F1
             不识别的主命令码
             F2
             不识别的子命令码
             F3
             该版本不支持此指令
             F4
             随机数长度错误
             F5
             不支持的部件
             F6
             不支持的模式
             F7
             数据域长度错误
             FC
             数据域内容有误
             FD
             终端ID错误
             FE
             MAC_TK校验失败
             FF
             校验和错误
             // 打印错误
             PROTOCOL_ERR_PRT_NOPAPER     == 0X40   ;打印机缺纸
             PROTOCOL_ERR_PRT_OFF         == 0X41   ;打印机离线
             PROTOCOL_ERR_PRT_NO          == 0X42   ;没有打印机
             PROTOCOL_ERR_PRT_NOBM        == 0X43  ;没有黑标
             PROTOCOL_ERR_PRT_CLOSE       == 0X44  ;打印机关闭
             PROTOCOL_ERR_PRT_OTHER       == 0X45  ;打印机故障
             */
        }
    }
}
//-(void) dataArrive:(vcom_Result*) vs  Status:(int)_status {
//    NSLog(@"收到数据,%d",_status);
//    if (_status == -3) {
//        //超时
//    }else if (_status == -2){
//        
//    }else if (_status == -1){
//        
//    }else if (_status == 0){
//        if (![self deviceFindWith:vs]) {
//            //获取psam卡号
//            NSString *psam = [mVcom HexValue:vs->psamno  Len:vs->psamnoLen];
//            //获取设备号
//            NSString *head = [mVcom HexValue:vs->hardSerialNo Len:vs->hardSerialNoLen];
//            //获取ksn
//            NSString *psamLength = [self intToHexString:(int)[psam length]/2 lenght:2];
//            NSString *headLength = [self intToHexString:(int)[head length]/2 lenght:2];
//            NSString *ksn = [NSString stringWithFormat:@"%@%@%@%@", psamLength, psam , headLength, head];
//            //获取磁道明文
//            //        NSString *trackPlain = [mVcom HexValue:vs->trackPlaintext Len:vs->trackPlaintextLen];
//            //获取磁道密文
//            NSString *trackEncode = [mVcom HexValue:vs->trackEncryption Len:vs->trackEncryptionLen];
//            NSString *cardNo = [mVcom HexValue:vs->cardPlaintext Len:vs->cardPlaintextLen];
//            //获取mac
//            NSString *mac = [mVcom HexValue:vs->mac Len:vs->maclen];
//            
//            //                    NSString *pan = [mVcom HexValue:vs->pan Len:vs->panLen];
//            //                        NSRange range = [pan rangeOfString:@"f" options:NSBackwardsSearch];
//            //                        pan = [pan substringFromIndex:range.location+1];
//            //获取PIN
//            NSString *pin = [mVcom HexValue:vs->pinEncryption Len:vs->pinEncryptionLen];
//            NSString *pinLenght = [self intToHexString:(int)[pin length]/2 lenght:2];
//            pin = [pinLenght stringByAppendingString:pin];
//            //获取55域数据
//            NSString *data55 = [mVcom HexValue:vs->data55 Len:vs->data55Len];
//            //获取卡有效期
//            NSString *expiryData = [mVcom HexValue:vs->carddate Len:vs->carddateLen];
//            //猎取卡序列号
//            NSString *indexNo = [mVcom HexValue:vs->xulieData Len:vs->xulieDataLen];
//            //随机数
//            NSString *random = [mVcom HexValue:vs->rand Len:vs->randlen];
//            //卡类型:（0表示纯磁条卡，1 IC卡，2表示双介质卡，）
//            NSString *cardType = [mVcom HexValue:vs->cardType Len:vs->cardTypeLen];
//            
//            [self onDecodeCompleted:nil andKsn:ksn andencTracks:trackEncode andTrack1Length:0 andTrack2Length:vs->track2Len andTrack3Length:vs->track3Len andRandomNumber:random andCardNumber:cardNo andPAN:pin andExpiryDate:expiryData andCardHolderName:nil andMac:mac andQTPlayReadBuf:nil cardType:(int)[cardType integerValue] cardserial:indexNo emvDataInfo:data55 cvmData:nil];
//        }
//    }
//}


- (NSString *)check5f24:(NSString *)st55
{
    //    NSLog(@"得到的55域：%@",st55);
    st55 = [st55 lowercaseString];
    NSRange rg = [st55 rangeOfString:@"5f2403"];
    if (rg.location != NSNotFound) {
        st55 = [st55 stringByReplacingOccurrencesOfString:@"5f2403" withString:@"5f2402"];
        st55 = [st55 stringByReplacingCharactersInRange:NSMakeRange(rg.location+10, 2) withString:@""];
    }
    //    NSLog(@"处理后的55域：%@",st55);
    return [st55 uppercaseString];
}
- (NSString*)HexValue:(char*)bin Len:(int)binlen{
    char *hs;
    hs = BinToHex99(bin,0,binlen);//, <#int off#>, <#int len#>)
    hs[binlen*2]=0;
    NSString* str =[[NSString alloc] initWithFormat:@"%s",hs];
    //NSLog(@"str=%@,len=%d,buf=%c",str,buflen,buf[0]);
    return str;
}
- (void)updateData:(NSString *)str
{
    //上送数据
    NSLog(@"上送数据");
}
//IC卡回写脚本执行返回结果
- (void)onICResponse:(int)result resScript:(NSString *)resuiltScript data:(NSString *)data {
    
}


//检测到IC卡插入回调,通知客户端正在进行ic卡操作,用户禁止拔卡
- (void)EmvOperationWaitiing {
    
}
@end
