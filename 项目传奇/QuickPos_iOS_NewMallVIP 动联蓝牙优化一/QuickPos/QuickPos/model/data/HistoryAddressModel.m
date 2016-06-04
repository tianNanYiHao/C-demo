//
//  HistoryAddressModel.m
//  QuickPos
//
//  Created by Aotu on 15/11/10.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "HistoryAddressModel.h"

@implementation HistoryAddressModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.nametext forKey:@"nametext"];
    [aCoder encodeObject:self.phonetext forKey:@"phonetext"];
    [aCoder encodeObject:self.addresstext forKey:@"addresstext"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.nametext = [aDecoder decodeObjectForKey:@"nametext"];
        self.phonetext = [aDecoder decodeObjectForKey:@"phonetext"];
        self.addresstext = [aDecoder decodeObjectForKey:@"addresstext"];
    }return self;
}

- (id)copyWithZone:(NSZone *)zone {
    HistoryAddressModel *copy = [[[self class] allocWithZone:zone] init];
    
    copy.nametext = [self.nametext copyWithZone:zone];
    copy.phonetext = [self.phonetext copyWithZone:zone];
    copy.addresstext = [self.addresstext copyWithZone:zone];
   
    return copy;
}
@end
