//
//  HoldingTableViewCell.h
//  QuickPos
//
//  Created by Aotu on 15/12/22.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HoldingModel;

@interface HoldingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *huiseView; //灰色view

@property (weak, nonatomic) IBOutlet UILabel *titleName;     //名字
@property (weak, nonatomic) IBOutlet UILabel *yestDayProfit; //昨日收益
@property (weak, nonatomic) IBOutlet UILabel *holdingMoney;  //持有金额
@property (nonatomic,strong) NSString *isCanBack;            //是否能赎回

@property (weak, nonatomic) IBOutlet UIImageView *canBack; //可赎回

@property (nonatomic,strong) HoldingModel *Model;


@end
