//
//  ViewController.m
//  CarbuyLff
//
//  Created by Lff on 16/12/14.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "ViewController.h"
#import "CarBuyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)enterShoppingCar:(id)sender {
    CarBuyViewController *v = [[CarBuyViewController alloc] initWithNibName:@"CarBuyViewController" bundle:nil];
    [self.navigationController pushViewController:v animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
