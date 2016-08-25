//
//  ViewController.m
//  LFFPickerVIewDemo
//
//  Created by Lff on 16/8/22.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "ViewController.h"
#import "LFFPickerVIew.h"

@interface ViewController ()
{
    LFFPickerVIew *pickerView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    pickerView = [LFFPickerVIew awakeFromXib];
    //重置Frame 让xib加载东西   能够和当前的屏幕先对上  (xib的约束 只管xib内的视图的约束)
    pickerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self.view addSubview:pickerView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
