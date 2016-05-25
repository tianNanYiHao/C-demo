//
//  HotMangeTableViewCell.m
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "HotMangeTableViewCell.h"
#import "HotMangerModel.h"
#import "Common.h"

@interface HotMangeTableViewCell()
{
   
}
@end

@implementation HotMangeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _lineView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _titleNameLab.textColor = [Common hexStringToColor:@"333333"];
    _subTitleNameLab.textColor = [Common hexStringToColor:@"47a8ef"];
    _profitMoneyLab.textColor = [Common hexStringToColor:@"ff801a"];
    _nowBuyBtn.backgroundColor = [Common hexStringToColor:@"47a8ef"];
//    [_clickBtn addTarget:self action:@selector(delegateClick:) forControlEvents:UIControlEventTouchUpInside];
//    
    
    _lineView.hidden = NO;
    
    _image_bank.hidden = YES;
    _subTitleNameLab.hidden = YES;
}

-(void)setModel:(HotMangerModel *)model
{
    _model = model;
    
    _titleNameLab.text = model.lccp_name;
    
    _profitMoneyLab.text = model.lccp_rate;
    
    _investMoneyLab.text = [NSString stringWithFormat:@"%.2f",[model.lccp_amt floatValue]/100];

    _mangeMoneyDayLab.text = model.lccp_date;
    
}

//触发事件

- (IBAction)buttonAction:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(sendBtnAction:withIndexPath:)]) {
        [self.delegate sendBtnAction:sender withIndexPath:_indexPath];
    }
    
    
}


- (IBAction)nowBuyAction:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(sendNowBuyBtnAction:withIndexPath:)]) {
        [self.delegate sendNowBuyBtnAction:sender withIndexPath:_indexPath];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}


@end
