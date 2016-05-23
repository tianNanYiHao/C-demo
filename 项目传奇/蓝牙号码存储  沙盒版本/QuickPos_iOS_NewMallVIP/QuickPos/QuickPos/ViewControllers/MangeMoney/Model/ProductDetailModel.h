//
//  ProductDetailModel.h
//  QuickPos
//
//  Created by Aotu on 16/1/5.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDetailModel : NSObject

@property (nonatomic,strong) NSString *lccp_mjjs_date; //募集结束日期
@property (nonatomic,strong) NSString *lccp_shm;       //产品说明
@property (nonatomic,strong) NSString *lccp_info;      //产品详细描述
@property (nonatomic,strong) NSString *lccp_amt;       //
@property (nonatomic,strong) NSString *lccp_id;        // 理财产品iD
@property (nonatomic,strong) NSString *lccp_date;      //
@property (nonatomic,strong) NSString *lccp_shyu_amt;  //剩余金额
@property (nonatomic,strong) NSString *lccp_name; //
@property (nonatomic,strong) NSString *lccp_rate; //

-(instancetype)initWithDict:(NSDictionary *)dict;


@end
