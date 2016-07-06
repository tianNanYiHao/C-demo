//
//  SetupViewController.m
//  QuickPos
//
//  Created by 胡丹 on 15/3/13.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "SetupViewController.h"
#import "QuickPosTabBarController.h"
#import "ShareView.h"
#import "VersionView.h"
#import "ContractView.h"
#import "ClearUpView.h"
#import "Request.h"
#import "MBProgressHUD+Add.h"
#import "WebViewController.h"
#import "DDMenuController.h"
#import "UMSocial.h"
#import "SetupViewCell.h"
#import "FeedBackView.h"
#import "GKImagePicker.h"
#import "GKImageCropViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SimpleCam.h"
#import "Common.h"
#import "Masonry.h"
#import "HelpViewController.h"

#define SETUPCTRLX 50
#define SETUPCTRLY 50


@interface SetupViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ResponseData,UMSocialUIDelegate,UMSocialDataDelegate,GKImagePickerDelegate,GKImageCropControllerDelegate,UIGestureRecognizerDelegate>{
    CGRect originFrame;
    NSString *customerService;
    NSString *shortCompary;
    NSString *website;
    NSString *company;
    NSString *client_version;
    MBProgressHUD *hud;
    Request *requst;
    Request *requstGet;
}
@property(strong,nonatomic)NSArray *setupArr;
@property(strong,nonatomic)NSMutableArray *setupimageArr;
@property (nonatomic, strong) UIButton *head;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *phone;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSetup;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (strong,nonatomic) NSData *imagedata;//图片data

@property (strong,nonatomic) UIImage *photoimage;//照片

@property (nonatomic,strong) SimpleCam *simpleCam;//相机
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImageView *headImageView;
@end

@implementation SetupViewController

-(void)viewWillLayoutSubviews{
    if (self.view.frame.origin.x == 0) {
        self.view.frame = originFrame;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.view.frame.origin.x != 0) {
        originFrame = self.view.frame;
    }else{
        self.view.frame = originFrame;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    requst = [[Request alloc]initWithDelegate:self];
    requstGet = [[Request alloc]initWithDelegate:self];
    
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    self.setupArr = @[
                      @{
                          @"title":@"个人设置",
                          @"image":@"setupA",
                          @"imageDid":@"setup11",
                          @"action":^{
                              DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
                              
                              UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
                              tb.selectedIndex = 2;
                              [menuController showRootController:YES];
                          }
                          },
                      @{
                          @"title":@"清理缓存",
                          @"image":@"setupB",
                          @"imageDid":@"setup3",
                          @"action":^{
                              [ClearUpView showVersionView:self];
                          }
                          },
                      @{
                          @"title":@"分享",
                          @"image":@"setupC",
                          @"imageDid":@"setup1",
                          @"action":^{
                              //            [ShareView showShareView:self];
                              [UMSocialData openLog:YES];
                              //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
                              //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
                              [UMSocialSnsService presentSnsController:self
                                                                appKey:@"5719d50067e58eb85d002523"
                                                             shareText:@"卡富宝,新版本更新啦,快来下载吧,http://www.pgyer.com/vTdi"                                          shareImage:[UIImage imageNamed:@"icon"]
                                                       shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToAlipaySession, nil]
                                                              delegate:self];
                          }
                          },
                      @{
                          @"title":@"操作手册",
                          @"image":@"setupD",
                          @"imageDid":@"setup7",
                          @"action":^{
                              WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
                              //            web.url = url;
                              web.url = @"http://112.65.206.146:8000/get/help/recharge/index.html";
                              web.navigationItem.title = L(@"Operation");
                              
                              DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
                              UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
                              UINavigationController *ctr = (UINavigationController*)[tb selectedViewController];
                              [menuController showRootController:NO];
                              UIViewController *ctrl = [ctr visibleViewController];
                              [web setHidesBottomBarWhenPushed:YES];
                              [[ctrl navigationController] pushViewController:web animated:YES];
                          }
                          },
                      @{
                          @"title":@"常见问题",
                          @"image":@"setupE",
                          @"imageDid":@"setup2",
                          @"action":^{
//                              AppDelegate *delegate = [UIApplication sharedApplication].delegate;
//                              NSString *url;
//                              if ([[[delegate getConfigDic] objectForKey:@"website"]hasPrefix:@"http"]) {
//                                  url = [NSString stringWithFormat:@"%@",[[delegate getConfigDic] objectForKey:@"website"]];
//                              }else{
//                                  url = [NSString stringWithFormat:@"http://%@",[[delegate getConfigDic] objectForKey:@"website"]];
//                              }
//                              WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
//                              web.url = url;
//                              web.navigationItem.title = L(@"FAQ");
//                              DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
//                              
//                              UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
//                              UINavigationController *ctr = (UINavigationController*)[tb selectedViewController];
//                              [menuController showRootController:YES];
//                              UIViewController *ctrl = [ctr visibleViewController];
//                              [web setHidesBottomBarWhenPushed:YES];
//                              [[ctrl navigationController] pushViewController:web animated:YES];
                              
                              WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
                              //            web.url = url;
                              web.url = @"http://app.cqjrpay.com:8080/kfb1/download/rate/rate_kfb.html";
                              web.navigationItem.title = @"费率说明";
                              
                              DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
                              UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
                              UINavigationController *ctr = (UINavigationController*)[tb selectedViewController];
                              [menuController showRootController:NO];
                              UIViewController *ctrl = [ctr visibleViewController];
                              [web setHidesBottomBarWhenPushed:YES];
                              [[ctrl navigationController] pushViewController:web animated:YES];
                              
                          }
                          },
                      @{
                          @"title":@"版本信息",
                          @"image":@"setupG",
                          @"imageDid":@"setup6",
                          @"action":^{
                              [VersionView showVersionView:self];
                          }
                          },
                      
                      @{
                          @"title":@"联系我们",
                          @"image":@"setupL",
                          @"imageDid":@"setup5",
                          @"action":^{
                              [ContractView showVersionView:self];
                          }
                          },
                      
                      
                      ];
    
    originFrame = self.view.frame;
    [self.tableViewSetup registerNib:[UINib nibWithNibName:@"SetupViewCell" bundle:nil] forCellReuseIdentifier:@"SetupViewCell"];
    
    //头部
    UIView *headbottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 120)];
    
    self.headImageView.frame = CGRectMake(20, 40, 60, 60);
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
    action:@selector(upLoadPhotoHeadImage)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    [self.headImageView addGestureRecognizer:singleFingerOne];
    
    [headbottom addSubview:self.headImageView];
    
//    self.head = [[UIButton alloc]initWithFrame:CGRectMake(20, 40, 60, 60)];
//    self.head.imageView.layer.cornerRadius = 30;
//    [self.head setImage:[UIImage imageNamed:@"headside"] forState:UIControlStateNormal];
//    [self.head addTarget:self action:@selector(upLoadPhotoHeadImage:) forControlEvents:UIControlEventTouchUpInside];
//    [headbottom addSubview:self.head];
    
    self.name = [[UILabel alloc]initWithFrame:CGRectMake(90, 50, 100, 30)];
    if ([AppDelegate getUserBaseData].userName) {
        self.name.text = [AppDelegate getUserBaseData].userName;
    }else{
        self.name.text = @"未认证";
    }
    self.name.textColor = [UIColor whiteColor];
    self.name.font = [UIFont systemFontOfSize:13];
    [headbottom addSubview:self.name];
    
    self.phone = [[UILabel alloc]initWithFrame:CGRectMake(90, 70, 200, 30)];
    self.phone.text = [AppDelegate getUserBaseData].mobileNo;
    self.phone.font = [UIFont systemFontOfSize:13];
    self.phone.textColor = [Common hexStringToColor:@"5a5a5a"];
    [headbottom addSubview:self.phone];
    
    self.tableViewSetup.tableHeaderView = headbottom;
    
    [requstGet getPhotoHeadImage];
    
}
- (void)upLoadPhotoHeadImage{
    //检查是否有权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限未开启?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    
    //第三方相机
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.delegate = self;
    
    self.imagePicker.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    //    self.imagePicker.resizeableCropArea = YES;
    self.imagePicker.cropSize = CGSizeMake(200, 200);
    
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showSetupController:(id)ctrl{
    
    UIViewController *c = (UIViewController*)ctrl;
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetupViewController *setuser = [main instantiateViewControllerWithIdentifier:@"SetupViewController"];
    
    CATransition *catran = [CATransition animation];
    catran.type = kCATransitionPush;
    catran.subtype = kCATransitionFromRight;
    catran.duration = 0.5f;
    
    [setuser.view.layer addAnimation:catran forKey:Nil];
    setuser.view.frame = CGRectMake(SETUPCTRLX,SETUPCTRLY, setuser.view.frame.size.width, setuser.view.frame.size.height);
    [c addChildViewController:setuser];
    [[c view] addSubview:setuser.view];
    
}


#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.setupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SetupViewCell";
    SetupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SetupViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary  *info = self.setupArr[indexPath.row];
    cell.image.image = [UIImage imageNamed:info[@"image"]];
    
    cell.content.text = info[@"title"];
    cell.content.textColor = [Common hexStringToColor:@"5a5a5a"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    SetupViewCell *selectcell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary  *info = self.setupArr[indexPath.row];
    selectcell.content.textColor = [Common hexStringToColor:@"14B9D5"];
    selectcell.image.image = [UIImage imageNamed:info[@"imageDid"]];
    ((void(^)())info[@"action"])();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        selectcell.content.textColor = [Common hexStringToColor:@"5a5a5a"];
        selectcell.image.image = [UIImage imageNamed:info[@"image"]];
});
   
}

#pragma mark - setupCellDelegate
-(void)getIndex:(NSIndexPath *)indexPath{
    NSDictionary* info = self.setupArr[indexPath.row];
    ((void(^)())info[@"action"])();
}

# pragma mark GKImagePicker Delegate Methods
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    if (image) {
        UIImage *imageNew = [self scaleToSize:image size:CGSizeMake(100, 100)];
        self.photoimage = imageNew;
        self.imagedata = UIImageJPEGRepresentation(imageNew, 1);
        //上传图片
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"Uploading")];
        [requst upPhotoHeadImage:self.imagedata];
        //为了解决whose view is not in the window hierarchy! 问题
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideImagePicker) userInfo:nil repeats:NO];
    }
    [self hideImagePicker];
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{

    UIGraphicsBeginImageContext(size);

    [img drawInRect:CGRectMake(0,0, size.width, size.height)];

    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
  
    UIGraphicsEndImageContext();
 
    return scaledImage;
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        [self.popoverController dismissPopoverAnimated:YES];
    } else {
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark ------分享--------
//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    if (type == REQUEST_USERAGREEMENT && [@"0000" isEqualToString:[dict objectForKey:@"respCode"]]) {
        [hud hide:YES];
        NSString *device = [[[dict objectForKey:@"data"] objectForKey:@"agreementInfo"] objectForKey:@"posDevice"];
        website = [dict objectForKey:@"website"];
        customerService = [dict objectForKey:@"customerService"];
        shortCompary = [dict objectForKey:@"shortCompary"];
        company = [dict objectForKey:@"company"];
        client_version = [dict objectForKey:@"client_version"];
        [AppDelegate getUserBaseData].device = device;
    }
    
    if (type == REQUEST_UPHEADIMAGEHEAD) {
        NSString *resultStr = dict[@"data"][@"result"][@"resultCode"];
        //1004上传头像成功 1005上传头像失败
        if ([resultStr isEqualToString:@"1004"]) {
            [hud hide:YES];
            [requstGet getPhotoHeadImage];
        }
        if ([resultStr isEqualToString:@"1005"]) {
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"图片上传失败，请重新上传"];
        }
    }
    
    if (type == REQUEST_GETUPHEADIMAGEHEAD) {
        [hud hide:YES];
        NSString *pic = dict[@"data"][@"pic"];
        if ([pic isKindOfClass:[NSNull class]]) {
            self.headImageView.image = [UIImage imageNamed:@"VW_UserCenter_HeadImage"];
        }
        else{
            NSString *urlstring = dict[@"data"][@"pic"][@"headpic"];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
            self.headImageView.image = img;
        }
        }
        
    
}

-(UIImageView*)headImageView
{
    if (!_headImageView) {
        _headImageView = [self makeHeadImageView];
    }
    return _headImageView;
}


- (UIImageView*)makeHeadImageView
{
    UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VW_UserCenter_HeadImage"]];
    UIImageView * viewMask = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VW_UserCenter_HeadMask"]];
    [view addSubview:viewMask];
    [viewMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view).insets(UIEdgeInsetsZero);
    }];
    return view;
}
@end
