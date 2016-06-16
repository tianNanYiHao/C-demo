//
//  HoldingDetailModel.h
//  QuickPos
//
//  Created by Aotu on 16/1/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoldingDetailModel : NSObject

@property (nonatomic,strong) NSString * lccp_chy_id;//
@property (nonatomic,strong) NSString * lccp_chy_num;//
@property (nonatomic,strong) NSString * lccp_shy_amt;// 收益
@property (nonatomic,strong) NSString * lccp_chy_no;// 持有编码
@property (nonatomic,strong) NSString * lccp_name;// 名字
@property (nonatomic,strong) NSString * lccp_chy_amt;// 持有金额
@property (nonatomic,strong) NSString * lccp_zrshy_amt;// 昨日收益
@property (nonatomic,strong) NSString * lccp_flag;// 是否赎回


-(instancetype)initWithDict:(NSDictionary*)dict;



@end
