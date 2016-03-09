//
//  ViewController.m
//  iOS - Block学习
//
//  Created by Aotu on 16/2/26.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int ABC;
    
}
@property (nonatomic,strong) NSString * abcd;

@end

@implementation ViewController


//定义在外部的无参数 无返回 的block
void (^notInside)() = ^(){
    NSLog(@"我是定义在外部的block");
};




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
    //1.定义一个无返回 参数为 int a 的名字为 printF 的 block
    void (^printF)(int a) = ^(int a){

        NSLog(@"%d",a);
        
        void (^nslog)(float b) = ^(float c){
          
            NSLog(@"%.2f",c);
        };
        
        nslog(2.2);

    };
    
    printF(9);
    printF (123);
    
    
    //2.定义了一个无返回 无参数的名字为 noback 的 block
    void (^noback)() = ^(){
      
        NSLog(@"no back anything");
    };
    
    noback();
    noback(9);
    

    //3.定义一个返回int  参数int 的名字为 getBack 的block
    int (^getBack)(int d) = ^(int c){
         NSLog(@"%d",c*1);
        return c*1;
       
    };
    getBack(100);
    
    
    //定义在外部的函数
    notInside();
    
    
    
    _abcd = @"22";
    
   __block int abcd = 22;
    

    int (^changeABV)(int d) = ^(int c){

        abcd = abcd*c;
        _abcd = [NSString stringWithFormat:@"%d", [_abcd intValue]*c];
       
        NSLog(@"%d",abcd);
        return abcd;
        
    };

    changeABV(4);
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
