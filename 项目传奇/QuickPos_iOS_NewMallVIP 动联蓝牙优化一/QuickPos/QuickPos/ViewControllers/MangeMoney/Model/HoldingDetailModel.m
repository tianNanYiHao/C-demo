//
//  HoldingDetailModel.m
//  QuickPos
//
//  Created by Aotu on 16/1/14.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "HoldingDetailModel.h"

@implementation HoldingDetailModel


-(instancetype)initWithDict:(NSDictionary*)dict{
    if (self = [super init]) {
        self.lccp_chy_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_id"]];
        self.lccp_chy_num = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_num"]];
        self.lccp_shy_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shy_amt"]];
        self.lccp_chy_no = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_no"]];
        self.lccp_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_name"]];
        self.lccp_chy_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_amt"]];
        self.lccp_zrshy_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_zrshy_amt"]];
        self.lccp_flag = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_flag"]];
    }return self;
    

}

@end
