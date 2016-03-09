//
//  ViewController.m
//  点击弹出View效果
//
//  Created by Aotu on 16/2/1.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "jumpView.h"

@interface ViewController (){
    jumpView *_j;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _j = [[jumpView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    
    [self.view addSubview:_j];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)show:(id)sender {
    
    [_j show];
}
- (IBAction)hiden:(id)sender {
    [_j hide];
}

@end
