//
//  CarBuyHeadListCell.h
//  QuickPos
//
//  Created by Lff on 16/12/12.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JFShopCarModel;
@protocol CarBuyHeadListCellDelegate <NSObject>
-(void)chooseStoreBtn:(UIButton*)btn store_id:(NSInteger)store_id;

@end

@interface CarBuyHeadListCell : UITableViewCell

@property (nonatomic,strong) JFShopCarModel *model;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (nonatomic,assign)id<CarBuyHeadListCellDelegate>delegate;


@end
