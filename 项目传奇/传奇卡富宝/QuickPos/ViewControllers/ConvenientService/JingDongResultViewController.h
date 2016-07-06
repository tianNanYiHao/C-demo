//
//  JingDongResultViewController.h
//  QuickPos
//
//  Created by kuailefu on 16/6/28.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingDongResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *state;

@property (weak, nonatomic) IBOutlet UILabel *moneyBiglabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLab; //金额
@property (weak, nonatomic) IBOutlet UILabel *timeLab;  //时间
@property (weak, nonatomic) IBOutlet UILabel *typeLab;  //方式
@property (weak, nonatomic) IBOutlet UILabel *orderIDLab; //单号

@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *transDate;
@property (nonatomic, strong) NSString *transTime;
@property (nonatomic, strong) NSString *transLogNo;
@property (nonatomic, strong) NSString *stateinfo;
@end
