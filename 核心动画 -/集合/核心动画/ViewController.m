//
//  ViewController.m
//  核心动画
//
//  Created by Aotu on 16/1/20.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@property (nonatomic,strong)CALayer *myLayer;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor cyanColor];
    
    _myLayer = [CALayer layer];
    _myLayer.bounds = CGRectMake(0, 0, 100, 100);
    _myLayer.backgroundColor = [UIColor orangeColor].CGColor;
    _myLayer.position = CGPointMake(20, 20);
    _myLayer.anchorPoint = CGPointMake(0,0);  //描点 默认在0.5,0.5 ===>>>> 需要移到左上角
    _myLayer.cornerRadius = 26;
    
    
    [self.view.layer addSublayer:_myLayer];
    
    
    
    
    
}
//设置动画
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1 基础动画
    CABasicAnimation *basAnimation = [CABasicAnimation animation];
    
    //1.1告诉系统要执行什么样的动画
//    basAnimation.keyPath = @"position";  //基础位移动画
//    basAnimation.keyPath = @"bounds";    //基础形变动画
    basAnimation.keyPath = @"transform";   //基础旋转动画
    
    
    //动画执行时间
    basAnimation.duration = 2.0;
    
    //设置通过动画，将layer从哪儿移动到哪儿
//    basAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//    basAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 100)];
    
//    basAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 221, 103)];
//    basAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 123, 321)];

    
    basAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 100, 1)];
    
    
    
    //1.2设置动画执行完毕之后不删除动画
    basAnimation.removedOnCompletion = NO;
    
    //1.3设置保存动画的最新状态
    basAnimation.fillMode = kCAFillModeForwards;
    

    
    
    basAnimation.delegate = self;
    
    NSLog(@"%@",NSStringFromCGPoint(_myLayer.position));
 
    //2.添加核心动画到layer
    [_myLayer addAnimation:basAnimation forKey:nil];
}

-(void)animationDidStart:(CAAnimation *)anim
{
    
    NSLog(@"开始执行动画");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"动画执行结束%@",NSStringFromCGPoint(_myLayer.position));
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
