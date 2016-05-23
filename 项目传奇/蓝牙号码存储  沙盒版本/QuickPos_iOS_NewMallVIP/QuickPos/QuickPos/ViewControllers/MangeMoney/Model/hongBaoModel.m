//
//  hongBaoModel.m
//  QuickPos
//
//  Created by Aotu on 16/1/13.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "hongBaoModel.h"

@implementation hongBaoModel


-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        
        self.lccp_hb_amt = [dict objectForKey:@"lccp_hb_amt"];
        self.enddate = [dict objectForKey:@"enddate"];
        self.startdate = [dict objectForKey:@"startdate"];
        self.lccp_hb_name = [dict objectForKey:@"lccp_hb_name"];
        self.lccp_hb_id = [dict objectForKey:@"lccp_hb_id"];
        self.num = [NSString stringWithFormat:@"%@",[dict objectForKey:@"num"]];

    }
    
    return self;
    
    
}
@end
