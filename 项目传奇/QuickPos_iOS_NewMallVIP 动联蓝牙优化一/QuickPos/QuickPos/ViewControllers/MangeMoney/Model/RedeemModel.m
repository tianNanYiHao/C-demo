//
//  RedeemModel.m
//  QuickPos
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "RedeemModel.h"

@implementation RedeemModel

-(instancetype)initWtihDict:(NSDictionary *)dict
{
    
    if ([super init]) {
        _lccp_chy_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_id"]];
        _lccp_chy_no = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_no"]];
        _lccp_flag = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_flag"]];
        _lccp_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_name"]];
        _lccp_shh_bj = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shh_bj"]];
        _lccp_shh_date = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shh_date"]];
        _lccp_shh_num = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shh_num"]];
        _lccp_shh_orderid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shh_orderid"]];
        _Lccp_shh_shy = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Lccp_shh_shy"]];
        
        
    }return self;
    
}

@end
