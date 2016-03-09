//
//  VWWWaterView.h
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWWaterView : UIView

//公式中用到(起始幅度)
@property (assign, nonatomic) float wave;
//判断加减
@property (assign, nonatomic) BOOL jia;
//幅度增长速度
@property (assign, nonatomic) float waveIncrease;
//幅度最小值
@property (assign, nonatomic) float waveMin;
//幅度最大值
@property (assign, nonatomic) float waveMax;
//波浪增幅的速度控制
@property (assign, nonatomic) float waveSpeed;
//起始高度，y值
@property (assign, nonatomic) float waveHeight;
//w
@property (assign, nonatomic) float w;

@end
