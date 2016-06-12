//
//  DCBlueToothManager.h
//  P27BlueToothPosManager
//
//  Created by Aotu on 16/5/26.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardInfoModel.h"
enum{
    ICCard,     //IC卡返回信息
    TrackCard,  //磁条卡返回信息
};

enum{
    FirstSearch,    //第一次获取蓝牙失败
    NotFirstSearch,
};
@protocol DCBlueToothManagerDelegate <NSObject>

-(void)dcBlueToothManagerResponseByCardInfo:(CardInfoModel *)cardInfo;




@end


@interface DCBlueToothManager : NSObject
@property (nonatomic,strong) NSString *orderId;
@property (nonatomic,strong) NSString *transLogo;
@property (nonatomic,assign) NSInteger cash;



@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,weak) id<DCBlueToothManagerDelegate> delegate;

+(instancetype)getDCBlueToothManager;


//搜索蓝牙
-(void)searchDCBlueTooth;

//停止搜索
-(void)disConnectDCBlueTooth;

//取消刷卡
-(void)cancleSwipeCard;


@end
