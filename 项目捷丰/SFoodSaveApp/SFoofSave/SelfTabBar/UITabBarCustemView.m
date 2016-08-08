//
//  UITabBarCustemView.m
//  SFoofSave
//
//  Created by Lff on 16/8/3.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "UITabBarCustemView.h"

#define ScrenHeight self.frame.size.height
#define ScrenWidth self.frame.size.width
#define SelectColor [[UIColor alloc] initWithRed:112/255.0 green:156/255.0 blue:72/255.0 alpha:1.0]
#define NormalColor [[UIColor alloc] initWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]

@implementation UITabBarCustemView

- (instancetype) initWithFrame:(CGRect)frame CustomTabBarSelectBtnBlock:(CustomTabBarSelectBtnBlock)block{
    if (self = [super initWithFrame: frame]) {
        self.frame = frame;
        _block = block;
        self.userInteractionEnabled = YES;
        [self layoutView];
    }return self;
}


- (void)layoutView{
    
    
    //1背景view
    _tabBarBaseView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"底部标签栏"]];
    _tabBarBaseView.userInteractionEnabled = YES;
//    _tabBarBaseView.frame = CGRectMake(0,0,ScrenWidth, ScrenHeight);
    [self addSubview:_tabBarBaseView];
    
    [_tabBarBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(71);
        make.width.mas_offset(self.frame.size.width);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];

    //2centerBtn
    _centerBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _centerBtn.adjustsImageWhenHighlighted = YES;
    [_centerBtn setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [_centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.tag = 2;
    [self addSubview:_centerBtn];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(96);
        make.width.mas_offset(96);
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
    }];
    
    
    //3homeBtn
    _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homeBtn setImage:[UIImage imageNamed:@"首页-正常"] forState:UIControlStateNormal];
    [_homeBtn setImage:[UIImage imageNamed:@"首页-选中"] forState:UIControlStateSelected];
    [_homeBtn addTarget:self action:@selector(homeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _homeBtn.selected = YES;
    _homeBtn.tag = 1;
    [self addSubview:_homeBtn];
    [_homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(56);
        make.width.mas_offset(50);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-_tabBarBaseView.frame.size.width/4);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
    }];
    //homeBtn.下标文字
    _homeLab = [[UILabel alloc] init];
    _homeLab.text = @"首页";
    _homeLab.textAlignment = NSTextAlignmentCenter;
    _homeLab.textColor = SelectColor;  //selected
    [self addSubview:_homeLab];
    _homeLab.font = [UIFont systemFontOfSize:12];
    [_homeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(12);
        make.width.mas_offset(50);
        make.centerX.mas_equalTo(self.mas_centerX).offset(-_tabBarBaseView.frame.size.width/4);
        make.bottom.mas_equalTo(_homeBtn.mas_bottom).offset(0);
    }];
    
    
    
    
    //4myBtn
    _myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myBtn setImage:[UIImage imageNamed:@"我的-正常"] forState:UIControlStateNormal];
    [_myBtn setImage:[UIImage imageNamed:@"我的-选中"] forState:UIControlStateSelected];
    [_myBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _myBtn.selected = NO;
    _myBtn.tag = 3;
    [self addSubview:_myBtn];
    [_myBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(56);
        make.width.mas_offset(50);
        make.centerX.mas_equalTo(self.mas_centerX).offset(_tabBarBaseView.frame.size.width/4);
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
    }];
    //myBtn.下标文字
    _myLab = [[UILabel alloc] init];
    _myLab.text = @"我的";
    _myLab.textAlignment = NSTextAlignmentCenter;
    _myLab.textColor =  NormalColor; // not selected
    [self addSubview:_myLab];
    _myLab.font = [UIFont systemFontOfSize:12];
    [_myLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(12);
        make.width.mas_offset(50);
        make.centerX.mas_equalTo(self.mas_centerX).offset(_tabBarBaseView.frame.size.width/4);
        make.bottom.mas_equalTo(_homeBtn.mas_bottom).offset(0);
    }];
    
}

#pragma  mark - 按钮方法
- (void)centerBtnClick:(UIButton*)btn{
    _block(_centerBtn.tag);
}

- (void)homeBtnClick:(UIButton*)btn{
    _block(_homeBtn.tag);
    _myBtn.selected = NO;
    _myLab.textColor = NormalColor;
    
    if (btn.selected) {
    }
    else{
        _homeBtn.selected = YES;
        _homeLab.textColor = SelectColor;
    }
    
}

- (void)myBtnClick:(UIButton*)btn{
    _block(_myBtn.tag);
    _homeBtn.selected = NO;
    _homeLab.textColor = NormalColor;
    
    if (btn.selected) {
    }
    else{
        _myBtn.selected = YES;
        _myLab.textColor = SelectColor;
    }
}

@end
