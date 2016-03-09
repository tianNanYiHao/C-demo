//
//  ViewController.m
//  NSURLSession 练习一
//
//  Created by Aotu on 16/3/9.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/747/747488.jpg"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            
            NSLog(@"request == %@",request);
            
            NSLog(@"data  == %@",data);
            
            NSLog(@"response == %@",response);
            
            NSLog(@"error == %@",error);
            if (error == nil) {
                
                NSLog(@"===================================================================");
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"dataStr =====>>>  %@ ",dataStr);

                //返回主线程刷新ui
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImage *image = [UIImage imageWithData:data];
                    
                    _imageView.image = image;

                });
            }

        }];
        
        [task resume];
    });
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
