//
//  ViewController.m
//  进度条使用
//
//  Created by Aotu on 16/3/8.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "TYMProgressBarView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TYMProgressBarView *vi = [[TYMProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    vi.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:vi];
    vi.barFillColor = [UIColor greenColor];
    vi.barBorderWidth = 1;
    vi.barInnerBorderWidth = 10;
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
