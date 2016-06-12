//
//  OrderData.h
//  QuickPos
//
//  Created by 胡丹 on 15/3/20.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseData.h"

@interface OrderData : BaseData

@property(nonatomic,strong)NSString *orderId;//订单编号
@property(nonatomic,strong)NSString *orderAmt;//订单金额
@property(nonatomic,strong)NSString *orderDesc;//订单详情
@property(nonatomic,strong)NSString *realAmt;//实际交易金额
@property(nonatomic,strong)NSString *orderAccount;//交易账号
@property(nonatomic,assign)NSUInteger orderPayType;//账户支付 刷卡支付
@property(nonatomic,strong)NSString *orderTranslogNo;  //交易流水号
@property(nonatomic,strong)NSString *merchantId;
@property(nonatomic,strong)NSString *productId;

@property(nonatomic,assign)BOOL mallOrder;

@end
