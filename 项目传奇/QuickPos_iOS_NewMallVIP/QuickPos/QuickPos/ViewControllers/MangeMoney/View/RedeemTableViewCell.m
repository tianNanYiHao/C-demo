//
//  RedeemTableViewCell.m
//  QuickPos
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "RedeemTableViewCell.h"
#include "RedeemModel.h"
#import "Common.h"

@implementation RedeemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _backgroudView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _lineView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    
    
}

-(void)setModel:(RedeemModel *)model
{
    _model = model;
    _titleName.text = model.lccp_name;
    _redeemMoney.text = [NSString stringWithFormat:@"%.2f",[model.lccp_shh_bj floatValue]/100];
    _redeemProfit.text = [NSString stringWithFormat:@"%.2f",[model.Lccp_shh_shy floatValue]/100];
    
    NSString *str = [NSString stringWithFormat:@"%@",model.lccp_shh_date];
    _redeemDay.text = [NSString stringWithFormat:@"%@-%@-%@",
                       [str substringWithRange:NSMakeRange(0, 4)],
                       [str substringWithRange:NSMakeRange(4, 2)],
                       [str substringWithRange:NSMakeRange(6, 2)]
                       ];
    
    
    
    
    if ([model.lccp_flag isEqualToString:@"01"]) { //赎回已到账
         _financialImg.image = [UIImage imageNamed:@"financial_yi"];
    }else if([model.lccp_flag isEqualToString:@"00"]){
        _financialImg.image = [UIImage imageNamed:@"financial_wei"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
