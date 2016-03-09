//
//  ViewController.m
//  相机调用 第三方GKImageCropController
//
//  Created by Aotu on 16/1/8.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"




#import <AVFoundation/AVCaptureDevice.h>
#import <avfoundation/AVMediaFormat.h>


#import "GKImagePicker.h"
#import "GKImageCropViewController.h"



#define iOS8 [[[UIDevice currentDevice]systemVersion] floatValue]>=8

@interface ViewController ()<UIAlertViewDelegate,GKImageCropControllerDelegate,GKImagePickerDelegate,UIImagePickerControllerDelegate>
{
    GKImagePicker *_imagePicker;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(0, 0, 100, 100);
    [btn addTarget:self action:@selector(btn1) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:btn];
    
    
    
}
-(void)btn1
{
    
    if (iOS8) {
        //av授权状态                       //av捕获设备      //为Mdiad类型授权                //授权视频
        AVAuthorizationStatus avStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (avStatus == AVAuthorizationStatusRestricted || avStatus == AVAuthorizationStatusDenied) { //如果授权状态为 限制的 || 关闭的
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"⚠️" message:@"相机功能为授权应用,是否开启?" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"马上开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertControl addAction:action1];
            [alertControl addAction:action2];
            [self presentViewController:alertControl animated:YES completion:nil];
        }
        //        相机调用
        
        _imagePicker = [[GKImagePicker alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; //设置源类型 相机
        _imagePicker.cropSize = CGSizeMake(400, 400);  //设置照片大小?
        
        [self presentViewController:_imagePicker.imagePickerController animated:YES
                         completion:nil]; //模态切换到相机
        
        
        
        
    }else
    {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"⚠️" message:@"相机功能为授权应用,是否开启?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"马上开启", nil];
        [alerView show];
    }

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}

@end
