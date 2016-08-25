//
//  ViewController.m
//  LFFPickerVIewDemo
//
//  Created by Lff on 16/8/22.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "ViewController.h"
#import "LFFPickerVIew.h"

@interface ViewController ()<LFFPickerViewDelegate>
{
    LFFPickerVIew *pickerView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];

    
    pickerView = [LFFPickerVIew awakeFromXib];
    //重置Frame 让xib加载东西   能够和当前的屏幕先对上  (xib的约束 只管xib内的视图的约束)
    pickerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
     pickerView.delegate = self;
    [self.view addSubview:pickerView];
    pickerView.alpha = 1;
}
#pragma mark - lffpickerviewdelegate
-(void)changeAlphaHiden{
    
    
    [UIView animateWithDuration:0.2 animations:^{
        pickerView.alpha = 0;
    }];
}
-(void)changeAlphaHiden:(NSString *)dateStr{
    
    if (pickerView.Timetype ==1) {
        
    }
    if (pickerView.Timetype == 2) {
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        pickerView.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
