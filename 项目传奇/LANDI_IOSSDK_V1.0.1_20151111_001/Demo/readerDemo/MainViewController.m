//
//  MainViewController.m
//  readerDemo
//
//  Created by lvv on 14-3-11.
//  Copyright (c) 2014年 landi. All rights reserved.
//

#import "MainViewController.h"
#import "MethodViewController.h"

#import "LandiMPOS.h"

#import "MBProgressHUD+Custom.h"

@interface MainViewController () {
    NSMutableArray *devices;
}
@property(nonatomic,strong) LandiMPOS *manager;

@end

@implementation MainViewController
@synthesize manager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        devices = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    manager = [LandiMPOS getInstance];
    NSLog(@"logVersion is:%@",[manager getLibVersion]);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查询按钮响应事件
- (IBAction)searchAction:(id)sender {
    
    [devices removeAllObjects];
    __block NSMutableArray *weakDevices = devices;
    [manager startSearchDev:8000 searchOneDeviceBlcok:^(LDC_DEVICEBASEINFO *deviceInfo) {
        NSLog(@"searchOneDevice");
        NSLog(@"%@",deviceInfo.deviceName);
        NSLog(@"%@",deviceInfo.deviceIndentifier);
        [weakDevices addObject:deviceInfo];
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:self waitUntilDone:NO];
    } completeBlock:^(NSMutableArray *deviceArray) {
        NSLog(@"searchCompleteBloc");
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:self waitUntilDone:NO];
    }];
}

- (IBAction)stopSearchAction:(id)sender {
    NSLog(@"stopSearch");
    [manager stopSearchDev];
}

//更新界面
- (void)updateTableView {
    
    //    [MBProgressHUD hide];
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //NSLog(@"devices count ===== %lu",(unsigned long)[devices count]);
    return [devices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    LDC_DEVICEBASEINFO *deviceInfo = [devices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = deviceInfo.deviceName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LDC_DEVICEBASEINFO *deviceInfo = [devices objectAtIndex:indexPath.row];
    [manager openDevice:deviceInfo.deviceIndentifier channel:deviceInfo.deviceChannel mode:COMMUNICATIONMODE_MASTER successBlock:^{
        MethodViewController *methodViewCtr = [[MethodViewController alloc] initWithNibName:@"MethodViewController" bundle:nil];
        [self.navigationController pushViewController:methodViewCtr animated:YES];
        [methodViewCtr setDeviceIndentifier:[deviceInfo deviceIndentifier]];
        methodViewCtr.readerManager = manager;
    } failedBlock:^(NSString *errCode, NSString *errInfo) {
        NSLog(@"设备开启失败.失败码：%@,失败描述:%@",errCode,errInfo);
    }];
}


@end
