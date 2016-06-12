//
//  MyAccountGaikuangCell.m
//  QuickPos
//
//  Created by Aotu on 16/1/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "MyAccountGaikuangCell.h"
#import "MyAccountGaikuangModel.h"
@implementation MyAccountGaikuangCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(MyAccountGaikuangModel *)model
{
    _model = model;
    _tixianMoney.text = model.ktxye;
    _mangeMoney.text = model.lczzch;
    _hongbaoNum.text = model.hbgsh;
    _jifenNum.text = model.hyjf;
    
}

- (IBAction)tixianBtnClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(sendBtn:)]) {
        [_delegate sendBtn:sender];
        
    }
    
}

- (IBAction)zichanBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(sendBtn:)]) {
        [_delegate sendBtn2:sender];
        
    }
    
}

- (IBAction)hongBaoBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(sendBtn:)]) {
        [_delegate sendBtn3:sender];
        
    }
    
}
- (IBAction)jifenBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(sendBtn:)]) {
        [_delegate sendBtn4:sender];
        
    }
    
}



@end
