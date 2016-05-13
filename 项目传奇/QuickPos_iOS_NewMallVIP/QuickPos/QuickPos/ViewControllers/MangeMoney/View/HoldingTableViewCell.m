//
//  HoldingTableViewCell.m
//  QuickPos
//
//  Created by Aotu on 15/12/22.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "HoldingTableViewCell.h"
#import "HoldingModel.h"
#import "Common.h"

@implementation HoldingTableViewCell



- (void)awakeFromNib {
    // Initialization code
    _huiseView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _lineView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
   
    

    
}

-(void)setModel:(HoldingModel *)Model
{
    _Model = Model;
    
    _titleName.text = Model.lccp_name;
    _yestDayProfit.text = [NSString stringWithFormat:@"%.2f",[Model.lccp_zrshy_amt floatValue]/100];
    _holdingMoney.text = [NSString stringWithFormat:@"%.2f",[Model.lccp_chy_amt floatValue]/100];
    _isCanBack = Model.lccp_flag;
    
    if ([Model.lccp_flag isEqualToString:@"00"]) {
        _canBack.image = [UIImage imageNamed:@"financial_ksh"];
        
    }else if ([Model.lccp_flag isEqualToString:@"01"])
    {
        _canBack.image = [UIImage imageNamed:@""];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
