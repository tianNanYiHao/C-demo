//
//  TranDetailTableViewCell.h
//  QuickPos
//
//  Created by Aotu on 15/12/25.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HoldingEveryModel;


@interface TranDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) HoldingEveryModel *model;




+(instancetype)cellWithTableView:(UITableView*)tableview;



@end
