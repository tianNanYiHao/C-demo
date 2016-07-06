//
//  JingDongResultViewController.m
//  QuickPos
//
//  Created by kuailefu on 16/6/28.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "JingDongResultViewController.h"

@interface JingDongResultViewController ()
@property (weak, nonatomic) IBOutlet UIButton *comfirt;

@end

@implementation JingDongResultViewController
- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    double userSum = [self.money doubleValue];
    NSString *money = [NSMutableString stringWithFormat:@"%0.2f",userSum/100];
    self.moneyLab.text = money;
    self.moneyBiglabel.text = money;
    self.comfirt.layer.cornerRadius = 5;
    self.title = @"收款详情";
    //日期处理
    NSMutableString *str = [NSMutableString stringWithString:self.transDate];
    [str insertString:@"-" atIndex:4];
    NSMutableString *str2 = [NSMutableString stringWithString:str];
    [str2 insertString:@"-" atIndex:7];
    
    NSMutableString *str3 = [NSMutableString stringWithString:self.transTime];
    [str3 insertString:@":" atIndex:4];
    NSMutableString *str4 = [NSMutableString stringWithString:str3];
    [str4 insertString:@":" atIndex:2];
    
    self.timeLab.text = [NSString stringWithFormat:@"%@ %@",str2, str4];
    self.orderIDLab.text = self.transLogNo;
    self.state.text = self.stateinfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
