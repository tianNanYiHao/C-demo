//
//  ViewController.m
//  核心动画 - 转场动画 组动画
//
//  Created by Aotu on 16/1/22.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *dogimage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CABasicAnimation *a1= [CABasicAnimation animation];
    a1.keyPath = @"transform.translation.y";
    a1.toValue = @(100);
    
    CABasicAnimation *a2 = [CABasicAnimation animation];
    a2.keyPath = @"transform.translation.x";
    a2.toValue = @(105);
    
    CABasicAnimation *a3 = [CABasicAnimation animation];
    a3.keyPath = @"transform.scale";
    a3.toValue = @(0.2);
    
    
    CABasicAnimation *a4 = [CABasicAnimation animation];
    a4.keyPath = @"transform.rotation";
    a4.toValue = @(2*M_PI);
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    
    groupAnimation.animations = @[a1,a2,a3,a4];
    
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.duration = 1;
    groupAnimation.repeatCount = MAXFLOAT;
    
    [_dogimage.layer addAnimation:groupAnimation forKey:@"1"];
    

}





- (IBAction)btn:(id)sender {
    
    
    [_dogimage.layer removeAnimationForKey:@"1"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fier:"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
