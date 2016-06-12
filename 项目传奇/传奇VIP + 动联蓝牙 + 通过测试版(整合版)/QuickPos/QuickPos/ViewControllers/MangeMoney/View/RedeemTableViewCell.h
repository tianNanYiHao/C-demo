//
//  RedeemTableViewCell.h
//  QuickPos
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedeemModel;

@interface RedeemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (weak, nonatomic) IBOutlet UIImageView *financialImg; //是否到账图片

@property (weak, nonatomic) IBOutlet UILabel *titleName; //标题

@property (weak, nonatomic) IBOutlet UILabel *isRedeem; //已赎回

@property (weak, nonatomic) IBOutlet UILabel *redeemMoney;//赎回金额


@property (weak, nonatomic) IBOutlet UILabel *redeemDay;//赎回日期

@property (weak, nonatomic) IBOutlet UILabel *redeemProfit; //赎回收益
@property (nonatomic,strong) RedeemModel *model;





@end
