//
//  MyAccountGaikuangModel.h
//  QuickPos
//
//  Created by Aotu on 16/1/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAccountGaikuangModel : NSObject

@property (nonatomic,strong) NSString *lczzch; // 账户余额
@property (nonatomic,strong) NSString *hbgsh; //  红包个数
@property (nonatomic,strong) NSString *ktxye; // 可提现余额
@property (nonatomic,strong) NSString *hyjf; // 积分


-(instancetype)initWithDict:(NSDictionary*)dict;



@end
