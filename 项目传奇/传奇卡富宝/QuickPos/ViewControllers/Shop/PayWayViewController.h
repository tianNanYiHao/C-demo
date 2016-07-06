//
//  PayWayViewController.h
//  QuickPos
//
//  Created by Aotu on 16/6/24.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PayWayViewControllerBlock) (NSString *payWayTpye , UIView *view);


@interface PayWayViewController : UIViewController
@property (nonatomic,strong) NSString *payWay;
@property (nonatomic,strong) PayWayViewControllerBlock payWayViewControllerBlock;

-(void)getpayWayTypeWithBlock:(PayWayViewControllerBlock)block;



@end
