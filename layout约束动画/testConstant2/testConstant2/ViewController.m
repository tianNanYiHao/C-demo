//
//  ViewController.m
//  testConstant2
//
//  Created by Lff on 16/12/2.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *chongjiboView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topCons.constant = -300;
//    [self.chongjiboView setTranslatesAutoresizingMaskIntoConstraints:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:2.0 animations:^{
        self.topCons.constant = 300;
        [UIView setAnimationRepeatCount:88];
        [self.view layoutIfNeeded];
    }];
}


@end
