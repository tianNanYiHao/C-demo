//
//  ViewController.m
//  UIViewDrawDemo
//
//  Created by tianNanYiHao on 2017/5/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "ViewController.h"
#import "view.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    view *v = [[view alloc] initWithFrame:self.view.bounds];
    v.backgroundColor = [UIColor greenColor];
    [self.view addSubview:v];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
