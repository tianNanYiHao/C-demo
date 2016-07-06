//
//  PayWayViewController.m
//  QuickPos
//
//  Created by Aotu on 16/6/24.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "PayWayViewController.h"
#import "Common.h"

@interface PayWayViewController ()

@end

@implementation PayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"刷卡方式";
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]
    ;
    _payWay = @"";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getpayWayTypeWithBlock:(PayWayViewControllerBlock)block{
    _payWayViewControllerBlock = block;
}

//艾闯蓝牙
- (IBAction)itronBTbtn:(id)sender {
    _payWay = @"itron蓝牙";
    _payWayViewControllerBlock (_payWay,self.view);
//    self.view.hidden = YES;
}
//动联蓝牙
- (IBAction)dcBTbtn:(id)sender {
   
    _payWay = @"动联蓝牙";
    _payWayViewControllerBlock (_payWay,self.view);
//     self.view.hidden = YES;

}
//艾闯音频
- (IBAction)itronPlugeBtn:(id)sender {
     _payWay = @"音频";
     _payWayViewControllerBlock (_payWay,self.view);
//     self.view.hidden = YES;
}

@end
