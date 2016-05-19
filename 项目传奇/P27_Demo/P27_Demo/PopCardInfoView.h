//
//  PopCardInfoView.h
//  P27_Demo
//
//  Created by dc on 16/1/8.
//  Copyright © 2016年 爱笑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopCardInfoView : UIView

@property(strong, nonatomic)UITextView *cardInfo;
@property(strong, nonatomic)UIButton *closeButton;

- (void)setFrame;

@end
