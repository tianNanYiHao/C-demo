//
//  buleTestViewController.m
//  QuickPos
//
//  Created by Aotu on 16/5/26.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "buleTestViewController.h"
#import "DCBlueToothManager.h"
#import "PSTAlertController.h"
#import "MyCreditCardMachineViewController.h"
@interface buleTestViewController ()
@property (nonatomic,strong) DCBlueToothManager *dcBlueToothManager;
@property (weak, nonatomic) IBOutlet UIImageView *swiperingView;

@end

@implementation buleTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"DCBlueToothManagerTestView";
    self.view.backgroundColor = [UIColor whiteColor];
     _swiperingView.hidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"uuidName"]) {
        _dcBlueToothManager = [DCBlueToothManager getDCBlueToothManager];
        _dcBlueToothManager.viewController = self;
        _dcBlueToothManager.orderId = @"1234567812345678";
        _dcBlueToothManager.transLogo = @"123456";
        _dcBlueToothManager.cash = 10;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticePost:) name:@"startswipe" object:nil];

    }else{
        PSTAlertController *psta =[PSTAlertController alertWithTitle:@"" message:@"您还未选择蓝牙刷卡器"];
        [psta addAction:[PSTAlertAction actionWithTitle:@"去选择" handler:^(PSTAlertAction * _Nonnull action) {
           UIStoryboard *s  = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyCreditCardMachineViewController *my = [s instantiateViewControllerWithIdentifier:@"MyCreditCardMachineVC"];
            [self.navigationController pushViewController:my animated:YES];
        }]];
        [psta addAction:[PSTAlertAction actionWithTitle:@"取消" handler:^(PSTAlertAction * _Nonnull action) {
        }]];
        [psta showWithSender:nil controller:self animated:YES completion:NULL];
        
    }
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_dcBlueToothManager searchDCBlueTooth];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_dcBlueToothManager disConnectDCBlueTooth]; //断开连接
    _swiperingView.hidden = YES;
}

- (void)noticePost:(NSNotification *)noti{
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = noti.userInfo;
    NSString *showSwiper = [dict objectForKey:@"showSwipe"];
    
    if ([showSwiper isEqualToString:@"yes"]) {
        _swiperingView.hidden = NO;
    }else if ([showSwiper isEqualToString:@"no"]){
        _swiperingView.hidden = YES;
    }
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
