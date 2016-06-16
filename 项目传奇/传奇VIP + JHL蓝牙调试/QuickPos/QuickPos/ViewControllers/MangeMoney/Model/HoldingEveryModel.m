//
//  HoldingEveryModel.m
//  QuickPos
//
//  Created by Aotu on 16/1/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "HoldingEveryModel.h"

@implementation HoldingEveryModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init]) {
        self.date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"date"]];
        self.lccp_shy = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shy"]];
        
    }return self;
}

@end
