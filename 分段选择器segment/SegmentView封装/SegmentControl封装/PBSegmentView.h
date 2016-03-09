//
//  PBSegmentView.h
//  SegmentControl封装
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 彭彬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^segmentBlock)(NSInteger segmentNum , UIButton *btn);
@interface PBSegmentView : UIView

@property(nonatomic,copy)NSArray *itemArr;

@property(nonatomic,copy)segmentBlock segmentBlock;

-(id)initWithFrame:(CGRect)frame withTitleArr:(NSArray*)TitleArr;

- (void)setSelectImageName:(NSString *)selectImageName;

@end
