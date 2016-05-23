//
//  HoldingEveryModel.h
//  QuickPos
//
//  Created by Aotu on 16/1/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HoldingEveryModel : NSObject

@property (nonatomic,strong) NSString *date;// 日期
@property (nonatomic,strong) NSString *lccp_shy;// 收益


-(instancetype)initWithDict:(NSDictionary*)dict;


@end
