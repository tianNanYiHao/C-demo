
//  ViewController.m
//  BluetoothTest
//
//  Created by gui hua on 15/3/18.
//  Copyright (c) 2015年 szjhl. All rights reserved.
//

#import "ViewController.h"
#import "JhlblueController.h"



#define nAmout  123   //默认传入金额1.23元



#define WAIT_TIMEOUT 30000 //默认超时时间30秒

@interface ViewController () {
    NSMutableArray *deviceList;   //查询到的设备名称列表
    NSMutableArray *connectedList;  //连接成功的列表
}



@end

@implementation ViewController
@synthesize devicesTableView;


/**
 *  检查设备打开线程 获取设备信息
 
 */

-(void) CheckSnThread
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JhlblueController sharedInstance] GetDeviceInfo];
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    deviceList = [[NSMutableArray alloc] init];
    connectedList = [[NSMutableArray alloc] init];
    
    //设置回调与初始化蓝牙
    [[JhlblueController sharedInstance]  setDelegate:self];
    [[JhlblueController sharedInstance]  InitBlue];
    [[JhlblueController sharedInstance]  SetEncryMode:0x01 :0x01 :0x01];  //设置加密方式
    self.LabTip.text = [[JhlblueController sharedInstance] GetSDKVersion];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BtnFoundDevice:(id)sender {
    
    if ([[JhlblueController sharedInstance] isBTConnected])
    {
        self.LabTip.text = @"请先断开连接 ";
    }else
    {
        self.LabTip.text = @"正在搜索蓝牙设备...";
        [connectedList removeAllObjects];
        [deviceList removeAllObjects];
        [self.devicesTableView reloadData];
        [[JhlblueController sharedInstance] scanBTDevice:5 nScanType:0x01];
        
    }
}

- (IBAction)BtndisConnect:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([[JhlblueController sharedInstance] isBTConnected])         {
            self.LabTip.text = @"正在断开,请稍后...";
            [[JhlblueController sharedInstance] disconnectBT];
            [connectedList removeAllObjects];
            [deviceList removeAllObjects];;
            [self.devicesTableView reloadData];
            
            
        }else
        {
            self.LabTip.text = @"未连接设备,无需断开...";
        }

    });
    
    
    
}
- (void)dealloc {
    [_LabTip release];
    [super dealloc];
}

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

- (IBAction)BtnAmountPass:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.LabTip.text = @"请输入金额+请刷卡/插卡+交易密码...";
        if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
        {
            self.LabTip.text = @"请先连接蓝牙设备...";
            return;
        }
        [[JhlblueController sharedInstance] MagnCard:WAIT_TIMEOUT:nAmout:0x01];
        
    });
    
    
}

- (IBAction)BtnAmountNopass:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
        {
            self.LabTip.text = @"请先连接蓝牙设备...";
            return;
        }
        self.LabTip.text = @"请输入金额+请刷卡/插卡...";
        [[JhlblueController sharedInstance] MagnCard:WAIT_TIMEOUT:nAmout:0x02];
    });
    
    
}

- (IBAction)BtnNoAmountpass:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
        {
            self.LabTip.text = @"请先连接蓝牙设备...";
            return;
        }
        
        self.LabTip.text = @"请刷卡/插卡 +输入密码...";
        [[JhlblueController sharedInstance] MagnCard:WAIT_TIMEOUT:nAmout:0x03];
    });
    
    
}

- (IBAction)BtnNoAmountNopass:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
        {
            self.LabTip.text = @"请先连接蓝牙设备...";
            return;
        }
        self.LabTip.text = @"请刷卡/插卡...";
        [[JhlblueController sharedInstance] MagnCard:WAIT_TIMEOUT:nAmout:0x04];
    });
    
    
}

- (IBAction)BtnMainkey:(id)sender {
    
    if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
    {
        self.LabTip.text = @"请先连接蓝牙设备...";
        return;
    }
    [self.LabTip setText:@"正在设置主密钥..."];
    
    NSString *strkey =@"31313131313131313232323232323232";
    [[JhlblueController sharedInstance] WriteMainKey:strkey];
    
}

- (IBAction)BtnWorkKey:(id)sender {
    
    if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
    {
        self.LabTip.text = @"请先连接蓝牙设备...";
        return;
    }
    [self.LabTip setText:@"正在设置工作密钥..."];
     NSString *strkey =@"FBC94E8506FECB63E31BDB62146A1D8960C15261FBC94E8506FECB63E31BDB62146A1D8960C15261FBC94E8506FECB63E31BDB62146A1D8960C15261";
    [[JhlblueController sharedInstance] WriteWorkKey:strkey];
    
}

- (IBAction)BtnTerid:(id)sender {
    if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
    {
        self.LabTip.text = @"请先连接蓝牙设备...";
        return;
    }
    
    self.LabTip.text = @"设置终端号商户号...";
    [[JhlblueController sharedInstance] WriteTernumber:@"12345678901234567890123"];
    
    
}

-  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}
- (IBAction)BtnMac:(id)sender {
    
    int nLen=0;
    
    if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
    {
        self.LabTip.text = @"请先连接蓝牙设备...";
        return;
    }
    
    self.LabTip.text = @"获取MAC...";
    NSString  *strData=@"0200602004c020c098101643808887249349553100000000010000001219c00000000010000000003032313530303630383036303031303030303037323330313536ac3a912f77a39d9726000000000000000014010000010006000200602004c020c098101643808887249349553100000000010000001219c00000000010000000003032313530303630383036303031303030303037323330313536";
    nLen =[self convertToInt:strData];
    [[JhlblueController sharedInstance] GetMac:nLen :strData];
    
    
    
}

- (IBAction)BtnCancel:(id)sender {
    
    if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
    {
        self.LabTip.text = @"请先连接蓝牙设备...";
        return;
    }
    self.LabTip.text = @"正在取消刷卡...";
    [[JhlblueController sharedInstance] MagnCancel];
    
    
    
}

- (IBAction)BtnReadBattery:(id)sender {
    
    if ([[JhlblueController sharedInstance] isBTConnected] ==FALSE)
    {
        self.LabTip.text = @"请先连接蓝牙设备...";
        return;
    }
    self.LabTip.text = @"获取电池电量...";
    [[JhlblueController sharedInstance] ReadBattery];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [connectedList count];
            break;
        case 1:
            return [deviceList count];
        default:
            break;
    }
    return 0;
}

-(void)actionButtonDisconnect:(UIButton *)sender {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[JhlblueController sharedInstance] isBTConnected])         {
            self.LabTip.text = @"正在断开,请稍后...";
            
            [[JhlblueController sharedInstance] disconnectBT];
            [connectedList removeAllObjects];
            [deviceList removeAllObjects];
            [self.devicesTableView reloadData];
            
            
        }else
        {
            self.LabTip.text = @"未连接设备,无需断开...";
        }
        
        
    });
    
    
}


-(void)actionButtonCancel:(UIButton *)sender {
    
    [[JhlblueController sharedInstance] disconnectBT];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    CBPeripheral *dataPath = nil;
    cell.accessoryView = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryView = nil;
    
    switch (indexPath.section) {
        case 0: {
            dataPath = [connectedList objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = @"connected";
            UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [accessoryButton addTarget:self action:@selector(actionButtonDisconnect:)  forControlEvents:UIControlEventTouchUpInside];
            accessoryButton.tag = indexPath.row;
            [accessoryButton setTitle:@"Disconnect" forState:UIControlStateNormal];
            [accessoryButton setFrame:CGRectMake(0,0,100,35)];
            cell.accessoryView  = accessoryButton;
            NSString *strdeName =dataPath.name?dataPath.name:@"Unknow";
            cell.textLabel.text =strdeName;
            
            break;
        }
        case 1: {
            dataPath = [deviceList objectAtIndex:indexPath.row];
            NSString *strdeName =dataPath.name?dataPath.name:@"Unknow";
            cell.textLabel.text =strdeName;
            if (dataPath.state == CBPeripheralStateConnecting) {
                cell.detailTextLabel.text = @"connecting";
                UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [accessoryButton addTarget:self action:@selector(actionButtonCancel:)  forControlEvents:UIControlEventTouchUpInside];
                accessoryButton.tag = indexPath.row;
                [accessoryButton setTitle:@"Cancel" forState:UIControlStateNormal];
                [accessoryButton setFrame:CGRectMake(0,0,100,35)];
                cell.accessoryView  = accessoryButton;
            }
            break;
        }
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = nil;
    switch (section) {
        case 0:
            title = @"已连接设备:";
            break;
        case 1:
            title = @"未连接设备:";
            break;
            
        default:
            break;
    }
    return title;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            
            break;
        case 1: {
            CBPeripheral *dataPath = [deviceList objectAtIndex:indexPath.row];
            
            self.LabTip.text = @"正在连接蓝牙设备";
            [[JhlblueController sharedInstance] connectBT:dataPath connectTimeout:10];  //10秒超时
            [self.devicesTableView reloadData];
            [connectedList addObject:dataPath];
        }
            break;
        default:
            break;
    }
    [self.devicesTableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark ===============蓝牙部分的回调===============

//蓝牙已连接

//发现新的蓝牙
- (void)onFindNewPeripheral:(CBPeripheral *)newPeripheral
{
    NSLog(@"%s,findNewBt:%@",__func__,newPeripheral.name);
    [deviceList addObject:newPeripheral];
    [self.devicesTableView reloadData];
}
- (void)onConnected:(CBPeripheral *)connectedPeripheral
{
    NSLog(@"%s,result:%@",__func__,connectedPeripheral.name);
}

- (void)onDeviceFound:(NSArray *)DeviceList
{
    
    [deviceList removeAllObjects];
    [self.devicesTableView reloadData];
    if ([DeviceList count] ==0)
    {
        self.TextViewTip.text = @"未搜索到蓝牙设备";
        return;
    }
    CBPeripheral *dataPath= nil;
    for (int i=0; i < [DeviceList count]; i++)
    {
        dataPath = [DeviceList objectAtIndex:i];
        [deviceList addObject:dataPath];
    }
    
    [self.devicesTableView reloadData];
    
}

/*
 判断是否处于连接状态  -1 连接后断开i  00 未找到设备  01 连接成功 02 正在连接  03 连接失败
 */
-(void)onBlueState:(int)nState
{
    
    if (nState ==BLUE_SCAN_NODEVICE)
    {
        self.TextViewTip.text = @"MPOS设备已断开,请重新连接";
        [connectedList removeAllObjects];
        [deviceList removeAllObjects];
        [self.devicesTableView reloadData];
        
    }
    else if (nState ==BLUE_CONNECT_FAIL)
        self.TextViewTip.text = @"连接MPOS失败";
    else if (nState ==BLUE_CONNECT_SUCESS)
    {
        
        self.TextViewTip.text = @"设备连接成功,正在获取设备信息";
        [self.devicesTableView reloadData];
        //连接成功获取SN号
        
        NSThread* DeviceSnThread =[[NSThread alloc] initWithTarget:self selector:@selector(CheckSnThread)object:nil];
        [DeviceSnThread start];
        
        
    }
    else if (nState ==BLUE_CONNECT_ING)
        self.TextViewTip.text = @"正在连接...";
    else if (nState ==BLUE_POWER_STATE_ON)
        self.TextViewTip.text = @"蓝牙开启";
    else if (nState ==BLUE_POWER_STATE_OFF)
    {
        if ([[JhlblueController sharedInstance] isBTConnected])
            [[JhlblueController sharedInstance] disconnectBT];
        self.TextViewTip.text = @"蓝牙关闭";
    }
}



#pragma mark ===============功能交易部分的回调===============



//返回设备信息
- (void)onDeviceInfo:(DeviceInfoData)DeviceInfoList
{
    
    NSString * SN =@"SN:";
    NSLog(@"设备信息 %s DeviceSN:%@,Appversion:%@,BootVersion:%@,Model:%@",__func__,DeviceInfoList.DevcieSn,DeviceInfoList.AppVersion,DeviceInfoList.BootVersion,DeviceInfoList.Model);
    
    self.LabTip.text = @"GET  SN  Sucess";
    SN = [SN stringByAppendingString:DeviceInfoList.DevcieSn];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:SN delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    self.TextViewTip.text = SN;
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
            self.TextViewTip.text =@"正在加密数据....";
        }
            break;
            
       	case  MAINKEY_CMD:  //主密钥
        {
            if (nResult ==0x00)
                self.TextViewTip.text =@"主密钥设置成功";
            else
                self.TextViewTip.text =[@"主密钥设置失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
        }
            break;
            
        case  WORKKEY_CMD:  //工作密钥
        {
            if (nResult ==0x00)
                self.TextViewTip.text =@"工作密钥设置成功";
            else
                self.TextViewTip.text =[@"工作密钥设置失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
        }
            break;
        case GETMAC_CMD:  //MAC值
        {
            if (nResult==0x00)
                self.TextViewTip.text =[@"MAC获取成功:"  stringByAppendingString: MsgData];
            else
                self.TextViewTip.text =[@"MAC获取失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
        }
            break;
            
        case WRITETERNUMBER_CMD: //设置终端号商户号成功
        {
            if (nResult==0x00)
                self.LabTip.text =@"终端号商户号设置成功,正在获取商户号终端号";
            else
                self.TextViewTip.text =[@"终端号商户号设置失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
            
            [[JhlblueController sharedInstance] ReadTernumber];
        }
            break;
            
        case GETTERNUMBER_CMD:
        {
            if (nResult==0x00)
                self.TextViewTip.text =[@"终端号商户号获取成功:"  stringByAppendingString: MsgData];
            else
                self.TextViewTip.text =[@"终端号商户号获取失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
        }
            break;
        case BATTERY_CMD:
        {
            if (nResult==0x00)
                self.TextViewTip.text =[@"电池电量获取成功:"  stringByAppendingString: MsgData];
            else
                self.TextViewTip.text =[@"电池电量获取失败,错误代码:"  stringByAppendingString: [NSString stringWithFormat:@"%d",nResult]];
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    NSLog(@"%s,Code:%d,nResult:%d,MsgData:%@",__func__,Code,nResult,MsgData);
}
- (void)swipCardState:(int ) nResult  //刷卡提示
{
    NSLog(@"%s,nResult:%d",__func__,nResult);
    switch(nResult)
    {
        case SWIPE_SUCESS:
            self.TextViewTip.text =@"刷卡正常";
            break;
        case SWIPE_DOWNGRADE:
            self.TextViewTip.text =@"刷卡降级";
            break;
        case SWIPE_ICCARD_INSETR:
            self.TextViewTip.text =@"在待机界面插入IC卡";
            break;
        case SWIPE_ICCARD_SWINSETR:
            self.TextViewTip.text =@"交易功能插入IC";
            break;
        case SWIPE_WAIT_BRUSH:
            self.TextViewTip.text =@"请刷卡,等待刷卡";
            break;
        case SWIPE_CANCEL:
            self.TextViewTip.text =@"用户取消";
            break;
        case SWIPE_TIMEOUT_STOP:
            self.TextViewTip.text =@"超时退出";
            break;
        case SWIPE_IC_FAILD:
            self.TextViewTip.text =@"IC卡处理数据失败"	;
            break;
        case SWIPE_NOICPARM:
            self.TextViewTip.text =@"无IC卡参数";
            break;
        case SWIPE_STOP:
            self.TextViewTip.text =@"交易终止";
            break;
        case SWIPE_IC_REMOVE:
            self.TextViewTip.text =@"加密失败,用户拔出IC卡";
            break;
        case SWIPE_LOW_POWER:
            self.TextViewTip.text =@"低电量,不允许交易";
            break;
        case BLUE_POWER_OFF:
            self.TextViewTip.text =@"已关机";
            break;
        case BLUE_DATA_WAITE:
            self.TextViewTip.text =@"设备数据处理中";
            break;
        case BLUE_DEVICE_ERROR:
             self.TextViewTip.text =@"设备非法,不匹配当前SDK";
            break;
        default:
            break;
    }
    
}
- (void)onReadCardData:(FieldTrackData) FildCardData
{
    // NSLog(@"%s,onReadCardData:%@",__func__,FildCardData.CardSeq);
    
    self.TextViewTip.text =[@"PAN:" stringByAppendingString:FildCardData.TrackPAN];
    self.LabTip.text =[@"刷卡成功,金额:" stringByAppendingString:[NSString stringWithFormat:@"%.2f元",FildCardData.szAmount]];
    
    
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
    if (FildCardData.bDowngrade ==TRUE)
        NSLog(@"是否降级:%@",@"降级");
    else
        NSLog(@"是否降级:%@",@"正常");
    
}


@end

