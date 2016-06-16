//
//  LianDiBlueToothVpos.h
//  QuickPos
//
//  Created by kuailefu on 16/2/24.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@protocol LianDiBlueToothVposDelegate<NSObject>
-(void)posResponseDataWithCardInfoModelWithLianDi:(CardInfoModel *)cardInfo;
@end

@interface LianDiBlueToothVpos : UIViewController
@property(nonatomic, weak)id<LianDiBlueToothVposDelegate> delegate;
@property (nonatomic, strong) CardInfoModel *CardInfo;
@property (nonatomic, strong) NSString *moneyNum;
- (void) initWithMoney:(NSString*)Num;
@end
