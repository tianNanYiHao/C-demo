//
//  RedeemModel.h
//  QuickPos
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedeemModel : NSObject


//@property (nonatomic,strong) NSString *titlename;
//@property (nonatomic,strong) NSString *redeemMoney; //赎回金额
//@property (nonatomic,strong) NSString *redeemDay; //赎回日期;
//@property (nonatomic,strong) NSString *redeemProfit; //赎回收益
//
//@property (nonatomic,strong) NSString *isFinanci;//是否到账

//
@property (nonatomic,strong) NSString *lccp_chy_no; //持有编码
@property (nonatomic,strong) NSString *lccp_chy_id; //产品ID
@property (nonatomic,strong) NSString *lccp_shh_num; //赎回份额
@property (nonatomic,strong) NSString *lccp_shh_bj; // 赎回本金
@property (nonatomic,strong) NSString *lccp_shh_orderid; // 赎回订单号
@property (nonatomic,strong) NSString *lccp_flag; //赎回状态
@property (nonatomic,strong) NSString *Lccp_shh_shy; //赎回收益
@property (nonatomic,strong) NSString *lccp_shh_date; //赎回日期
@property (nonatomic,strong) NSString *lccp_name; //


-(instancetype)initWtihDict:(NSDictionary *)dict;



@end
