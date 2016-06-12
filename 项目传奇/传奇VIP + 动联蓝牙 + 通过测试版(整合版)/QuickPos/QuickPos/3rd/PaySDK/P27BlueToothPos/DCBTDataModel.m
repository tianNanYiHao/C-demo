//
//  DCBTDataModel.m
//  QuickPos
//
//  Created by Aotu on 16/6/6.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "DCBTDataModel.h"

@implementation DCBTDataModel



-(instancetype)initDCBTDataModelWithDict:(NSDictionary *)dict{
    
    _track3Length = [dict objectForKey:@"track3Length"];
    _expiryDate = [dict objectForKey:@"expiryDate"];
    _ksn = [dict objectForKey:@"ksn"];
    _mac = [dict objectForKey:@"mac"];
    _cardNum = [dict objectForKey:@"cardNum"];
    _cardSerial = [dict objectForKey:@"cardSerial"];
    _encTrack = [dict objectForKey:@"encTrack"];
    _track1Length = [dict objectForKey:@"track1Length"];
    _emvDataInfo = [dict objectForKey:@"emvDataInfo"];
    _cardType = [dict objectForKey:@"cardType"];
    _track2Length = [dict objectForKey:@"track2Length"];
    _randomNumber = [dict objectForKey:@"randomNumber"];
    _psamNo = [dict objectForKey:@"psamNo"];
    _pan    = [dict objectForKey:@"pan"];
    _encTrackAll = [dict objectForKey:@"encTrackAll"];
    _emv55DataInfo = [dict objectForKey:@"emv55DataInfo"];
    _encICAll = [dict objectForKey:@"encICAll"];
    _encTrack2 = [dict objectForKey:@"encTrack2"];
    
    
    return self;
}

@end
