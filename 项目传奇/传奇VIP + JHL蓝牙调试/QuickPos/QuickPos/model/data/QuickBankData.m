//
//  QuickBankData.m
//  QuickPos
//
//  Created by 胡丹 on 15/4/9.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "QuickBankData.h"

@implementation QuickBankData

- (instancetype)initWithData:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.respCode = [[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"resultCode"];
        self.respDesc = [[[dict objectForKey:@"data"] objectForKey:@"result"] objectForKey:@"message"];

        if(!self.bankCardArr){
            self.bankCardArr = [[NSMutableArray alloc]init];
        }
        for (NSDictionary *item in [[dict objectForKey:@"data"] objectForKey:@"resultBean"]){
            QuickBankItem *quickItem = [[QuickBankItem alloc]initWithData:item];
            [self.bankCardArr addObject:quickItem];
        }
    }
    return self;
}


@end


@implementation QuickBankItem

- (instancetype)initWithData:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.bindID = [dict objectForKey:@"bindID"];
        self.cardNo = [dict objectForKey:@"cardNo"];
        self.bankName = [dict objectForKey:@"bankName"];
        self.iconUrl = [dict objectForKey:@"iconUrl"];
//        self.isBind = YES;
    }
    return self;
}

@end
