//
//  ViewController.m
//  P27BlueToothPosManager
//
//  Created by Aotu on 16/5/20.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import <DCSwiperAPI/DCSwiperAPI.h>
#import "MBProgressHUD.h"
#import "nextViewController.h"


@interface ViewController ()<DCSwiperAPIDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    DCSwiperAPI               *_dcsWiper;   //蓝牙单例对象
    NSMutableDictionary       *_BTNameDict; //蓝牙名字字典
    NSMutableArray            *_BTNameArray;//蓝牙名称数据源
    NSString                  *_identifier; //选中的蓝牙Mac
    MBProgressHUD             *_hud;
    

}
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UILabel     *showLab;

@end

@implementation ViewController

-(UILabel*)showLab{
    if (!_showLab) {
        _showLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 500, 400, 80)];
        _showLab.numberOfLines = 0;
        _showLab.font = [UIFont systemFontOfSize:10];
        _showLab.backgroundColor = [UIColor lightGrayColor];
    }return _showLab;
    
}

-(void)showHUDWithString:(NSString*)message{
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.delegate = self;
    [self.view addSubview:_hud];
    _hud.labelText = message;
    [_hud show:YES];
}

-(void)endHUD{
    [_hud hide:YES];
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _dcsWiper = [DCSwiperAPI sharedDCEMV];
    _dcsWiper.delegate = self;
    
    _BTNameDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    _BTNameArray = [[NSMutableArray alloc] initWithCapacity:0];
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, 400, 100) style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self.view addSubview:self.showLab];
    
    self.navigationController.navigationBarHidden = YES;

}




#pragma mark - 点击搜索,连接等操作
//搜索蓝牙
- (IBAction)searchBL:(id)sender {
    NSLog(@"=========搜索蓝牙==========");
    if (_BTNameArray.count>0) {
        [_BTNameArray removeAllObjects];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //如果蓝牙连接着
        if ([_dcsWiper isBTConnected]) {
            
        }else{ //如果蓝牙未连接
            [_dcsWiper scanBlueDevice]; // 搜索蓝牙
        }
    });
}


//连接设备
//只要是蓝牙,都能通过此方法连接上 (需要不到1秒的连接时间)
//(当设备关闭,再点击连接此设备,不会调用 connectBluetoothDevice: 方法  此方法返回bool 1为连接 0为连接失败)
- (IBAction)connectBT:(id)sender {
    NSLog(@"=========连接设备==========");
    CBPeripheral *peripheral = [_BTNameDict objectForKey:_identifier];
    [_dcsWiper connectBluetoothDevice:peripheral];
}

//获取设备信息
//(如果连接非动联蓝牙, 会提示 信息发送成功, 但不会打印蓝牙设备信息)
- (IBAction)getBTdeviceInfomation:(id)sender {
    NSLog(@"=========获取设备信息==========");
    
    if ([_dcsWiper isBTConnected]) {   //判断蓝牙(任何) 是否连接上
        [_dcsWiper getDeviceInfo];
        
    }else{
        NSLog(@"蓝牙未连接上手机");
        [self showHUDWithString:@"蓝牙未连接上手机"];
    }
}


//刷卡
//订单号: 流水号: 金额:交易类型:
- (IBAction)swipingCardWithBT:(id)sender {
    NSLog(@"=========刷卡==========");
    
    if ([_dcsWiper isBTConnected]) {
        [_dcsWiper startPOS:@"1234567812345678" transLogo:@"123456" cash:10 transactType:4];
    }
}

//取消刷卡
- (IBAction)cancelSwipingCardWithBT:(id)sender {
    NSLog(@"=========取消刷卡==========");
    [_dcsWiper cancelPinInput];
}

//获取卡号(SDK代理流程和刷卡一样走)
- (IBAction)getCardNumWithBT:(id)sender {
    NSLog(@"=========获取卡号==========");
    [_dcsWiper getCardNumber];
}

//获取电量
- (IBAction)getBatteryWithBT:(id)sender {
    NSLog(@"=========获取电量==========");
    [_dcsWiper getDeviceElectric];
}
//停止搜索(停止之后 不会再去不断搜索)
- (IBAction)stopSearchBT:(id)sender {
    NSLog(@"=========停止搜索==========");
    [_dcsWiper stopScanBlueDevice];
  
}
//断开连接
- (IBAction)disconnectBT:(id)sender {
    NSLog(@"=========断开连接==========");
    [_dcsWiper disConnect];
    
    nextViewController *next = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nextVIewController1"];
    [self.navigationController pushViewController:next animated:YES];
    
}






#pragma mark - dcwiperapi delegate  == SDK的代理方法集合
//当扫描设备是反馈结果
//(多次调用 获取设备 name )(每当搜索到新的蓝牙才会调用,以前的蓝牙搜索到了,关闭再打开是不会再调用此方法的!)
- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral{
    
    [_BTNameDict setObject:peripheral forKey:peripheral.identifier.UUIDString];
    NSLog(@"_BTNameDict =====>> %@",_BTNameDict);
    NSString *name = peripheral.name;
    NSString *identifier = peripheral.identifier.UUIDString;
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"name",identifier,@"identifier" ,nil];
    

    [_BTNameArray addObject:dict];
    [_tableview reloadData];
    NSLog(@"_BTNameArray ======>> %@",_BTNameArray);
        
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
    self.showLab.text = [NSString stringWithFormat:@"%@",deviceInfoDict];
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
    [self showHUDWithString:@"正在刷卡中,请稍后"];
    
}
//当刷IC卡的时候反馈
-(void)onDCEMVICData:(NSDictionary *)icInfo{
    NSLog(@"+++++++++++++刷IC卡返回信息%@",icInfo);
    [self endHUD];
    self.showLab.font = [UIFont systemFontOfSize:5];
    self.showLab.text = [NSString stringWithFormat:@"%@",icInfo];
    
}
//当刷磁条卡Track时反馈
-(void)onDCEMVTrackData:(NSDictionary *)trackInfo{
    NSLog(@"+++++++++++++刷磁条Track卡返回信息%@",trackInfo);
    [self endHUD];
    self.showLab.font = [UIFont systemFontOfSize:5];
    self.showLab.text = [NSString stringWithFormat:@"%@",trackInfo];
}

//当刷卡后获取卡号的反馈
-(void)onDCCardNumber:(NSString *)cardNumber{
    [self endHUD];
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
    [self endHUD];
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














#pragma mark - TableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _BTNameArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = [_BTNameArray[indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [_BTNameArray[indexPath.row] objectForKey:@"identifier"];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _identifier =  [_BTNameArray[indexPath.row] objectForKey:@"identifier"];
    
    
}



- (void)showAlertView:(NSString *)title messgae:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
