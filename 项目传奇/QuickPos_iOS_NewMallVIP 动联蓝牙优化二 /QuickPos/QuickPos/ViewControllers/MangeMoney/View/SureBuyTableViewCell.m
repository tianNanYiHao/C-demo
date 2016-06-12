//
//  SureBuyTableViewCell.m
//  QuickPos
//
//  Created by Aotu on 16/1/13.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "SureBuyTableViewCell.h"
#import "Common.h"
#import "hongBaoModel.h"
@implementation SureBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.titleName.textColor = [Common hexStringToColor:@"757575"];
    
    self.hongBaoPrice.textColor = [Common  hexStringToColor:@"dd2727"];
    self.hongBaoDetail.textColor = [Common hexStringToColor:@"b3b3b3"];
    
    self.contentView.backgroundColor = [Common hexStringToColor:@"f8f8f8"];
   
    
    
    
    
}
- (IBAction)sendBtn:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(sendBtnActionWithBtn:withIndexpath:)]) {
        [_delegate sendBtnActionWithBtn:sender withIndexpath:_indexPath];
        
    }
    
    
}

-(void)setModel:(hongBaoModel *)model
{
    _model = model;
    _titleName.text = _model.lccp_hb_name;
    
    _hongBaoPrice.text = [NSString stringWithFormat:@"%.2f",[_model.lccp_hb_amt floatValue]/100];

    NSString *startDate = [NSString stringWithFormat:@"%@-%@-%@",
                           [_model.startdate substringWithRange:NSMakeRange(0, 4)],
                           [_model.startdate substringWithRange:NSMakeRange(4, 2)],
                           [_model.startdate substringWithRange:NSMakeRange(6, 2)]
                           ];
    NSString *endDate = [NSString stringWithFormat:@"%@-%@-%@",
                         [_model.enddate substringWithRange:NSMakeRange(0, 4)],
                         [_model.enddate substringWithRange:NSMakeRange(4, 2)],
                         [_model.enddate substringWithRange:NSMakeRange(6, 2)]
                         ];
    
    _hongBaoDetail.text = [NSString stringWithFormat:@"有效期至%@-%@",startDate,endDate];

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
