//
//  ViewController.m
//  声音震动+相机权限
//
//  Created by Aotu on 16/6/30.
//  Copyright © 2016年 Aotu. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


#define SoundID 1317
@interface ViewController (){

}
@property (weak, nonatomic) IBOutlet UITextField *soundtextfiled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UIView *v in self.view.subviews) {
        if ([v isKindOfClass:[UITextField class]]) {
            UITextField *t = (UITextField*)v;
            [t resignFirstResponder];
        }
        
    }
}

// 点击发出系统音
- (IBAction)sound:(id)sender {
  
    AudioServicesPlaySystemSound([_soundtextfiled.text intValue]);
    
}
// 点击触发系统震
- (IBAction)vibration:(id)sender {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
//点击检测相机权限
- (IBAction)camera:(id)sender {
    
    //ios7之前系统默认拥有权限
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            _soundtextfiled.placeholder = @"您还未为本App开通相机权限";
        }else{
            _soundtextfiled.placeholder = @"本App拥有相机开启权限";
        }
    }
    
}
// 点击检测相册权限
- (IBAction)photo:(id)sender {
    //iOS8 以下系统默认有权限
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        ALAuthorizationStatus authStates = [ALAssetsLibrary authorizationStatus];
        if ( authStates ==  ALAuthorizationStatusDenied) {
            _soundtextfiled.placeholder = @"您没有访问相册的权限";
        }
        else{
            _soundtextfiled.placeholder = @"您拥有访问相册的权限";
        }
    }
}
@end
