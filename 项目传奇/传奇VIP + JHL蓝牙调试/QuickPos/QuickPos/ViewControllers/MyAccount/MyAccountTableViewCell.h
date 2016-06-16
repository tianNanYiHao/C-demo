//
//  MyAccountTableViewCell.h
//  QuickPos
//
//  Created by 张倡榕 on 15/3/11.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题

@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;//余额之类的

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;//图标

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;//箭头

@end
