//
//  MainViewController.m
//  P27_Demo
//
//  Created by 爱笑 on 16/1/4.
//  Copyright © 2016年 爱笑. All rights reserved.
//

#import "MainViewController.h"
#import "PopTableView.h"
#import "PopCardInfoView.h"
#import "MBProgressHUD.h"
#import <DCSwiperAPI/DCSwiperAPI.h>

@interface MainViewController ()<DCSwiperAPIDelegate,UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    DCSwiperAPI *cswiper;
    MBProgressHUD *waitView;
    NSMutableArray *arrayList;

    NSDictionary *dicSelect;

    NSMutableArray *infos;
    CBPeripheral *Peripheral;
    NSMutableDictionary *PeripheralDic;
}

@property(strong, nonatomic) PopTableView *popView;
@property(strong, nonatomic) PopCardInfoView *cardInfoView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cswiper = [DCSwiperAPI sharedDCEMV];
    cswiper.delegate = self;
    arrayList = [[NSMutableArray alloc] init];
    infos = [[NSMutableArray alloc] init];
    PeripheralDic = [[NSMutableDictionary alloc] init];
    
}

//搜索设备
- (IBAction)scanCSwiper:(id)sender {
    
    self.popView = [[PopTableView alloc] initWithFrame:CGRectMake(50, 80, kScreenWidth/2+kScreenWidth/6, kScreenHeight/2+kScreenHeight/6)];
    [self.popView setFrame];
    self.popView.tableView.delegate = self;
    self.popView.tableView.dataSource = self;
   [self.popView.closeButton addTarget:self action:@selector(hidePopView) forControlEvents:UIControlEventTouchUpInside];
       
    /*
    //单指触屏触发事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)];
    [self.view addGestureRecognizer:tap];
    */
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view addSubview:_popView];
        
    } completion:^(BOOL finished) {}];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [cswiper scanBlueDevice];
    });
}

//停止搜索
- (IBAction)stopScanCSwiper:(id)sender {
    [cswiper stopScanBlueDevice];
}


//连接设备
- (IBAction)connectCSwiperButton:(id)sender {
//    [cswiper connectBlueDevice:dicSelect];
 
   CBPeripheral *peripheral = [PeripheralDic objectForKey:[dicSelect objectForKey:PERIPHERAL_IDENTIFER]];
    
    [cswiper connectBluetoothDevice:peripheral];
}

//断开连接
- (IBAction)disconnectCSwiperButton:(id)sender {
    [cswiper disConnect];
}


//获取设备信息
- (IBAction)getCSwiperKsnButton:(id)sender {
//    if (cswiper.isConnectBlue) {
//        [cswiper getDeviceKsn];
        [cswiper getDeviceInfo];
//    }else{
//        [self showAlertView:@"" messgae:@"请连接设备！"];
//    }

}

//- (IBAction)updateKeyButton:(id)sender {
//    NSDictionary *keyDic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            @"950973182317F80B950973182317F80B00962B60", @"PINKey",
//                            @"F679786E2411E3DEADC67D84", @"MacKey",
//                            nil];
//    
//    if(cswiper.isConnectBlue)
//    {
//        [cswiper updateKey:keyDic];
//    }else{
//        [self showAlertView:@"" messgae:@"请连接设备！"];
//    }
//}



/*
orderId--订单号 16位字符
transLogo--流水号 6位字符
cash -- 交易金额（单位：分）
transactType-- 交易类型 消费显示金额  余额查询不要显示金额
*/


//刷卡
- (IBAction)getCardInfoButton:(id)sender {

    
    [cswiper startPOS:@"1122334455667788" transLogo:@"123456" cash:1.25 transactType:4];
    
    
}

//取消刷卡
- (IBAction)cancelButton:(id)sender {
    [cswiper cancelPinInput];
}
//获取电量
- (IBAction)encPinButton:(id)sender {


    [cswiper getDeviceElectric];
    
    
}

//获取卡号
- (IBAction)getaCardNumber:(id)sender {
    
    [cswiper getCardNumber];
//    NSLog(@"%hhd",cswiper.isConnectBlue);
 
}


#pragma mark - dcwiperapi delegate
//-(void)onFindBlueDevice:(NSDictionary *)dic
//{
//    
//    
//    NSLog(@"%@",dic);
//    if (![arrayList containsObject:dic] ) {
//        [arrayList addObject:dic];
//        [self.popView.tableView reloadData];
//    }
//}

- (void)onFindBluetoothDevice:(CBPeripheral *)peripheral{
    
[PeripheralDic setValue:peripheral forKey:[peripheral.identifier UUIDString]];
    NSString *name = peripheral.name;
    NSString *identifier = peripheral.identifier.UUIDString;
    
    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:name,@"Name",identifier,@"identifier", nil];
    
    
    if (![arrayList containsObject:dic] ) {
        [arrayList addObject:dic];
        [self.popView.tableView reloadData];
    }
}

- (void)dontStarBluetooth{
    
    NSLog(@"蓝牙未开启");
}

//-(void)onDidConnectBlueDevice:(NSDictionary *)dic
//{
//    NSLog(@"!!!!!!!!!!!!!!!设备连接成功");
//    [self showAlertView:@"设备连接成功" messgae:[dic objectForKey:PERIPHERAL_NAME]];
//}

- (void)onDidConnectBluetoothDevice:(CBPeripheral *)peripheral
{
    NSLog(@"!!!!!!!!!!!!!!!设备连接成功");
    [self showAlertView:@"设备连接成功" messgae:peripheral.name];
    
}

//-(void)onDisconnectBlueDevice:(NSDictionary *)dic
//{
//    NSLog(@"@@@@@@@@@@@@@@@@@@设备断开");
//    [self showAlertView:@"设备已断开连接" messgae:[dic objectForKey:PERIPHERAL_NAME]];
//}
- (void)onDisconnectBluetoothDevice:(CBPeripheral *)peripheral
{
    
    NSLog(@"@@@@@@@@@@@@@@@@@@设备断开");
    [self showAlertView:@"设备已断开连接" messgae:peripheral.name];
    
}



-(void)onDidGetDeviceKsn:(NSDictionary *)dic
{
    //dic[@"1"]存放设备ksn
    [self showAlertView:@"KSN" messgae:[dic objectForKey:@"6"]];
}

- (void)onDCCardNumber:(NSString *)cardNumber
{
    
    [self endWaiting];
    [self showAlertView:@"卡号为" messgae:cardNumber];
}

- (void)DCEMVReturnDeviceInfo:(NSDictionary *)deviceInfoDict
{
    
    [self endWaiting];
    [infos removeAllObjects];
    self.cardInfoView = [[PopCardInfoView alloc] initWithFrame:CGRectMake(50, 80, kScreenWidth/2+kScreenWidth/6, kScreenHeight/2+kScreenHeight/6)];
    [self.cardInfoView setFrame];
    [self.cardInfoView.closeButton addTarget:self action:@selector(hideCardInfoView) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *accountNum = [@"psamNo:" stringByAppendingString:deviceInfoDict[@"psamNo"]];
    [infos addObject:accountNum];

    
    NSString *track2Info = [@"terminalId:" stringByAppendingString:deviceInfoDict[@"terminalId"]];
    [infos addObject:track2Info];
    
    NSString *info = [infos componentsJoinedByString:@"\n"];
    self.cardInfoView.cardInfo.text = info;
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view addSubview:_cardInfoView];
        
    } completion:^(BOOL finished) {}];
    
}

-(void)onDidUpdateKey:(int)retCode;
{
    if ( retCode == 0 ) {
        [self showAlertView:@"签到" messgae:@"成功"];
    }
}

-(void)onDCEMVPOSCancel
{
    [self showAlertView:@"取消/复位" messgae:@"成功"];
}


- (void)onWaitingForCard
{
    [self endWaiting];
    [self showAlertView:@"刷卡提示" messgae:@"请刷卡！"];
}

-(void)onDetectCard
{
    [self endWaiting];
    [self beginWaiting:@"正在读取卡片信息，请稍候!"];
}


//获取设备信息
//- (void)DCEMVReturnDeviceInfo:(NSDictionary *)deviceInfoDict
//{
//    
//    NSLog(@"%@",deviceInfoDict);
//}
- (void)onDCEMVTrackData:(NSDictionary *)trackInfo;
{
    NSLog(@"%@",trackInfo);
    
    [self endWaiting];
    [infos removeAllObjects];
    self.cardInfoView = [[PopCardInfoView alloc] initWithFrame:CGRectMake(50, 80, kScreenWidth/2+kScreenWidth/6, kScreenHeight/2+kScreenHeight/6)];
    [self.cardInfoView setFrame];
    [self.cardInfoView.closeButton addTarget:self action:@selector(hideCardInfoView) forControlEvents:UIControlEventTouchUpInside];
    
    if (cswiper.currentCardType == card_mc) {//磁条卡信息
        //卡号
        NSString *accountNum = [@"encTrack:" stringByAppendingString:trackInfo[@"encTrack"]];
        [infos addObject:accountNum];
        
        NSString *track2Info = [@"pan:" stringByAppendingString:trackInfo[@"pan"]];
        [infos addObject:track2Info];
        
        NSString *track3Info = [@"expireDate:" stringByAppendingString:trackInfo[@"expireDate"]];
        [infos addObject:track3Info];
        
        NSString *expiryDate = [@"psamNo:" stringByAppendingString:trackInfo[@"psamNo"]];
        [infos addObject:expiryDate];


    }
    
    NSString *info = [infos componentsJoinedByString:@"\n"];
    self.cardInfoView.cardInfo.text = info;
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view addSubview:_cardInfoView];
        
    } completion:^(BOOL finished) {}];
}



- (void)onDCEMVICData:(NSDictionary *)icInfo
{
    NSLog(@"%@",icInfo);
    
    [self endWaiting];
    [infos removeAllObjects];
    self.cardInfoView = [[PopCardInfoView alloc] initWithFrame:CGRectMake(50, 80, kScreenWidth/2+kScreenWidth/6, kScreenHeight/2+kScreenHeight/6)];
    [self.cardInfoView setFrame];
    [self.cardInfoView.closeButton addTarget:self action:@selector(hideCardInfoView) forControlEvents:UIControlEventTouchUpInside];
    
 
    NSString *accountNum = [@"encIC:" stringByAppendingString:icInfo[@"encIC"]];
    [infos addObject:accountNum];

    NSString *track2Info = [@"pan:" stringByAppendingString:icInfo[@"pan"]];
    [infos addObject:track2Info];

    NSString *track3Info = [@"expireDate:" stringByAppendingString:icInfo[@"expireDate"]];
    [infos addObject:track3Info];

    NSString *expiryDate = [@"psamNo:" stringByAppendingString:icInfo[@"psamNo"]];
    [infos addObject:expiryDate];

    NSString *info = [infos componentsJoinedByString:@"\n"];
    self.cardInfoView.cardInfo.text = info;
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.view addSubview:_cardInfoView];
        
    } completion:^(BOOL finished) {}];
}



- (void)onDCEMVError:(DCEMVErrorType)DCEMVErrorType errorMessage:(NSString *)errorMessage
{
    [self endWaiting];
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







- (void)DCEMVBatteryLow:(DCEMVBatteryStatus)batteryStatus{
    
    [self showAlertView:@"电量" messgae:[NSString stringWithFormat:@"%d",batteryStatus]];
}


#pragma mark -tableView dataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!iPhone4 && !iPhone5) {
            return 55;
        }
        return 45;
    }
    if (!iPhone4 && !iPhone5) {
        return 55;
    }
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *_Cell_ = @"_Cell_";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_Cell_];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_Cell_];
    }
    
    NSDictionary *dic = [arrayList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:PERIPHERAL_NAME];
    cell.detailTextLabel.text = [dic objectForKey:PERIPHERAL_IDENTIFER];
 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    dicSelect = [arrayList objectAtIndex:indexPath.row];

    
    [self showAlertView:@"当前选择的设备" messgae:[dicSelect objectForKey:PERIPHERAL_NAME]];
    [self hidePopView];
}

- (void)showAlertView:(NSString *)title messgae:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)hidePopView{
    
    [UIView animateWithDuration:1 animations:^{
        
        [self.popView removeFromSuperview];
        
    } completion:^(BOOL finished) {}];
}

-(void)hideCardInfoView
{
    [UIView animateWithDuration:1 animations:^{
        
        [self.cardInfoView removeFromSuperview];
        
    } completion:^(BOOL finished) {}];
}

-(void)beginWaiting:(NSString *)message
{
    waitView = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:waitView];
    waitView.delegate = self;
    waitView.labelText = message;
    waitView.square = NO;
    [waitView show:YES];
}

-(void)endWaiting
{
    [waitView hide:YES afterDelay:.5];
}

@end
