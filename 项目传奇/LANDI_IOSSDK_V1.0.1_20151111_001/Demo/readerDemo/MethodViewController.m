//
//  MethodViewController.m
//  readerDemo
//
//  Created by lvv on 14-3-16.
//  Copyright (c) 2014年 landi. All rights reserved.
//

#import "MethodViewController.h"
#import "LDCommon.h"

#define ERRLOG NSLog(@"错误：%@ %@",errCode,errInfo);\
dispatch_async(dispatch_get_main_queue(), ^{   \
    if ([self.textView.text length] > 2000) {\
        self.textView.text = [NSString stringWithFormat:@"[%@] ---- %@",errCode,errInfo];   \
    }  \
    else{  \
        self.textView.text =[NSString stringWithFormat:@"%@\n[%@] ---- %@\n---------------------",self.textView.text,errCode,errInfo]; \
    }\
})

#define PRINTLOG(a) NSLog(a); \
dispatch_async(dispatch_get_main_queue(), ^{  \
    if ([self.textView.text length] > 2000) { \
        self.textView.text = a; \
    } \
    else{ \
        self.textView.text =[NSString stringWithFormat:@"%@\n%@",self.textView.text,a]; \
    } \
});

@interface MethodViewController () {
    
    NSArray *dataSource;
}

@end

@implementation MethodViewController

@synthesize  deviceIndentifier;
@synthesize readerManager = mposController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         dataSource = [NSArray arrayWithObjects:
                       @"关闭设备",
                       @"当前连接状态",
                       @"获取Lib版本号",
                       @"获取设备信息",
                       @"=================",
                       @"请出示卡片",
                       @"M15的请出示卡片",
                       @"取消当前操作",
                       @"读取卡号",
                       @"获取磁道数据",
                       @"获取密码",
                       @"M15加密PIN",
                       @"EMV开始交易",
                       @"EMV继续交易",
                       @"联机数据处理",
                       @"EMV结束",
                       @"=================",
                       @"手写签名",
                       @"QRCODE",
                       @"获取设备日期和时间",
                       @"导入主密钥",
                       @"导入Track密钥",
                       @"导入MAC密钥",
                       @"导入PIN密钥",
                       @"显示文字",
                       @"查询主密钥",
                       @"设置AID",
                       @"设置公钥",
                       @"清除AID",
                       @"删除公钥",
                       @"计算MAC",
                       @"进入固件更新模式",
                       @"更新固件",
                       @"打印机状态",
                       @"打印数据",
                       @"=================",
                       @"QPBOC START",
                       @"QPOC GET NUMS",
                       @"QPOBC DEL",
                       @"QPBOC CLEARS",
                       @"QPBOC RECORD",
                       @"=================",
                       @"给卡片上电",
                       @"给卡片下电",
                       @"发送APDU",
                       @"=================",
                       @"M1 Info",
                       @"M1 Auth",
                       @"Wirte Block",
                       @"Read Block",
                       @"=================",
                       @"打印数据",
                       @"BMP dot",
                       @"BMP print",
                       @"获取记录",
                       @"=================",
                       @"建立文件",
                       @"删除文件",
                       @"增加记录",
                       @"获取记录数",
                       @"覆盖记录",
                       nil];
    }
    return self;
}

- (void)viewDidLoad
{
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * currentAction = (NSString*)[dataSource objectAtIndex:indexPath.row];
    if ([currentAction isEqual:@"QRCODE"]) {
        [mposController displayQrcode:@"wwww.qrocde.com/panydkfdkf/111.htlm2323232323232323232323232323232" timeOut:20 successBlock:^{
            NSString *t = [NSString stringWithFormat:@"%@ ---  %@",currentAction,@"显示成功"];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"获取Lib版本号"]) {
        PRINTLOG([mposController getLibVersion]);
        PRINTLOG(@"------------------");
    }
    else if ([currentAction isEqual:@"关闭设备"]) {
        [mposController closeDevice];
    }
    else if ([currentAction isEqual:@"当前连接状态"]) {
        NSString *t = [NSString stringWithFormat:@"%@ ---  当前状态连接[%d]",currentAction,[mposController isConnectToDevice]];
        PRINTLOG(t);
    }
    else if ([currentAction isEqual:@"获取设备信息"]) {
        [mposController getDeviceInfo:^(LDC_DeviceInfo *deviceInfo) {
            PRINTLOG(@"获取设备信息");
            NSString *t1 = [NSString stringWithFormat:@"device SN：%@",deviceInfo.productSN];
            PRINTLOG(t1);
            NSString *t2 = [NSString stringWithFormat:@"CSN：%@",deviceInfo.custormerSN];
            PRINTLOG(t2);
            NSString *t3 = [NSString stringWithFormat:@"LANDI FULL SN：%@",deviceInfo.hardwareSN];
            PRINTLOG(t3);
            NSString *t4 = [NSString stringWithFormat:@"设备固件版本号：%@",deviceInfo.userSoftVer];
            PRINTLOG(t4);
            NSString *t5 = [NSString stringWithFormat:@"当前电量：%d%%",deviceInfo.powerPercent];
            PRINTLOG(t5);
            NSString *t6 = [NSString stringWithFormat:@"BT MAC：%@",deviceInfo.BtMac];
            PRINTLOG(t6);
            PRINTLOG(@"-------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"请出示卡片"]) {
        [mposController waitingCard:@"交易类型文字" timeOut:60 CheckCardTp:SUPPORTCARDTYPE_MAG_IC_RF moneyNum:@"10050.80" successBlock:^(LDE_CardType cardtype) {
            NSString *t = [NSString stringWithFormat:@"%@ ---  卡片类型[%d] \n1--磁条卡 2 -- IC卡  4-- 非接卡",currentAction,cardtype];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"M15的请出示卡片"]) {
        [mposController waitingCard:@"交易类型文字" timeOut:60 CheckCardTp:SUPPORTCARDTYPE_MAG_IC_RF moneyNum:@"0.07" successBlock:^(LDE_CardType cardtype) {
            NSString *t = [NSString stringWithFormat:@"%@ ---  卡片类型[%d] \n1--磁条卡 2 -- IC卡  4-- 非接卡",currentAction,cardtype];
            PRINTLOG(t);
        } progressMsg:^(NSString *stringCB) {
            NSLog(@"过程消息 %@",stringCB);
            NSString *t = [NSString stringWithFormat:@"%@ ---  消息[%@]",stringCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"取消当前操作"]) {
        [mposController cancelCMD:^{
            PRINTLOG(@"取消操作从当前的执行的具体指令接口返回");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"读取卡号"]) {
        [mposController getPAN:PANDATATYPE_PLAIN successCB:^(NSString *stringCB) {
            NSString *t = [NSString stringWithFormat:@"%@ ---  卡号[%@]",currentAction,stringCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"获取磁道数据"]) {
        [mposController getTrackData:TRACKTYPE_PLAIN successCB:^(LDC_TrackDataInfo *trackData) {
            PRINTLOG(@"获取磁道数据一次有效,读完终端会清空磁道");
            NSString *t1 = [NSString stringWithFormat:@"Track 1为：%@",trackData.track1];
            PRINTLOG(t1);
            NSString *t2 = [NSString stringWithFormat:@"Track 2为：%@",trackData.track2];
            PRINTLOG(t2);
            NSString *t3 = [NSString stringWithFormat:@"Track 3为：%@",trackData.track3];
            PRINTLOG(t3);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"EMV开始交易"]) {
        LFC_EMVTradeInfo * emvStart = [[LFC_EMVTradeInfo alloc] init];
        emvStart.flag = FORCEONLINE_NO;
        emvStart.moneyNum = @"0.57";
        emvStart.date = @"141111";
        emvStart.time = @"131212";
        emvStart.type = TRADETYPE_PURCHASE;
        [mposController startPBOC:emvStart trackInfoSuccess:^(LFC_EMVProgress *emvProgress) {
            PRINTLOG(@"EMV开始交易");
            NSString *t1 = [NSString stringWithFormat:@"IC卡二磁等效数据为：%@",emvProgress.track2data];
            PRINTLOG(t1);
            NSString *t2 = [NSString stringWithFormat:@"IC卡卡号为：%@",emvProgress.pan];
            PRINTLOG(t2);
            NSString *t3 = [NSString stringWithFormat:@"IC卡有效期为：%@",emvProgress.cardExpired];
            PRINTLOG(t3);
            NSString *t4 = [NSString stringWithFormat:@"IC卡序列号：%@",emvProgress.panSerialNO];
            PRINTLOG(t4);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"EMV继续交易"]) {
        LFC_GETPIN * inputPin = [[LFC_GETPIN alloc] init];
        inputPin.panBlock = @"601382188888888888";
        inputPin.moneyNum = @"13.99";
        inputPin.timeout = 40;
        [mposController continuePBOC:inputPin successBlock:^(LFC_EMVResult *emvResult) {
            PRINTLOG(@"EMV继续交易");
            NSString *t1 = [NSString stringWithFormat:@"IC卡处理结果         为：%02x",emvResult.result];
            PRINTLOG(t1);
            NSString *t2 = [NSString stringWithFormat:@"IC卡55域数据        为：%@",emvResult.dol];
            PRINTLOG(t2);
            NSString *t3 = [NSString stringWithFormat:@"IC卡PIN密文         为：%@",emvResult.password];
            PRINTLOG(t3);
        }failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"联机数据处理"]) {
        LFC_EMVOnlineData * onlineData = [[LFC_EMVOnlineData alloc] init];
        onlineData.responseCode = @"00";//服务器返回的交易结果码 00 - 成功  55-密码错 35-余额不足等等
        onlineData.onlineData = @"910a11223344556677883030";//IC卡发卡行后台返回的55域联机处理数据，如为空请送nil
        [mposController onlineDataProcess:onlineData successBlock:^(LDC_EMVResult *emvResult) {
            NSString *t1 = [NSString stringWithFormat:@"IC卡处理结果        为：%02x",emvResult.result];
            PRINTLOG(t1);
            NSString *t2 = [NSString stringWithFormat:@"IC交易TC及脚本通知：%@",emvResult.dol];
            PRINTLOG(t2);
        }failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"EMV结束"]) {
        [mposController PBOCStop:^{
            PRINTLOG(@"IC卡结束交易成功");
        }failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"获取密码"]) {
        LFC_GETPIN * inputPin = [[LFC_GETPIN alloc] init];
        inputPin.panBlock = @"601382188888888888";
        inputPin.moneyNum = @"13.99";
        inputPin.timeout = 40;
        [mposController inputPin:inputPin successBlock:^(NSString *dateCB) {
            NSString *t1 = [NSString stringWithFormat:@"PIN密文为：%@",dateCB];
            PRINTLOG(t1);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"M15加密PIN"]) {
        LFC_GETPIN * inputPin = [[LFC_GETPIN alloc] init];
        inputPin.panBlock = @"601382188888888888";
        inputPin.moneyNum = @"13.99";
        inputPin.timeout = 40;
        [mposController encClearPIN:@"963852" withPan:@"6217850800004981450" successBlock:^(NSString *stringCB) {
            PRINTLOG(stringCB);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"导入主密钥"]) {
        LFC_LoadKey * loadKey = [[LFC_LoadKey alloc] init];
        loadKey.keyData = @"8AA431C8BA205B34EFCEA7C4314CD53E4FB006F1";
        loadKey.keyType = KEYTYPE_MKEY;
        [mposController loadKey:loadKey successBlock:^{
            PRINTLOG(@"导入主密钥成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"导入Track密钥"]) {
        LFC_LoadKey * loadKey = [[LFC_LoadKey alloc] init];
        loadKey.keyData = @"F40379AB9E0EC533F40379AB9E0EC53382E13665";
        loadKey.keyType = KEYTYPE_TRACK;
        [mposController loadKey:loadKey successBlock:^{
            PRINTLOG(currentAction);
             PRINTLOG(@"导入Track成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"导入MAC密钥"]) {
        LFC_LoadKey * loadKey = [[LFC_LoadKey alloc] init];
        loadKey.keyData = @"0AFF688FB78192060000000000000000CC671DD4";
        loadKey.keyType = KEYTYPE_MAC;
        [mposController loadKey:loadKey successBlock:^{
            PRINTLOG(currentAction);
             PRINTLOG(@"导入MAC成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"导入PIN密钥"]) {
        LFC_LoadKey * loadKey = [[LFC_LoadKey alloc] init];
        loadKey.keyData = @"B9D9BB0F2FB60F483F6259285847E32C48E67077";
        loadKey.keyType = KEYTYPE_PIN;
        [mposController loadKey:loadKey successBlock:^{
            PRINTLOG(currentAction);
             PRINTLOG(@"导入PIN成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"获取设备日期和时间"]) {
        [mposController getDateTime:^(NSData *dateCB) {
            NSString *t = [NSString stringWithFormat:@"%@ ---  当前时间：%@",currentAction,dateCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"进入固件更新模式"]) {
        [mposController enterFirmwareUpdateMode:^{
            PRINTLOG(@"进入固件更新成功");
            PRINTLOG(@"------------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"更新固件"]) {
        
        [mposController updateFirmware:[[NSBundle mainBundle] pathForResource:@"D086UABCM35x01" ofType:@"bin"] completeBlock:^{
            PRINTLOG(@"更新成功");
            PRINTLOG(@"------------------------");
        } progressBlock:^(unsigned int current, unsigned int total) {
            NSString *t = [NSString stringWithFormat:@"固件更新中 当前[%d]  一共[%d]",current,total];
            PRINTLOG(t);
        } errorBlock:^(int code) {
            NSString *t = [NSString stringWithFormat:@"固件失败[%d]",code];
            PRINTLOG(t);
        }];
    }
    else if ([currentAction isEqual:@"计算MAC"]) {
        [mposController calculateMac:@"11223344556677889900AABBCCDDEE" successBlock:^(NSString *dateCB) {
            NSString *t = [NSString stringWithFormat:@"%@   calculateMac %@",currentAction,dateCB];
            PRINTLOG(t);
        } failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
        
    }
    else if ([currentAction isEqual:@"设置AID"]) {
        NSString * aid = @"9F0608A000000333010101DF0101009F08020020DF1105084000A800DF1205D84004F800DF130500100000009F1B0400000001DF150400000000DF160199DF170199DF14039F3704DF1801019F7B06000000100000DF1906000000100000DF2006000000100000DF2106000000100000";
        
        [mposController AddAid:aid successBlock:^() {
            PRINTLOG(@"添加AID成功");
        } failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"清除AID"]) {
        [mposController clearAids:^{
             PRINTLOG(@"清除AID成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"设置公钥"]) {
        NSString * pubKey = @"ff570100ff59010bff5a05a000000333ff5b0420301230ff5881f8cf9fdf46b356378e9af311b0f981b21a1f22f250fb11f55c958709e3c7241918293483289eae688a094c02c344e2999f315a72841f489e24b1ba0056cfab3b479d0e826452375dcdbb67e97ec2aa66f4601d774feaef775accc621bfeb65fb0053fc5f392aa5e1d4c41a4de9ffdfdf1327c4bb874f1f63a599ee3902fe95e729fd78d4234dc7e6cf1ababaa3f6db29b7f05d1d901d2e76a606a8cbffffecbd918fa2d278bdb43b0434f5d45134be1c2781d157d501ff43e5f1c470967cd57ce53b64d82974c8275937c5d8502a1252a8a5d6088a259b694f98648d9af2cb0efd9d943c69f896d49fa39702162acb5af29b90bade005bc157ff680103ff670101ff6a0400000004";
        [mposController addPubKey:pubKey successBlock:^() {
            PRINTLOG(@"添加公钥成功");
        } failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"QPBOC START"]) {
        LFC_EMVTradeInfo *pbocTrade = [[LFC_EMVTradeInfo alloc] init];
        pbocTrade.flag = FORCEONLINE_NO;
        pbocTrade.moneyNum = @"0.01";
        pbocTrade.date = @"141111";
        pbocTrade.time = @"131212";
        pbocTrade.type = TRADETYPE_PURCHASE;
        [mposController QpbocPurchase:pbocTrade successBlock:^(LDC_EMVResult *emvResult) {
            NSString *t = [NSString stringWithFormat:@"Qpboc交易结果 为：%02X",emvResult.result];
            PRINTLOG(t);
        }failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
        
    }
    else if ([currentAction isEqual:@"QPOC GET NUMS"]) {
        [mposController QpbocGetRecordNums:^(NSString *stringCB) {
            NSString *t = [NSString stringWithFormat:@"终端当前流水文件个数[%d]",[stringCB intValue]];
            PRINTLOG(t);
        } failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"QPOBC DEL"]) {
        [mposController QpbocDelOneRecord:QPBOC_FIRST_RECORD successBlock:^{
            PRINTLOG(@"删除QPBOC第一个流水成功");
        } failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
        
    }
    else if ([currentAction isEqual:@"QPBOC CLEARS"]) {
        [mposController QpbocDelAllRecords:^{
            PRINTLOG(@"清除QPBOC流水成功");
        }failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"QPBOC RECORD"]) {
        [mposController QpbocGetOneRecord:1 successBlock:^(LDC_QPOBCReadRecord *qpbocRecord) {
            NSLog(@"QPBOC卡号：%@",qpbocRecord.pan);
            NSLog(@"QPBOC卡序列号：%@",qpbocRecord.panSn);
            NSLog(@"QPBOC消费时间：%@",qpbocRecord.time);
            NSLog(@"QPBOC消费日期：%@",qpbocRecord.date);
            NSLog(@"QPBOC消费金额：%@",qpbocRecord.amount);
            NSLog(@"QPBOC消费TC：%@",qpbocRecord.record);
        } failedBlock:^(NSString * errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"给卡片上电"]) {
        [mposController powerUpICC:IC_SLOT_ICC1 successBlock:^(NSString *stringCB) {
            NSString *t = [NSString stringWithFormat:@"卡片上电ATR：%@",stringCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"给卡片下电"]) {
        [mposController powerDownICC:IC_SLOT_ICC1 successBlock:^{
             PRINTLOG(@"下电成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"发送APDU"]) {
        [mposController sendApduICC:IC_SLOT_ICC1 withApduCmd:@"00a4040007a0000003330101" successBlock:^(NSString *stringCB) {
            NSString *t = [NSString stringWithFormat:@"APDU应答：%@",stringCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"显示文字"]) {
        [mposController displayLines:@"联迪POS\n唯我独尊\n天下无敌" Row:2 Col:2 Timeout:3 ClearScreen:CLEARFLAG_YES successBlock:^{
            PRINTLOG(@"显示文字成功");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
             ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"手写签名"]){
        [mposController startUserSign:@"0011" timeOut:30 successBlock:^(NSString *stringCB) {
            NSString *t = [NSString stringWithFormat:@"签名图片：%@",stringCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"建立文件"]){
        [mposController createFile:@"FileName" andRecordLen:300 successBlock:^{
            PRINTLOG(@"create file succ");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"删除文件"]){
        [mposController DelFile:@"FileName" successBlock:^{
            PRINTLOG(@"del file succ");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"获取记录数"]){
        [mposController GetFileRecordNums:@"FileName" successBlock:^(NSString *stringCB) {
            NSString *t = [NSString stringWithFormat:@"获取记录数：[%d]",[stringCB intValue]];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"增加记录"]){
        NSData *dd = [[NSData alloc] initWithBytes:"1234567865454gfbffef" length:20];
        [mposController addFileRecord:@"FileName" andRecord:dd successBlock:^{
            PRINTLOG(@"add file record succ");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"覆盖记录"]){
        NSData *dd = [[NSData alloc] initWithBytes:"5555555555555555555" length:20];
        [mposController replaseFileRecord:@"FileName" andRecordId:1 andRecord:dd successBlock:^{
            PRINTLOG(@"replase file record succ");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"获取记录"]){
        [mposController GetFileRecord:@"FileName" andRecordId:1 successBlock:^(NSData *dateCB) {
            NSString *t = [NSString stringWithFormat:@"记录内容：%@",dateCB];
            PRINTLOG(t);
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if ([currentAction isEqual:@"打印数据"]) {
        NSMutableArray *printContent = [[NSMutableArray alloc]init];
        
        LDC_PrintLineStu *oneLine11 = [[LDC_PrintLineStu alloc]init];
        oneLine11.type = PRINTTYPE_TEXT;
        oneLine11.ailg = PRINTALIGN_MID;
        oneLine11.zoom = PRINTZOOM_12;
        oneLine11.gray = 10;
        oneLine11.dotType = PRINTDOT_16X16;
        oneLine11.position = PRINTPOSITION_ALL;
        oneLine11.text = @"我在所有";
        [printContent addObject:oneLine11];
        
        LDC_PrintLineStu *oneLine2 = [[LDC_PrintLineStu alloc]init];
        oneLine2.type = PRINTTYPE_TEXT;
        oneLine2.ailg = PRINTALIGN_LEFT;
        oneLine2.zoom = PRINTZOOM_13;
        oneLine2.gray = 0;
        oneLine2.dotType = PRINTDOT_16X16;
        oneLine2.position = PRINTPOSITION_PAGE1;
        oneLine2.text = @"我在所有";
        [printContent addObject:oneLine2];
        
        LDC_PrintLineStu *oneLine3 = [[LDC_PrintLineStu alloc]init];
        oneLine3.type = PRINTTYPE_TEXT;
        oneLine3.ailg = PRINTALIGN_RIGHT;
        oneLine3.zoom = PRINTZOOM_11;
        oneLine3.gray = 10;
        oneLine3.dotType = PRINTDOT_24X24;
        oneLine3.position = PRINTPOSITION_PAGE1;
        oneLine3.text = @"我在所有";
        [printContent addObject:oneLine3];
        
        LDC_PrintLineStu *oneLine4 = [[LDC_PrintLineStu alloc]init];
        oneLine4.type = PRINTTYPE_TEXT;
        oneLine4.ailg = PRINTALIGN_MID;
        oneLine4.zoom = PRINTZOOM_23;
        oneLine4.gray = 10;
        oneLine4.dotType = PRINTDOT_24X24;
        oneLine4.position = PRINTPOSITION_PAGE1;
        oneLine4.text = @"我在所有";
        [printContent addObject:oneLine4];
       
        LDC_PrintLineStu *oneLine41 = [[LDC_PrintLineStu alloc]init];
        oneLine41.type = PRINTTYPE_TEXT;
        oneLine41.ailg = PRINTALIGN_MID;
        oneLine41.zoom = PRINTZOOM_33;
        oneLine41.gray = 8;
        oneLine41.dotType = PRINTDOT_24X24;
        oneLine41.position = PRINTPOSITION_PAGE1;
        oneLine41.text = @"我在所有";
        [printContent addObject:oneLine41];
        
        LDC_PrintLineStu *oneLine42 = [[LDC_PrintLineStu alloc]init];
        oneLine42.type = PRINTTYPE_TEXT;
        oneLine42.ailg = PRINTALIGN_MID;
        oneLine42.zoom = PRINTZOOM_NORMAL;
        oneLine42.gray = 6;
        oneLine42.dotType = PRINTDOT_32X24;
        oneLine42.position = PRINTPOSITION_PAGE1;
        oneLine42.text = @"我在所有";
        [printContent addObject:oneLine42];
        
        LDC_PrintLineStu *oneLine43 = [[LDC_PrintLineStu alloc]init];
        oneLine43.type = PRINTTYPE_TEXT;
        oneLine43.ailg = PRINTALIGN_MID;
        oneLine43.zoom = PRINTZOOM_NORMAL;
        oneLine43.gray = 3;
        oneLine43.dotType = PRINTDOT_32X24;
        oneLine43.position = PRINTPOSITION_PAGE1;
        oneLine43.text = @"我在所有";
        [printContent addObject:oneLine43];
        
        LDC_PrintLineStu *oneLine44 = [[LDC_PrintLineStu alloc]init];
        oneLine44.type = PRINTTYPE_TEXT;
        oneLine44.ailg = PRINTALIGN_MID;
        oneLine44.zoom = PRINTZOOM_NORMAL;
        oneLine44.gray = 0;
        oneLine44.dotType = PRINTDOT_32X24;
        oneLine44.position = PRINTPOSITION_PAGE1;
        oneLine44.text = @"我在所有";
        [printContent addObject:oneLine44];
        
        LDC_PrintLineStu *oneLine5 = [[LDC_PrintLineStu alloc]init];
        oneLine5.type = PRINTTYPE_QRCODE;
        oneLine5.ailg = PRINTALIGN_RIGHT;
        oneLine5.zoom = PRINTZOOM_NORMAL;
        oneLine5.position = PRINTPOSITION_PAGE1;
        oneLine5.text = @"我在所有";
        
        [printContent addObject:oneLine5];
  
        LDC_PrintLineStu *oneLine6 = [[LDC_PrintLineStu alloc]init];
        oneLine6.type = PRINTTYPE_SINGE;
        oneLine6.ailg = PRINTALIGN_RIGHT;
        oneLine6.zoom = PRINTZOOM_NORMAL;
        oneLine6.position = PRINTPOSITION_PAGE1;
        oneLine6.text = @"000001000000010000000050000000070800031cff02ff02f558616c72ebadd4a3ff00a45aff02a0dc08d05c97ad916b87beb15aff025ab7cc8f16d8ff00caff028f7d90447a9aa2ec60ff004a1bcfe9bd22f699a6c4ec1b1707dff15dcdb726ff006d39b2fc6be2da13a1d7de2dfe3022e6b8a45af03ed2782afbd9140fb32a30ff0223770c7fb555fd321c0be51102737f2a42c16ab2a32e37e4799abddd625ca020e4cd941a863067c0ff02868573503bdf5c4ba8e440ff02f0ff02ff02ff02ff02";
        
        [printContent addObject:oneLine6];
        
        [mposController printText:2 withPrintContent:printContent successBlock:^{
            PRINTLOG(@"打印成功")
            PRINTLOG(@"-------------------")
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"打印机状态"]){
        [mposController getPrinterStatue:^(LDE_PrinterStatus printerStatues) {
            PRINTLOG(@"打印机状态");
            NSString *t1 = [NSString stringWithFormat:@"statue = %d",printerStatues];
            PRINTLOG(t1);
            PRINTLOG(@"--------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"M1 Info"]){
        [mposController M1Active:^(LDC_M1CardInfo *m1cardInfo) {
            PRINTLOG(@"M1 卡信息");
            NSString *t1 = [NSString stringWithFormat:@"card Type %d",m1cardInfo.cardType];
            PRINTLOG(t1);
            NSString *t2 = [NSString stringWithFormat:@"card Ser %@",m1cardInfo.M1CardSerial];
            PRINTLOG(t2);
            NSString *t3 = [NSString stringWithFormat:@"card QTQ %@",m1cardInfo.ATQ];
            PRINTLOG(@"-------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"M1 Auth"]){
        [mposController M1Auth:@"ffffffffffff" BlockNo:0 WithKeyType:M1_KEY_TYPE_A successCB:^{
            PRINTLOG(@"Auth M1 card success");
            PRINTLOG(@"-------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"Read Block"]){
        [mposController M1ReadBlock:1 successCB:^(NSString *stringCB) {
            PRINTLOG(currentAction);
            PRINTLOG(stringCB);
            PRINTLOG(@"-------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"Wirte Block"]){
        [mposController M1WriteBlock:1 BlockData:@"11223344556677889900112233445566" successCB:^{
            PRINTLOG(@"Write M1 card success");
            PRINTLOG(@"-------------------");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
   /* else if([currentAction isEqual:@"BMP print"]){
        NSData* data = [LDStringUtil hexStr2NSData:@"424D2E010000000000003E000000280000003C0000001E0000000100010000000000F00000000000000000000000000000000000000000000000FFFFFF00C1FFFFFFFFFFFFF0E07FFFFFFFFFFFF0F07FFFFFFFFFFFF0F81FFFFFFFFFFFF0FE0FFFFFFFFFFFF0FF07FFFFFFFFFFF0FF83FFFFFFFFFFF0FFC3FFFFFF000FF0FFE1FFFFF00001F0FFF0FFFF80000070FFF87FFF007FC070FFF83FF807FFF810FFFC3FE03FFFFE00FFFE1FC07FFFFF00FFFF0F07FFFFFF80FFFF840FFFFFFFE0FFFF841FFFFFFFF0FFFFC07FFFFFFFF0FFFFE0FFFFFFFFF0FFFFE0FFFFFFFFF0FFFFF0FFFFFFFFF0FFFFF1FFFFFFFFF0FFFFF1FFFFFFFFF0FFFFF0FFFFFFFFF0FFFFF8FFFFFFFFF0FFFFF8FFFFFFFFF0FFFFF8FFFFFFFFF0FFFFF8FFFFFFFFF0FFFFFDFFFFFFFFF0FFFFFFFFFFFFFFF0"];
        [mposController printBmp:100 andZoom:3 andBmpData:data successBlock:^{
            NSLog(@"printBmp success");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }
    else if([currentAction isEqual:@"BMP dot"]){
        NSData* data = [LDStringUtil hexStr2NSData:@"000000000000000000000000000000000000000000C0FCFEFE7C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000C0E0F8FF3FFFFFFCE0C0C08000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000080C0E0F87C3E1F0F0301000000000001010307070E0E0E1E3C38387870707070F0E0E0E0E0E0E0E0E0E0F0F0707078783C3E0F0F07000080C0E0F0F078787C1E1F0F070300000000000000000000000000000000000000000000000000000000010101010101010101010101000000000000000000"];
        [mposController printDot:100 andDotHigh:32 andDotLength:64 andDotData:data successBlock:^{
            NSLog(@"printBmp dot");
        } failedBlock:^(NSString *errCode, NSString *errInfo) {
            ERRLOG;
        }];
    }*/
}

@end
