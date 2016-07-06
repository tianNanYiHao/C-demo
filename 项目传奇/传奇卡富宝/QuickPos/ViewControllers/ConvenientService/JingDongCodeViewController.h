//
//  JingDongCodeViewController.h
//  QuickPos
//
//  Created by kuailefu on 16/6/28.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderData.h"

@interface JingDongCodeViewController : UIViewController
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) OrderData *orderData;
@end
