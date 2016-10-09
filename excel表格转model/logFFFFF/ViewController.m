//
//  ViewController.m
//  logFFFFF
//
//  Created by Lff on 16/10/9.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "ViewController.h"
#import "AddressModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    TrickInfoModel *model = [[TrickInfoModel alloc]init];
     NSArray *arr =  [model getInfoBack];
    NSLog(@"%@",arr);
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
