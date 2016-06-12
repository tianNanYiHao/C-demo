//
//  DCBTDataModel.h
//  QuickPos
//
//  Created by Aotu on 16/6/6.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

//0 磁条卡 1 芯片卡
@interface DCBTDataModel : NSObject

@property (nonatomic,strong) NSString * track3Length;    //3磁数据
@property (nonatomic,strong) NSString * expiryDate;      //有效期
@property (nonatomic,strong) NSString * ksn;             //ksn
@property (nonatomic,strong) NSString * mac;             //mac
@property (nonatomic,strong) NSString * cardNum;         //卡号
@property (nonatomic,strong) NSString * cardSerial;
@property (nonatomic,strong) NSString * encTracks;
@property (nonatomic,strong) NSString * track1Length;    //1磁数据
@property (nonatomic,strong) NSString * emvDataInfo;     //55??域数据
@property (nonatomic,strong) NSString * cardType;        //卡类型
@property (nonatomic,strong) NSString * track2Length;    //2磁数据
@property (nonatomic,strong) NSString * randomNumber;    //随即数
@property (nonatomic,strong) NSString * psamNo;          //psam号
@property (nonatomic,strong) NSString * pan;             //加密的卡号;



-(instancetype)initDCBTDataModelWithDict:(NSDictionary*)dict;


@end
