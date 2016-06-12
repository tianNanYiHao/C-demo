//
//  mallViewController.h
//  QuickPos
//
//  Created by 张倡榕 on 15/3/9.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderData;

@interface MallViewController : UIViewController

@property (nonatomic,strong)OrderData *orderData;

@property (nonatomic,strong) NSString *orangerMoney;

@property (retain, nonatomic) NSDictionary *item;


@end
