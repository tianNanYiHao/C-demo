//
//  ViewController.m
//  ACEDrawingViewTest
//
//  Created by Aotu on 16/6/28.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "ACEDrawingView.h"

#import "Utils.h"

@interface ViewController ()<ACEDrawingViewDelegate>
@property (nonatomic,strong) ACEDrawingView *V;
@property (nonatomic,strong) UIImageView *showImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _V = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    _V.delegate = self;
    _V.lineWidth = 9.0;
    _V.lineColor = [UIColor whiteColor];
    _V.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:_V];
    
    
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 50, 50)];
    [_V addSubview:_showImageView];
    
    
    
}


- (IBAction)clearBtn:(id)sender {
    [_V clear];
    
}


- (IBAction)saveBtn:(id)sender {
    _showImageView.image = _V.image;
    [self channgeASII:_V.image];
}

//获取图片后 的一些处理  更具后台需求
-(void)channgeASII:(UIImage*)img{
    NSData *imgData = [NSData dataWithData:UIImagePNGRepresentation(img)];
    NSLog(@"imgData ===== is %@",imgData);
    
    //md5加密 ( D91D783DC491E66F85A835C472A953AB )
    NSString *imgStringMD5 = [Utils md5WithData:imgData];
    NSLog(@"imgStringMD5  is %@",imgStringMD5);
    
    
    NSMutableString *handsignString = [NSMutableString stringWithCapacity:([imgData length] * 2)];
    const unsigned char *dataBuffer = (unsigned char *) [imgData bytes];
    for (int i = 0; i < [imgData length]; ++i) {
        [handsignString appendFormat:@"%02X", (unsigned) dataBuffer[i]];
    }
    
    NSLog(@"handsignString is %@",handsignString);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
