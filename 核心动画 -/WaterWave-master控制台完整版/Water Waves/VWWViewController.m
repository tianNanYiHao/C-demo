//
//  VWWViewController.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWViewController.h"
#import "VWWWaterView.h"

@interface VWWViewController ()
{
    VWWWaterView *waterView;
}

@end

@implementation VWWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    waterView = [[VWWWaterView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:waterView];
    
    //初始化控制台
//    [self initSetPanel];
    
    //初始化波浪参数
    [self initWaveValue];
}

#pragma mark 初始化波浪参数
- (void)initWaveValue
{
    //公式中用到(起始幅度)
    waterView.wave = 1.5;
    //判断加减
    waterView.jia = NO;
    //幅度增长速度
    waterView.waveIncrease = 0.01;
    //减阈值 a
    waterView.waveMin = 5.0;
    //增阈值 a
    waterView.waveMax = 5.5;
    //b的增幅（速度控制）
    waterView.waveSpeed = 0.08;
    //起始Y值
    waterView.waveHeight = 350;
    //起始频率
    waterView.w = 180;
}

//#pragma mark 初始化控制台
//- (void)initSetPanel
//{
//    NSMutableArray *subViewArray = [[NSMutableArray alloc] init];
//    
//    //高度
//    [self setSliderDetail:0.0f maxNumValue:SCREEN_HEIGHT title:@"waveHeight" tag:kHeight_Tag subViewArray:subViewArray initValue:waterView.waveHeight];
//    //速度
//    [self setSliderDetail:0.0f maxNumValue:0.2f title:@"waveSpeed" tag:kSpeed_Tag subViewArray:subViewArray initValue:waterView.waveSpeed];
//    
//    //波浪幅度
//    [self setSliderDetail:0.0f maxNumValue:10.0f title:@"wave" tag:kWave_Tag subViewArray:subViewArray initValue:waterView.wave];
//    
//    //waveIncrease
//    [self setSliderDetail:0.0f maxNumValue:0.5f title:@"waveIncrease" tag:kWaveIncrease_Tag subViewArray:subViewArray initValue:waterView.waveIncrease];
//    //waveMin
//    [self setSliderDetail:0.0f maxNumValue:10.0f title:@"waveMin" tag:kWaveMin_Tag subViewArray:subViewArray initValue:waterView.waveMin];
//    //waveMax
//    [self setSliderDetail:0.0f maxNumValue:10.0f title:@"waveMax" tag:kWaveMax_Tag subViewArray:subViewArray initValue:waterView.waveMax];
//    //频率，周期
//    [self setSliderDetail:0.1f maxNumValue:360.0f title:@"周期，频率" tag:kWaveW_Tag subViewArray:subViewArray initValue:waterView.w];
//    
//    [UIView BearHorizontalAutoLay:subViewArray parentView:self.view offStart:200 offEnd:20 centerEqualParent:YES horizontalOrNot:NO offDistanceEqualViewDistance:NO];
//}
//
//- (void)setSliderDetail:(CGFloat)mininumValue maxNumValue:(CGFloat)maxNumValue title:(NSString *)title tag:(NSInteger)tag subViewArray:(NSMutableArray *)subViewArray initValue:(CGFloat)initvalue
//{
//    /**
//     ** 初始化参数
//     **/
//    CGFloat offX    = 15.0f;    //  左边距
//    CGFloat deltaX  = 10.0f;    //  间距
//    
//    //parentView
//    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    [self.view addSubview:parentView];
//    parentView.tag = tag;
//    [subViewArray addObject:parentView];
//    
//    //左侧label
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX, 0, 0, 0)];
//    label.text = title;
//    label.font = [UIFont systemFontOfSize:15.0f];
//    label.textColor = [UIColor blackColor];
//    [label sizeToFit];
//    [parentView addSubview:label];
//    [label setMyDirectionDistance:dir_Down destinationView:parentView parentRelation:YES distance:CGRectGetHeight(parentView.frame) center:NO];
//    
//    //初始化slider布局
//    CGFloat height = 10;
//    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake( deltaX, 0, SCREEN_WIDTH - offX - deltaX, height)];
//    slider.tag = tag;
//    slider.value = initvalue;
//    [parentView addSubview:slider];
//    [slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
//    [slider setMyCenter:dir_Vertical destinationView:nil parentRelation:YES];
//    
//    //显示数值的label
//    UILabel *showValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX + CGRectGetMaxX(label.frame), 0, 0, 0)];
//    showValueLabel.tag = showValueLableTag;
//    showValueLabel.text = [NSString stringWithFormat:@"%0.2f", initvalue];
//    showValueLabel.font = [UIFont systemFontOfSize:13.0f];
//    [showValueLabel sizeToFit];
//    [parentView addSubview:showValueLabel];
//    [showValueLabel setMyDirectionDistance:dir_Down destinationView:parentView parentRelation:YES distance:CGRectGetHeight(parentView.frame) center:NO];
//    
//    //设置slider参数
//    slider.minimumValue = mininumValue;
//    slider.maximumValue = maxNumValue;
//}
//
//#pragma mark 更新slider的值
//- (void)updateSliderValue:(UISlider *)slider
//{
//    switch (slider.tag) {
//        //更新高度
//        case kHeight_Tag:
//            waterView.waveHeight = slider.value;
//            break;
//            
//        //更新速度
//        case kSpeed_Tag:
//            waterView.waveSpeed = slider.value;
//            break;
//         
//        //波形幅度
//        case kWave_Tag:
//            waterView.wave = slider.value;
//            break;
//            
//        //更新幅度增长速度
//        case kWaveIncrease_Tag:
//            waterView.waveIncrease = slider.value;
//            break;
//            
//        case kWaveMin_Tag:
//            waterView.waveMin = slider.value;
//            //限定最大幅度和最小幅度符合逻辑
//            if (waterView.waveMax - waterView.waveMin < waveDelta) {
//                waterView.waveMax = waterView.waveMin + waveDelta;
//            }
//            break;
//            
//        case kWaveMax_Tag:
//            waterView.waveMax = slider.value;
//            //限定最大幅度和最小幅度符合逻辑
//            if (waterView.waveMax < waveDelta) {
//                waterView.waveMax = waveDelta;
//            }
//            if (waterView.waveMax - waterView.waveMin < waveDelta) {
//                waterView.waveMin = waterView.waveMax - waveDelta;
//            }
//            break;
//            
//        case kWaveW_Tag:
//            waterView.w = slider.value;
//            break;
//            
//        default:
//            break;
//    }
//    
//    return;
//}

@end



