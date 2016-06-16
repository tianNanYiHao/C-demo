//
//  JHLBTPosVManager.m
//  BluetoothTest
//
//  Created by Aotu on 16/6/7.
//  Copyright © 2016年 szjhl. All rights reserved.
//

#import "JHLBTPosVManager.h"

#import "JhlblueController.h"
#import "PSTAlertController.h"
#import "MBProgressHUD.h"

@interface JHLBTPosVManager ()<JhlblueControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD             *_hud;
    NSMutableArray *deviceList;   //查询到的设备名称列表
    NSMutableArray *connectedList;  //连接成功的列表
    
    NSMutableArray      *nameArray; //存储搜索到的蓝牙名
    NSInteger           _index;     //下标
    
}
@end

@implementation JHLBTPosVManager

-(void)showHUDWihtMessage:(NSString*)message{
    _hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:_hud];
    _hud.labelText = message;
    _hud.delegate = self;
    [_hud show:YES];
    
}
-(void)hidHUD{
    [_hud hide:YES];
}
-(void)hidHUDWithDelay:(int)delay{
    [_hud hide:YES afterDelay:delay];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor grayColor];
    self.view.alpha = 0.2;
    
    deviceList = [[NSMutableArray alloc] init];
    connectedList = [[NSMutableArray alloc] init];
    nameArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //设置回调与初始化蓝牙
    [[JhlblueController sharedInstance]  setDelegate:self];
    [[JhlblueController sharedInstance]  InitBlue];
    [[JhlblueController sharedInstance]  SetEncryMode:0x01 :0x01 :0x01];  //设置加密方式
    
    
    //1.查找设备
    
    if ([[JhlblueController sharedInstance] isBTConnected])  //判断是否连接状态
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[JhlblueController sharedInstance] isBTConnected]){
                
                
                //1.1 先判断是否需要 断开连接 = YES
                [self showHUDWihtMessage:@"正在断开,请稍后..."];
                [[JhlblueController sharedInstance] disconnectBT];
                
                
//                [connectedList removeAllObjects];
//                [deviceList removeAllObjects];;
//                [self.devicesTableView reloadData];
                
                
            }else{
                NSLog(@"未连接设备,无需断开...");
            }
            
        });


    }else
    //2.否则,连接蓝牙
    {

        [[JhlblueController sharedInstance] scanBTDevice:5 nScanType:0x00];  //0 是列表返回  1:收到一个即时返回一个
        [self showHUDWihtMessage:@"正在搜索蓝牙设备..."];
    }

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ===============蓝牙部分的回调===============


//0x01 发现新的蓝牙  //搜索模式为一个个返回时回调(多次)
- (void)onFindNewPeripheral:(CBPeripheral *)newPeripheral
{
    NSLog(@"%s,findNewBt:%@",__func__,newPeripheral.name);
}
//0x01 搜索到的蓝牙设备  //搜索模式为列表返回时回调
- (void)onDeviceFound:(NSArray *)DeviceList
{
    //搜索结束
    [self hidHUD];
    NSLog(@"DeviceList === %@",DeviceList);
    
    NSString *bdm = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"];
    NSLog(@"====bdm==== %@",bdm);
    CBPeripheral *dataPath= nil;

    
    if (nameArray.count >0) {
        [nameArray removeAllObjects];
    }
    NSString *name = [NSString new];
    for (int i = 0; i<DeviceList.count; i++) {
        dataPath = DeviceList[i];
        name = dataPath.name;
        [nameArray addObject:name];
    }
    
    if (nameArray.count > 0) {
        NSString *nameRight = [NSString new];
        for (int j = 0; j < nameArray.count; j++) {
            nameRight = nameArray[j];
            if ([nameRight isEqualToString:bdm]) {
                _index = j;
            }
        }
    }
  
    
    
    if (_index && _index>0) {
        [[JhlblueController sharedInstance] connectBT:DeviceList[_index] connectTimeout:10];  //10秒超时 //连接蓝牙
        _index = -1;
    }
  
    else if ([DeviceList count] ==0){  
        
        [self showHUDWihtMessage:@"未搜索到蓝牙,请重新搜索1"];
        [self hidHUDWithDelay:1.5];
    }
    else {
     
        [self showHUDWihtMessage:@"未搜索到蓝牙,请重新搜索2"];
        [super.navigationController popViewControllerAnimated:YES];
        [self hidHUDWithDelay:1.5];

        
    }
    
    
}
//检测到蓝牙已连接时回调
- (void)onConnected:(CBPeripheral *)connectedPeripheral
{
    NSLog(@"%s,result:%@",__func__,connectedPeripheral.name);
}



/*
 判断是否处于连接状态  -1 连接后断开i  00 未找到设备  01 连接成功 02 正在连接  03 连接失败
 */
//连接状态反馈
-(void)onBlueState:(int)nState
{
    
    if (nState ==BLUE_SCAN_NODEVICE)
    {
//        self.TextViewTip.text = @"MPOS设备已断开,请重新连接";
//        [connectedList removeAllObjects];
//        [deviceList removeAllObjects];
//        [self.devicesTableView reloadData];
        
    }
    else if (nState ==BLUE_CONNECT_FAIL){
//        self.TextViewTip.text = @"连接MPOS失败";
    }
    else if (nState ==BLUE_CONNECT_SUCESS)
    {
        
//        self.TextViewTip.text = @"设备连接成功,正在获取设备信息";
//        [self.devicesTableView reloadData];
        //连接成功获取SN号
//        
//        NSThread* DeviceSnThread =[[NSThread alloc] initWithTarget:self selector:@selector(CheckSnThread)object:nil];
//        [DeviceSnThread start];
        
        
    }
    
    else if (nState ==BLUE_CONNECT_ING){
//        self.TextViewTip.text = @"正在连接...";
    }
    else if (nState ==BLUE_POWER_STATE_ON){   //当手机蓝牙开启时检测回调
//        self.TextViewTip.text = @"蓝牙开启";
//        [self showHUDWihtMessage:@"检测到手机蓝牙处于开启状态"];
//        [self hidHUDWithDelay:2];
    }
    
    else if (nState ==BLUE_POWER_STATE_OFF){  //当手机蓝牙关闭时检测回调
        
        if ([[JhlblueController sharedInstance] isBTConnected]){
            [[JhlblueController sharedInstance] disconnectBT];
        }
//        [self showHUDWihtMessage:@"检测到手机蓝牙处于关闭状态"];
//        [self hidHUDWithDelay:2];

    }
    
}




@end
