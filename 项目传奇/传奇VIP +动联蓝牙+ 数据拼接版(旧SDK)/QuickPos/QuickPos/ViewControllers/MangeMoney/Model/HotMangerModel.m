//
//  HotMangerModel.m
//  QuickPos
//
//  Created by Aotu on 15/12/17.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "HotMangerModel.h"


@implementation HotMangerModel


-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if ([super init]) {
//        NSLog(@"lccp_amt!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",[[dict objectForKey:@"lccp_amt"] class]);
//        NSLog(@"lccp_date!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",[[dict objectForKey:@"lccp_date"] class]);
//        NSLog(@"lccp_id!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",[[dict objectForKey:@"lccp_id"] class]);
//        NSLog(@"lccp_name!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%@",[[dict objectForKey:@"lccp_name"] class]);
        
        
        self.lccp_amt = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_amt"]];
        self.lccp_date =[NSString stringWithFormat:@"%@",[dict objectForKey:@"lccp_date"]];
        self.lccp_id = [dict objectForKey:@"lccp_id"];
        self.lccp_name = [dict objectForKey:@"lccp_name"];
        self.lccp_rate = [dict objectForKey:@"lccp_rate"];
        
    }return self;
    
    
}






@end
