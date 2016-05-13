//
//  HotMangerModel.h
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotMangerModel : NSObject



@property (nonatomic,strong) NSString *lccp_amt; //起够金额

@property (nonatomic,strong) NSString *lccp_id; //产品惟一ID

@property (nonatomic,strong) NSString *lccp_name; //产品名称

@property (nonatomic,strong) NSString *lccp_date; //期限

@property (nonatomic,strong) NSString *lccp_rate; //收益率

@property (nonatomic,strong) NSString *lccp_nums; //产品总份额

@property (nonatomic,strong) NSString *lccp_sale_num; //产品已销售份额

-(instancetype)initWithDict:(NSDictionary*)dict;


@end

