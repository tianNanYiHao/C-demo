//
//  HotMangeTableViewCell.h
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotMangerModel;

@protocol WithBankingDetailsTableViewCellDelegate <NSObject>


-(void)sendBtnAction:(UIButton*)btn withIndexPath:(NSIndexPath*)indexPath;
-(void)sendNowBuyBtnAction:(UIButton*)btn withIndexPath:(NSIndexPath*)indexPath;




@end

@class HotMangerModel;

@interface HotMangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLab; //大标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleNameLab; //副标题
@property (weak, nonatomic) IBOutlet UIButton *clickBtn; //隐藏的点击按钮



@property (weak, nonatomic) IBOutlet UILabel *profitMoneyLab;//年化收益率

@property (weak, nonatomic) IBOutlet UILabel *investMoneyLab;//起投金额

@property (weak, nonatomic) IBOutlet UILabel *mangeMoneyDayLab;//理财期限

@property (weak, nonatomic) IBOutlet UIButton *nowBuyBtn;//立即购买Btn



@property (nonatomic,strong) NSIndexPath *indexPath;


@property (nonatomic,strong) HotMangerModel *model;

@property (nonatomic,retain) id<WithBankingDetailsTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *image_bank; //图片 勾


//@property (assign, nonatomic) CommitBlock commitBlock;


@end
