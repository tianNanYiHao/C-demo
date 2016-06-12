//
//  ProductDetailModel.m
//  QuickPos
//
//  Created by Aotu on 16/1/5.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "ProductDetailModel.h"

@implementation ProductDetailModel


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if ([super init]) {
        self.lccp_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_id"]];
        self.lccp_info = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_info"]];
        self.lccp_shyu_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shyu_amt"]];
        self.lccp_shm = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shm"]];
        self.lccp_mjjs_date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_mjjs_date"]];
        self.lccp_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_amt"]];
        self.lccp_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_name"]];
        self.lccp_rate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_rate"]];
        self.lccp_date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_date"]];
 
        
    }
    return self;
}
@end
