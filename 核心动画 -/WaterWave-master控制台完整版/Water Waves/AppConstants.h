//
//  AppConstants.h
//  Water Waves
//
//  Created by zmit on 15/9/2.
//  Copyright (c) 2015年 Veari. All rights reserved.
//

typedef enum kSliderTag{
    kHeight_Tag             = 11,
    kSpeed_Tag              = 12,
    kWave_Tag               = 13,
    kWaveIncrease_Tag       = 16,
    kWaveMin_Tag            = 17,
    kWaveMax_Tag            = 18,
    kWaveW_Tag              = 19,
    
}SliderTag;

#define showValueLableTag   10

#define waveDelta 0.01

//  当前屏幕宽度
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
//  当前屏幕高度
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
//  tabbar高度
#define TABBAR_HEIGHT   self.tabBarController.tabBar.frame.size.height
//  状态栏高度
#define STATUS_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
//  Navigationbar高度
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height
//  判断系统版本
#define iOS8Over [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0

