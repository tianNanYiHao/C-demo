//
//  HeadPhotoRotationViewController.m
//  HeadPhotoRotation
//
//  Created by Li Pan on 14-1-9.
//  Copyright (c) 2014年 Pan Li. All rights reserved.
//

#import "HeadPhotoRotationViewController.h"
#import "UIView+i7Rotate360.h"
@interface HeadPhotoRotationViewController ()

@end

@implementation HeadPhotoRotationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view. backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 头像
    _headImageView = [[UIImageView alloc] init];
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.frame = CGRectMake(100, 300, 100, 100);
    _headImageView.layer.cornerRadius = 50.0;
    _headImageView.layer.borderWidth = 1.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.image = [UIImage imageNamed:@"head1.jpg"];
    [self.view addSubview:_headImageView];
    
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"点击旋转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(actionRotation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionRotation:(UIButton *)button 
{
    [self performSelector:@selector(headPhotoAnimation) withObject:nil afterDelay:0.7];
}

- (void)headPhotoAnimation
{
    [_headImageView rotate360WithDuration:1.0 repeatCount:1 timingMode:i7Rotate360TimingModeLinear];
    _headImageView.animationDuration = 1.0;
    _headImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"head1.jpg"],
                                      [UIImage imageNamed:@"head2.jpg"],[UIImage imageNamed:@"head2.jpg"],
                                      [UIImage imageNamed:@"head2.jpg"],[UIImage imageNamed:@"head2.jpg"],
                                      [UIImage imageNamed:@"head1.jpg"], nil];
    _headImageView.animationRepeatCount = 1;
    [_headImageView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
