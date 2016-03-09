//
//  ViewController.m
//  headerView 添加按钮点击
//
//  Created by Aotu on 15/12/23.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
        UIView *_uPView;
     UITableView *_tableview;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createVIEw];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 600)];
    _tableview.userInteractionEnabled = YES;
    _tableview.tableHeaderView = _uPView;
    _tableview.tableHeaderView.userInteractionEnabled = YES;
    [self.view addSubview:_tableview];
    
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    but.frame = CGRectMake(0, 0, 100, 100);
    but.backgroundColor = [UIColor orangeColor];
    [but addTarget:self action:@selector(bt) forControlEvents:UIControlEventTouchUpInside];
    [_uPView addSubview:but];
    
    
    
    
}
-(void)bt{
    NSLog(@"11111111");
}

-(void)createVIEw{
    
    _uPView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300,300)];
    _uPView.backgroundColor = [UIColor redColor];
    _uPView.userInteractionEnabled = YES;
    
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
