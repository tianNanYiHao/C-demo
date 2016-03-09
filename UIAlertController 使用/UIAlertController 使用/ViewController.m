//
//  ViewController.m
//  UIAlertController 使用
//
//  Created by Aotu on 15/12/8.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "typeEnum.h"
@interface ViewController ()
{
    NSUInteger _type;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(200, 200, 50, 50);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(t) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _type = BBBBBTYPE;
}

-(void)t{
    
    
    if (_type == AAAAATYPE) {
        
        //1
        UIAlertController *alertcontroller1 = [UIAlertController alertControllerWithTitle:@"提示AAAAA" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
        
        //2
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //2.1
            _type =BBBBBTYPE;
        }];
        
        //3
        [alertcontroller1 addAction:actionCancel];
        [alertcontroller1 addAction:actionSure];
        
        //4
        [self presentViewController:alertcontroller1 animated:YES completion:nil];
        
        _type = BBBBBTYPE;
    }
    else if(_type == BBBBBTYPE)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]<8) {
            NSLog(@"设备不支持ios7及以下系统");
        }else
        {
            
            UIAlertController *alertController= [UIAlertController alertControllerWithTitle:@"提示的标题 title" message:@"提示的消息 message" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *alertSureAction = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"enter sure in your click");
                _type = AAAAATYPE;
            }];
            
            [alertController addAction:alertAction];
            [alertController addAction:alertSureAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            
        }
    }
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
