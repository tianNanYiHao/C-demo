//
//  WChart.h
//  WChartView
//
//  Created by wangsen on 15/12/24.
//  Copyright © 2015年 wangsen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNChart;
typedef NS_ENUM(NSInteger, SNChartStyle) {
    SNChartStyleLine = 0, //柱状图
    SNChartStyleBar       //线状图
};

@protocol SNChartDataSource <NSObject>

@required
//配置y轴 数值数组 数值设置图表 y轴标题显示
- (NSArray *)chatConfigYValue:(SNChart *)chart;
//配置x轴 横坐标标题
- (NSArray *)chatConfigXValue:(SNChart *)chart;

@end

@interface SNChart : UIView
/**
 *  @author sen, 15-12-24 17:12:50
 *
 *  line  是否曲线
 */
@property (nonatomic, assign) BOOL curve;


//构造方法
- (instancetype)initWithFrame:(CGRect)frame withDataSource:(id<SNChartDataSource>)dataSource andChatStyle:(SNChartStyle)chartStyle;
//显示方法
- (void)showInView:(UIView *)view;

@end
