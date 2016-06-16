//
//  hongBaoModel.h
//  QuickPos
//
//  Created by Aotu on 16/1/13.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hongBaoModel : NSObject


@property (nonatomic,strong) NSString *lccp_hb_amt; //红包价格
@property (nonatomic,strong) NSString *enddate; // 截止日期
@property (nonatomic,strong) NSString *startdate; // 开始日期
@property (nonatomic,strong) NSString *lccp_hb_name; //名字
@property (nonatomic,strong) NSString *lccp_hb_id; // id
@property (nonatomic,strong) NSString *num; //红包个数



-(instancetype)initWithDict:(NSDictionary *)dict;



@end
