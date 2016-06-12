//
//  HoldingModel.m
//  QuickPos
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "HoldingModel.h"

@implementation HoldingModel

-(instancetype)initWithDict:(NSDictionary *)dict
{
    
    if ([super init]) {
//        
//        NSLog(@"lccp_chy_amtmmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_chy_amt"] class]);
//        NSLog(@"lccp_chy_idmmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_chy_id"] class]);
//        NSLog(@"lccp_chy_nommmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_chy_no"] class]);
//        NSLog(@"lccp_chy_nummmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_chy_num"] class]);
//        NSLog(@"lccp_flagmmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_flag"] class]);
//        NSLog(@"lccp_namemmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_name"] class]);
//        NSLog(@"Lccp_shy_amtmmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"Lccp_shy_amt"] class]);
//        NSLog(@"lccp_zrshy_amtmmmmmmmmmmmmmmmm%@",[[dict objectForKey:@"lccp_zrshy_amt"] class]);
//        
        self.lccp_chy_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_amt"]];
        self.lccp_chy_id  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_id"]];
        self.lccp_chy_no  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_no"]];
        self.lccp_chy_num = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_chy_num"]];
        self.lccp_flag    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_flag"]];
        self.lccp_name    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_name"]];
        self.Lccp_shy_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_shy_amt"]];
        self.lccp_zrshy_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_zrshy_amt"]];
        
    }return self;
    
}

@end
