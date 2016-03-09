//
//  ViewController.m
//  SegmentControl封装
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 彭彬. All rights reserved.
//

#import "ViewController.h"

#import "PBSegmentView.h"

#define kScreenW   [UIScreen mainScreen].bounds.size.width

#define kScreenH   [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSegmentView];
    
}

-(void)creatSegmentView
{
    PBSegmentView *sengMent = [[PBSegmentView alloc]initWithFrame:CGRectMake(0, 100, kScreenW/4.0*8, 45) withTitleArr:@[@"第一页☝️",@"第二页2⃣️",@"第三页3⃣️",@"第四页4⃣️",@"第五页5⃣️",@"第六页6⃣️",@"第七页7⃣️",@"第八页8⃣️",@"第九页9⃣️"]];
    
    sengMent.backgroundColor = [UIColor blackColor];
    
    [sengMent setSelectImageName:@"color_line"];
    
    __weak PBSegmentView *weakSengment = sengMent;
    
    [sengMent setSegmentBlock:^(NSInteger segmentNum, UIButton *btn) {
        
        __strong PBSegmentView *strongSengment = weakSengment;
        
        if (segmentNum == 0)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor whiteColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(0, 100, kScreenW/4.0*8, 45);
            }];
        }
        else if (segmentNum == 1)
        {
            [UIView animateWithDuration:.35 animations:^{
                 self.view.backgroundColor = [UIColor redColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(0, 100, kScreenW/4.0*8, 45);
            }];
        }
        else if (segmentNum == 2)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor grayColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(0, 100, kScreenW/4.0*8, 45);
            }];
        }
        else if (segmentNum == 3)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor greenColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(-kScreenW/4.0, 100, kScreenW/4.0*8, 45);
            }];
        }else if (segmentNum == 4)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor purpleColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(-kScreenW/4.0*2, 100, kScreenW/4.0*8, 45);
            }];
        }else if (segmentNum == 5)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor cyanColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(-kScreenW/4.0*3, 100, kScreenW/4.0*8, 45);
            }];
        }else if (segmentNum == 6)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor brownColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(-kScreenW/4.0*4, 100, kScreenW/4.0*8, 45);
            }];
        }else if (segmentNum == 7)
        {
            [UIView animateWithDuration:.35 animations:^{
                self.view.backgroundColor = [UIColor whiteColor];//此方法内可以放动画
                strongSengment.frame = CGRectMake(-kScreenW/4.0*4, 100, kScreenW/4.0*8, 45);
            }];
        }

        
    }];
    
    [self.view addSubview:sengMent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
