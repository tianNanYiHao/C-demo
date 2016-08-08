//
//  ComplaintViewController.m
//  QuickPos
//
//  Created by Lff on 16/8/1.
//  Copyright © 2016年 张倡榕. All rights reserved.
//http://www.jianshu.com/p/e70a184d1f32

#import "ComplaintViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ComplaintViewController ()<ResponseData,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    NSMutableArray  *_dataArray;
    Request *_rep;
    UIImagePickerController *_imagePickerController;
}
@property (weak, nonatomic) IBOutlet UIView *BGview1;//模块1
@property (weak, nonatomic) IBOutlet UIView *BGview2;
@property (weak, nonatomic) IBOutlet UIView *BGview3;


@property (weak, nonatomic) IBOutlet UITextField *nameProduct;
@property (weak, nonatomic) IBOutlet UITextField *sizeProduct;
@property (weak, nonatomic) IBOutlet UITextField *dateProduct;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UILabel *photoLab;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageShoew;

@end

@implementation ComplaintViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.x = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"投诉建议";
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _rep = [[Request alloc] initWithDelegate:self];

    [self setImagePickerController];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setImagePickerController{
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate  = self;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

}

//相机/相册
- (IBAction)cameraGetBtn:(id)sender {

    [Common pstaAlertWithTitle:@"提示" message:@"请选择图片来源方式" defaultTitle:@"相册" cancleTitle:@"相机" defaultBlock:^(id defaultBlock) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePickerController animated:YES completion:nil];

    } CancleBlock:^(id cancleBlock) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.videoMaximumDuration = 10;
        _imagePickerController.mediaTypes = @[(NSString*)kUTTypeMovie,(NSString*)kUTTypeImage];
        _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeLow;
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:_imagePickerController animated:YES completion:nil];

           } ctr:self];

}

#pragma  mark - imagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSString *mdeiaTye = [info objectForKey:UIImagePickerControllerMediaType]; //获取媒体类型
    if ([mdeiaTye isEqualToString:(NSString*)kUTTypeImage]) {  //判断媒体类型是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSString *iamgeStrBase64 = [data base64Encoding];
        NSLog(@"%@,%lu",iamgeStrBase64,iamgeStrBase64.length/1024);
        
        _photoLab.text = @"照片已选择";
        _photoImageShoew.image = image;

        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//提交
- (IBAction)upDateBtn:(id)sender {
    [_rep postComplaintWithtagId:@"F1060F560C2002E0" tagSn:@"000000000777" tagSnProducerCode:@"SHFDA" enterpriseId:@"3" productId:@"47" userName:@"INESA芥花油" mobile:@"15151474388" comments:@"123"];
    
    [Common pstaAlertWithTitle:@"" message:@"已提交" defaultTitle:@"留在本页" cancleTitle:@"返回主页" defaultBlock:^(id defaultBlock) {
        NSLog(@"123");
        
    } CancleBlock:^(id cancleBlock) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } ctr:self];
    
    
    
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    if (type == REQUSET_Complaint) {
        
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    _photoImageShoew.ima

    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
