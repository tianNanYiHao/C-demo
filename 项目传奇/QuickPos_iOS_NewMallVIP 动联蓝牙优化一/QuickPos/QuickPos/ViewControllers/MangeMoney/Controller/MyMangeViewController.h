//
//  MyMangeViewController.h
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMangeViewController : UIViewController



@property (nonatomic,strong)UILabel *mangeAllProfit; //理财总资产
@property (nonatomic,strong)UILabel *yestDayProfit; //昨日收益
@property (nonatomic,strong)UILabel *allProfit;  //累计收益
@property (nonatomic,strong)UILabel *mangeProfit;// 理财收益

@property (nonatomic,strong)NSString *isHolding; //是否持有

@end
