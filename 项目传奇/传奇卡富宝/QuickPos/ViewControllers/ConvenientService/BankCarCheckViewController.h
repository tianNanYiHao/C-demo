//
//  BankCarCheckViewController.h
//  QuickPos
//
//  Created by kuailefu on 16/6/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Request.h"
#import "MBProgressHUD.h"
#import "Common.h"

@protocol BankCarCheckDelegate <NSObject>

- (void)finishCheck:(NSString *)str;

@end


@interface BankCarCheckViewController : UIViewController
@property (nonatomic, assign) id<BankCarCheckDelegate> delegate;
@property (nonatomic, strong) NSString *carNum;

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *idcard;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextF;




@end
