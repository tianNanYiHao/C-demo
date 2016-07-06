//
//  PaywayView.h
//  QuickPos
//
//  Created by kuailefu on 16/6/23.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol paywayViewDelegate
- (void)paywayViewFinishTag:(NSInteger )tag;
@end
@interface PaywayView : UIView
@property (nonatomic, assign) id<paywayViewDelegate> delegate;
@end
