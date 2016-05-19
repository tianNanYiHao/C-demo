//
//  PopTableView.m
//  P27_Demo
//
//  Created by dc on 16/1/4.
//  Copyright © 2016年 爱笑. All rights reserved.
//

#import "PopTableView.h"


@interface PopTableView ()

@end

@implementation PopTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //NSLog(@"frame = %@",NSStringFromCGRect(frame));
    }
    return self;
}

- (void)setFrame
{
    self.backgroundColor = [UIColor whiteColor];
    
    //主意初始化控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.alpha = 0.5;
  
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.tableView];
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    //按钮的位置要在这个view初始化的frame范围内
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 20)];
    [self.closeButton setImage:closeImage forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
}

@end
