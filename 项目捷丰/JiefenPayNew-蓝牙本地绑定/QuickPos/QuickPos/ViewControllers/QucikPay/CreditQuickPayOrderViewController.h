//
//  CreditQuickPayOrderViewController.h
//  QuickPos
//
//  Created by feng Jie on 16/6/26.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderData,QuickBankItem;

@interface CreditQuickPayOrderViewController : UIViewController

@property (nonatomic,strong)OrderData *orderData;
@property (nonatomic,strong)QuickBankItem *bankCardItem;

@property (nonatomic,strong) NSString *bankName;
@property (nonatomic,strong) NSString *cardNums;
@property (nonatomic,strong) NSString *newbindid;
@property (nonatomic,strong) NSString *orderID;
@property (nonatomic,strong) NSString *customerId;
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *cardType;

@property (nonatomic,strong) NSString *CardValids;
@property (nonatomic,strong) NSString *SecurityCodes;
@end
