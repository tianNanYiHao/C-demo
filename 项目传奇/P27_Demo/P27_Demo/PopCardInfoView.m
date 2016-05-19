//
//  PopCardInfoView.m
//  P27_Demo
//
//  Created by dc on 16/1/8.
//  Copyright © 2016年 爱笑. All rights reserved.
//

#import "PopCardInfoView.h"

@implementation PopCardInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //NSLog(@"frame = %@",NSStringFromCGRect(frame));
    }
    return self;
}

- (void)setFrame
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.cardInfo = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.cardInfo];
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    //按钮的位置要在这个view初始化的frame范围内
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 20)];
    [self.closeButton setImage:closeImage forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
}

@end
