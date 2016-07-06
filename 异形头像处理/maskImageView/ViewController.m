//
//  ViewController.m
//  maskImageView
//
//  Created by Aotu on 16/7/5.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
@interface ViewController ()
{
    
}
@property (nonatomic,strong)UIImageView *imageHeadView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor orangeColor];

    self.imageHeadView.frame = CGRectMake(30, 30, 60, 60);
    
    self.imageHeadView.image  = [UIImage imageNamed:@"22"];
    [self.view addSubview:self.imageHeadView];
    
    
}


-(UIImageView*)imageHeadView{
    
    if (!_imageHeadView) {
        _imageHeadView = [self headImage];
    }
    return _imageHeadView;
}


-(UIImageView*)headImage{
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_icon_tx_kb"]];
    UIImageView *imageMaskV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_icon_txwk1"]];
       [imageV addSubview:imageMaskV];
    [imageMaskV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageV);
    }];
    
    
    
    [imageMaskV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageV).insets(UIEdgeInsetsZero);
    }];
 
    return imageV;

}

    
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
