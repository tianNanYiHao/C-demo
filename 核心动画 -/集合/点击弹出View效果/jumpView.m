//
//  jumpView.m
//  点击弹出View效果
//
//  Created by Aotu on 16/2/1.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "jumpView.h"
@interface jumpView(){
    
}
@end



@implementation jumpView


-(id)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
    
        self.layer.backgroundColor = [UIColor orangeColor].CGColor;
        self.layer.frame = CGRectMake(0, 0, 50, 50);
        self.layer.position = CGPointMake(50, 50);
    }return self;
    
    
    
}

-(void)show{
    [CATransaction begin]; {

        
        // start the transform animation from its current value if it's already running
        NSValue *fromValue = [self.layer animationForKey:@"transform"] ? [self.layer.presentationLayer valueForKey:@"transform"] : [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
//        NSValue *fromVau = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1)];
        
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = fromValue;
        
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        [scaleAnim setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.8 :2.5 :0.35 :0.5]];
        scaleAnim.removedOnCompletion = NO;
        scaleAnim.fillMode = kCAFillModeForwards;
        scaleAnim.duration = 0.6;
        [self.layer addAnimation:scaleAnim forKey:@"transform"];
        
        CABasicAnimation* fadeInAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeInAnim.fromValue = [self.layer.presentationLayer valueForKey:@"opacity"];
        fadeInAnim.duration = 0.9;
        fadeInAnim.toValue = @1.0;
        [self.layer addAnimation:fadeInAnim forKey:@"opacity"];
        
        self.layer.opacity = 1.0;
    } [CATransaction commit];

}


-(void)hide
{
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            // remove the transform animation if the animation finished and wasn't interrupted
            if (self.layer.opacity == 0.0) [self.layer removeAnimationForKey:@"transform"];
//            [self.delegate popUpViewDidHide];
        }];
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [self.layer.presentationLayer valueForKey:@"transform"];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)];
        scaleAnim.duration = 0.6;
        scaleAnim.removedOnCompletion = NO;
        scaleAnim.fillMode = kCAFillModeForwards;
        [scaleAnim setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.1 :-2 :0.3 :3]];
        [self.layer addAnimation:scaleAnim forKey:@"transform"];
        
        CABasicAnimation* fadeOutAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOutAnim.fromValue = [self.layer.presentationLayer valueForKey:@"opacity"];
        fadeOutAnim.toValue = @0.0;
        fadeOutAnim.duration = 0.8;
        [self.layer addAnimation:fadeOutAnim forKey:@"opacity"];
        self.layer.opacity = 0.0;
    } [CATransaction commit];

}
@end
