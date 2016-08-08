//
//  UITabBarCustemView.h
//  SFoofSave
//
//  Created by Lff on 16/8/3.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CustomTabBarSelectBtnBlock)(NSInteger index);



@interface UITabBarCustemView : UIView
@property (nonatomic,strong) UIImageView *tabBarBaseView;
@property (nonatomic,strong) UIButton       *centerBtn;
@property (nonatomic,strong) UIButton        *homeBtn;
@property (nonatomic,strong) UILabel          *homeLab;
@property (nonatomic,strong) UIButton        *myBtn;
@property (nonatomic,strong) UILabel          *myLab;

@property (nonatomic,strong)CustomTabBarSelectBtnBlock block;

-(instancetype)initWithFrame:(CGRect)frame CustomTabBarSelectBtnBlock:(CustomTabBarSelectBtnBlock)block;

@end
