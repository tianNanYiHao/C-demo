//
//  MyAccountGaikuangCell.h
//  QuickPos
//
//  Created by Aotu on 16/1/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyAccountGaikuangModel;
@protocol MyAccountGaikuangCellDelegate <NSObject>

-(void)sendBtn:(UIButton*)btn;
-(void)sendBtn2:(UIButton*)btn;
-(void)sendBtn3:(UIButton*)btn;
-(void)sendBtn4:(UIButton*)btn;
@end

@interface MyAccountGaikuangCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *tixianMoney; //可提现余额
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn; //提现btn



@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *mangeMoney; //理财资产

@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UILabel *hongbaoNum; //红包个数


@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *jifenNum; //积分

@property (nonatomic,strong) MyAccountGaikuangModel *model;
@property (nonatomic,assign) id<MyAccountGaikuangCellDelegate>delegate;


@end
