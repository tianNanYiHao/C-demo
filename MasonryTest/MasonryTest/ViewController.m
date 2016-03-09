//
//  ViewController.m
//  MasonryTest
//
//  Created by Aotu on 15/12/1.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //1111111111111111111111
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:view];
//
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(300, 300));
//        
//    }];
    
    
    
    //22222222222222222222222
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view2];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(view2.mas_left).with.offset(-10);
        make.height.equalTo(@120);
        make.width.equalTo(view2);
        
    }];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.left.equalTo(view1.mas_right).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.width.equalTo(view1);
        make.height.equalTo(view1);
    }];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSURL *url = [NSURL URLWithString:@"www.baidu.com"];
//        NSError *error;
//        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
//        if (dataStr != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"the  str  is %@",dataStr);
//            });
//        }
//
//        
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
        NSError * error;
        NSString * data = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"call back, the data is: %@", data);
            });
        } else {
            NSLog(@"error when download:%@", error);
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
