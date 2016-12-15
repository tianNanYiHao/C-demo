//
//  CarBuyListCell.m
//  QuickPos
//
//  Created by Lff on 16/12/7.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "CarBuyListCell.h"
#import "JFShopCarModel.h"
#import "UIImageView+WebCache.h"

@implementation CarBuyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//选中
- (IBAction)chooseBtn:(UIButton*)sender {
    CarBuyListCell *cell = (CarBuyListCell*)sender.superview.superview;
    if ([_delegate respondsToSelector:@selector(chooseBtnClickDelegate: model:)]) {
        [_delegate chooseBtnClickDelegate:sender model:cell.model];
    }
    
}

//-
- (IBAction)jianBtnClick:(UIButton*)sender {
    CarBuyListCell *cell = (CarBuyListCell*)sender.superview.superview;
    JFShopCarModel *model = cell.model;
    if (_count !=1) {
        self.count -= 1;
        model.goods_num = self.count;   //修改cell中的数据模型参数
        [_delegate CarBuyListCellGoods_numChange:cell];
    }
    
}

//+
- (IBAction)jiaBtnClick:(UIButton*)sender {
    CarBuyListCell *cell = (CarBuyListCell*)sender.superview.superview;
    JFShopCarModel *model = cell.model;
    if (_count <99) {
        self.count += 1;
        model.goods_num = self.count;
        [_delegate CarBuyListCellGoods_numChange:cell];
    }
    
}
-(void)setCount:(NSInteger)count{
    _count = count;
    _countLab.text = [NSString stringWithFormat:@"%ld",(long)count];
}

- (void)setModel:(JFShopCarModel *)model{
    _model = model;
    _chooseBtn.selected = model.isSelected;
    [_imageIcon sd_setImageWithURL:[NSURL URLWithString:model.goods_image_url] placeholderImage:[UIImage imageNamed:model.goods_image]];
    _titleLab.text = model.goods_name;
    [_titleLab sizeToFit];
    _moneyLab.text = [NSString stringWithFormat:@"%.2f",model.goods_price];
    _countLab.text = [NSString stringWithFormat:@"%ld",(long)model.goods_num];
    self.count = model.goods_num;
}


@end
