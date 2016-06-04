//
//  SureBuyTableViewCell.h
//  QuickPos
//
//  Created by Aotu on 16/1/13.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class hongBaoModel;

@protocol SureBuyTableviewCellDelegate <NSObject>


-(void)sendBtnActionWithBtn:(UIButton*)btn withIndexpath:(NSIndexPath*)indexPath;


@end

@interface SureBuyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UILabel *hongBaoPrice;



@property (weak, nonatomic) IBOutlet UILabel *hongBaoDetail;


@property (nonatomic,strong) NSString *imageName;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,strong)hongBaoModel *model;

@property (nonatomic,assign)id<SureBuyTableviewCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;

@end
