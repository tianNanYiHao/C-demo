//
//  ViewController.m
//  GCD
//
//  Created by Aotu on 15/12/9.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self createVIew];
            
        });
        
    });
    
    
    
    
    
    
    
    
    
    
    
}
-(void)createVIew
{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:View];
    View.backgroundColor = [UIColor orangeColor];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
