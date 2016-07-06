//
//  TradePwdView.h
//  QuickPos
//
//  Created by kuailefu on 16/6/7.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@protocol TradePwdViewDelegate <NSObject>

@optional
/** 输入完成点击确定按钮 */
- (void)tradePwdfinish:(NSString *)pwd;
@end

@interface TradePwdView : UIView
@property (nonatomic, weak) id<TradePwdViewDelegate> delegate;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UILabel *amountMoney;
@end
