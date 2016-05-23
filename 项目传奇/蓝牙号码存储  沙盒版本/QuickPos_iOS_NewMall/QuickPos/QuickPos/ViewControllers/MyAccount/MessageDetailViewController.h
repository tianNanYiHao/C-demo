//
//  MessageDetailViewController.h
//  QuickPos
//
//  Created by caiyi on 16/3/23.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController

@property (nonatomic,strong) UILabel *TitleLabel;//标题Label
@property (nonatomic,strong) UILabel *TimeLabel;//时间label
@property (nonatomic,strong) UILabel *DescriptionLabel;//描述label



@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *timeStr;
@property (nonatomic,strong) NSString *descriptionStr;



@end
