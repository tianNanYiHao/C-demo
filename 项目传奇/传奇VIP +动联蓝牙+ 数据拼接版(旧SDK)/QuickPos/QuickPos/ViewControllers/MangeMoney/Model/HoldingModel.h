//
//  HoldingModel.h
//  QuickPos
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>
//持有中模型
@interface HoldingModel : NSObject

//@property (nonatomic,strong) NSString *titlename;
//@property (nonatomic,strong) NSString *yestDayProfit; //昨日收益率
//@property (nonatomic,strong) NSString *holdingMoney; //持有金额;


@property (nonatomic,strong) NSString *lccp_chy_no; //持有编码
@property (nonatomic,strong) NSString *lccp_chy_id; //产品ID
@property (nonatomic,strong) NSString *lccp_chy_num;//持有份额
@property (nonatomic,strong) NSString *lccp_chy_amt;//持有金额
@property (nonatomic,strong) NSString *Lccp_shy_amt;//累计收益
@property (nonatomic,strong) NSString *lccp_flag;   //是否允许赎回
@property (nonatomic,strong) NSString *lccp_name;   //产品名称
@property (nonatomic,strong) NSString *lccp_zrshy_amt; //昨日累计收益

-(instancetype)initWithDict:(NSDictionary *)dict;





@end
