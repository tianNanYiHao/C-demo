//
//  TranDetailTableViewCell.m
//  QuickPos
//
//  Created by Aotu on 15/12/25.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "TranDetailTableViewCell.h"
#import "HoldingEveryModel.h"
#import "Masonry.h"
#import "Common.h"

@interface TranDetailTableViewCell()
{
    UILabel *_data;
    UILabel *_money;
    
    
}
@end


@implementation TranDetailTableViewCell



+(instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"id";
    TranDetailTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TranDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        [cell addSubviews];
        
    }return cell;
 
}


-(void)addSubviews{
    
    _data = [Tool createLabWithFrame:CGRectMake(15, 5, kScreenWidth/2-30, 20) title:nil font:[UIFont systemFontOfSize:13] color:[Common hexStringToColor:@"757575"]];
    _data.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_data];
    
    _money = [Tool createLabWithFrame:CGRectMake(30+kScreenWidth/2-15, 5, kScreenWidth/2-30, 20) title:nil font:[UIFont systemFontOfSize:13] color:[Common hexStringToColor:@"757575"]];
    _money.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_money];
    

}


-(void)setModel:(HoldingEveryModel *)model{
    _model = model;
    _money.text  = [NSString stringWithFormat:@"%.2f",[model.lccp_shy floatValue]];
    _data.text = [NSString stringWithFormat:@"%@-%@-%@",
                   [model.date substringWithRange:NSMakeRange(0, 4)],
                   [model.date substringWithRange:NSMakeRange(4, 2)],
                   [model.date substringWithRange:NSMakeRange(6, 2)]
                   ];
}







- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
