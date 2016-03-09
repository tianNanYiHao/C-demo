//
//  ViewController.m
//  核心动画 - Quartz2D 绘制基本图形
//
//  Created by Aotu on 16/1/22.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //0.创建图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0);
    
    //1.获取当前图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    //2.自己绘制想要的图 (在当前上下文 ref中 画 )
    CGContextAddEllipseInRect(ref, CGRectMake(0, 0, 45, 45));
    
    //3.渲染 (渲染图形上下文 ref)
    CGContextStrokePath(ref);
    
    //4.获取生成图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //5.图片转为data
    NSData *data = UIImagePNGRepresentation(image);
    
    //6.导出文件 png
    [data writeToFile:@"/Users/Aotu/Desktop/aaaaaaaaa.png" atomically:YES];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
