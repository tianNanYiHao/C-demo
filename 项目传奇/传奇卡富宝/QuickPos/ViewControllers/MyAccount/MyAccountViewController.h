//
//  MyAccountViewController.h
//  YoolinkIpos
//
//  Created by 张倡榕 on 15/3/4.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *headicon;//头像

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;//姓名

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//余额

@property (weak, nonatomic) IBOutlet UILabel *withdrawalLabel;//可提现余额

@property (weak, nonatomic) IBOutlet UIButton *headiconButton;//（暂时不用）

@property (weak, nonatomic) IBOutlet UIView *headiconView; //头像显示上传的头像view




@end