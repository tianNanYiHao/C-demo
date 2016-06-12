//
//  SureRedeemViewController.h
//  QuickPos
//
//  Created by Aotu on 16/1/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SureRedeemViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UILabel *titleName; //产品名
@property (weak, nonatomic) IBOutlet UILabel *yearRate; //年化收益率


@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *danjia; //单价

@property (weak, nonatomic) IBOutlet UILabel *numberLab; //数量lab

@property (weak, nonatomic) IBOutlet UIButton *jianBtn; //减号
@property (weak, nonatomic) IBOutlet UIButton *jia;  //加号
@property (weak, nonatomic) IBOutlet UIView *lineView;




@property (nonatomic,strong) NSString *lccPID; //产品id
@property (nonatomic,strong) NSString *SureBuyTitleName; //产品名
@property (nonatomic,strong) NSString *SureBuyYearRate; //年化收益率
@property (nonatomic,strong) NSString *SureBuyDanjia; //单价

@property (nonatomic,strong) NSString *chiyouCode; //持有编码


@end
