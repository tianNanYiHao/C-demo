//
//  ViewController.m
//  segue中 如何传值
//
//  Created by Aotu on 15/12/25.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*
    
     
     
     
     
    实现：
    
    VIEW1.m
    
    添加下面的事件方法，该方法在视图跳转时被触发。
    -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
    {
        if([segue.identifier isEqualToString:@"goView2"]) //"goView2"是SEGUE连线的标识
        {
            id theSegue = segue.destinationViewController;
            [theSegue setValue:@"这里是要传递的值" forKey:@"strTtile"];
        }
    }
    
    VIEW2.h
    
    定义一个属性来接受SEGUE传递过来的值：
    @property(nonatomic,weak)NSString *strTtile;
    
    
    VIEW2.m
    @synthesize strTtile;
    ......
    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        NSLog(@"接收到的值为: %@",  strTtile);
    }

     
     
     
     
     
     
     
     
     
     
     
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
