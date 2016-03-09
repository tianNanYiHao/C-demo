//
//  ViewController.m
//  核心动画-关键帧
//
//  Created by Aotu on 16/1/21.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#define angle2Radian(angle) ((angle)/180.0*M_PI)
@interface ViewController ()
{
    CALayer *_myLayer;
    UIImageView *_dogImageView;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor cyanColor];
    

    
    _myLayer = [CALayer layer];
    _myLayer.bounds = CGRectMake(0, 0, 50, 50);
    _myLayer.backgroundColor = [UIColor orangeColor].CGColor;
    _myLayer.position = CGPointMake(20,20);
    _myLayer.anchorPoint = CGPointMake(0, 0);
    _myLayer.cornerRadius = 25;
     [self.view.layer addSublayer:_myLayer];

    
    
    

    _dogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, 480/4, 1280/8)];
    _dogImageView.image = [UIImage imageNamed:@"69CC26D3-9441-4D7F-9003-5B9188442A44.jpg"];
    _dogImageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_dogImageView];
    
   
    
    
    
 
    
    
    
}

//1 使用 values 进行逐贞动画
-(void)touchesBegan1:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"position";
    keyAnimation.values = @[
                            [NSValue valueWithCGPoint:CGPointMake(20, 20)],
                            [NSValue valueWithCGPoint:CGPointMake(300, 200)],
                            [NSValue valueWithCGPoint:CGPointMake(100, 20)],
                            [NSValue valueWithCGPoint:CGPointMake(400, 104)],
                            [NSValue valueWithCGPoint:CGPointMake(40, 50)],
                            [NSValue valueWithCGPoint:CGPointMake(362, 623)],
                            [NSValue valueWithCGPoint:CGPointMake(212, 122)],
                            [NSValue valueWithCGPoint:CGPointMake(83, 122)]
                            ];
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.duration = 4.0;
    keyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]; //设置动画的节奏 不设置即平均分
    [_myLayer addAnimation:keyAnimation forKey:nil];
    
}


//2 使用path 让_mylayer在指定路径上画圆
-(void)touchesBegan2:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animation];
    pathAnimation.keyPath = @"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 30, 130));
    pathAnimation.path = path;
    CGPathRelease(path);
    
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.duration = 1.0;
    pathAnimation.repeatCount = 5;
    
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //慢进慢出
    
    //添加核心动画 
    [_myLayer addAnimation:pathAnimation forKey:@"liufeifei"];
    
    
    
    
    
}

//3 图标抖动
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CAKeyframeAnimation *douAnimation = [CAKeyframeAnimation animation];
    douAnimation.keyPath = @"transform.rotation";
    
    douAnimation.duration = 0.3;
    
    //设置图标抖动弧度
    //将度数转换为弧度,   弧度 = 度数/180*M_PI
    douAnimation.values = @[@(-angle2Radian(3)),
                            @(angle2Radian(3)),
                            @(-angle2Radian(3))
                            ];
    douAnimation.removedOnCompletion = NO;
    douAnimation.fillMode = kCAFillModeForwards;
    douAnimation.repeatCount = MAXFLOAT;
    douAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    
    [_dogImageView.layer addAnimation:douAnimation forKey:@"liufeifei"];
    [_myLayer addAnimation:douAnimation forKey:@"liufeifei"];
    

}


- (IBAction)btn:(id)sender {
    
    [_dogImageView.layer removeAnimationForKey:@"liufeifei"];
    [_myLayer removeAnimationForKey:@"liufeifei"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
