//
//  RechargeViewController.h
//  QuickPos
//
//  Created by Leona on 15/9/25.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *CartArr;
@property (nonatomic,strong)NSString *mobileNo;
@property (retain,nonatomic)NSDictionary *item;
@property (nonatomic,assign)BOOL isRechargeViewController;

@end
