//
//  MyAccountGaikuangModel.m
//  QuickPos
//
//  Created by Aotu on 16/1/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "MyAccountGaikuangModel.h"

@implementation MyAccountGaikuangModel

-(instancetype)initWithDict:(NSDictionary*)dict
{
    if (self == [super init]) {
        self.lczzch = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"lczzch"] floatValue]/100];
        self.hbgsh = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"hbgsh"] floatValue]];
        self.ktxye = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"ktxye"] floatValue]/100];
        self.hyjf = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"hyjf"] floatValue]];
    }return self;
    
    
    
    
}

@end
