//
//  SureNowRedeemViewController.h
//  QuickPos
//
//  Created by Aotu on 16/1/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureNowRedeemViewController : UIViewController




@property (weak, nonatomic) IBOutlet UIView *vieW1;
@property (weak, nonatomic) IBOutlet UIImageView *icon; //icon
@property (weak, nonatomic) IBOutlet UILabel *userName; //用户名



@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UILabel *redeemMoneyLab; //赎回金额


@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *view4Text; //介绍文字



@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UITextField *yzCodeTextfiled; //验证码

@property (weak, nonatomic) IBOutlet UIButton *yzCodeBtn; //验证码获取按钮









@property (nonatomic,strong) NSString *lccPID; //产品id
@property (nonatomic,strong) NSString *SureBuyTitleName; //产品名
@property (nonatomic,strong) NSString *SureBuyYearRate; //年化收益率
@property (nonatomic,strong) NSString *SureBuyDanjia; //单价
@property (nonatomic,strong) NSString *chiyouCode; //持有编码

@property (nonatomic,strong) NSString *redemRealMoney; //赎回金额实际
@property (nonatomic,strong) NSString *redemOrderID ; //赎回订单ID




@end
