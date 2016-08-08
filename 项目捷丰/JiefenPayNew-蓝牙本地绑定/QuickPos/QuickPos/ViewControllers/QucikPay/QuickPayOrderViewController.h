//
//  QuickPayOrderViewController.h
//  QuickPos
//
//  Created by 胡丹 on 15/4/8.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderData,QuickBankItem;


@interface QuickPayOrderViewController : UIViewController
@property (nonatomic,strong)OrderData *orderData;
@property (nonatomic,strong)QuickBankItem *bankCardItem;

@property (nonatomic,strong) NSString *bankName;
@property (nonatomic,strong) NSString *cardNums;
@property (nonatomic,strong) NSString *newbindid;
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,strong) NSString *customerId;
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *cardType;


@end
