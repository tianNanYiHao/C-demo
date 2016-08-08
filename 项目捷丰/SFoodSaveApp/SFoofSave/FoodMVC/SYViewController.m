//
//  SYViewController.m
//  SFoofSave
//
//  Created by Lff on 16/8/3.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "SYViewController.h"
#import "SDCycleScrollView.h"
//#import "ScanCodeViewController.h"
#import "ScanViewController.h"
#import "CertificationGoodsViewController.h"
#import "ManualSearchSYViewController.h"



#import "AuthenticationEnterpriseViewController.h"

#import "UITabBarCustemView.h"
#import "MyViewController.h"
#import "SetUpViewController.h"



#import "SubLBXScanViewController.h"
#import "LBXScanWrapper.h"
#import "NFCViewController.h"
#define ENTERPRISE_URL @"http://shfda.org/data/showdatamobile.do?menu-id=enterprise"
#define PRODUCT_URL @"http://shfda.org/data/showdatamobile.do?menu-id=product"

@interface SYViewController ()
{
    UITabBarCustemView *_tabBarCustemView;
    BOOL click;
    SetUpViewController *_setUpViewController;
    UIView *maskVIew;

}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *homeBGview;

@property (weak, nonatomic) IBOutlet UIButton *commodityInquireBtn;//商品溯源btn

@property (weak, nonatomic) IBOutlet UIButton *commodityTraceBtn;//追溯数据btn

@property (weak, nonatomic) IBOutlet UIButton *commodityPublicBtn;//信息公开btn
@property (nonatomic,strong) NSString *UrlStr1;//拼接条形码网址所用的
@property (nonatomic,strong) NSString *UrlStr2;//拼接条形码网址所用的
@property (nonatomic,strong) NSString *UrlStr3;//拼接条形码网址所用的
@property (nonatomic,strong) NSString *UrlStr4;//拼接条形码网址所用的
@property (nonatomic,strong) MyViewController *myviewController;



@end

@implementation SYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上食安";

    
    
    //左划设置页
    [self createSetUpView];
    
    //左滑按钮BarButton
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"更多选项"] style:UIBarButtonItemStyleDone target:self action:@selector(rightTouchClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    //我的页面
    _myviewController = [[MyViewController alloc] init];
    [self addChildViewController:_myviewController];
    [_bgView addSubview:_myviewController.view];
    _myviewController.view.hidden  = YES;

    //自定义tabbar
    _tabBarCustemView = [[UITabBarCustemView alloc] initWithFrame:CGRectMake(0, 0,boundsWidth ,0) CustomTabBarSelectBtnBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
        if (index == 1) {  //首页
             _myviewController.view.hidden  = YES;
            self.title = @"上食安";
            _homeBGview.x = 0;
        
        }
        else if (index == 2){  //扫码
            if ([self validateCamera]) {
                [self createZFBStyle];
            }else{
                [Common pstaAlertWithTitle:@"提示" message:@"请检查摄像头" defaultTitle:@"" cancleTitle:@"取消" defaultBlock:^(id defaultBlock) {
                } CancleBlock:^(id cancleBlock) {
                } ctr:self];
            }
        }
        else if (index == 3){ //我的
            self.title = @"我的";
            _myviewController.view.hidden  = NO;
            _myviewController.view.x = 0;
            
        }
    }];//图片360*71
    [_bgView addSubview:_tabBarCustemView];
    [_tabBarCustemView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(71);
        make.width.mas_offset(boundsWidth);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
    }];

}
- (void)createSetUpView{
    click = YES;
    _setUpViewController = [[SetUpViewController alloc] initWithNibName:@"SetUpViewController" bundle:nil];
    [self addChildViewController:_setUpViewController];
    [self.view addSubview:_setUpViewController.view];
    _setUpViewController.view.frame = CGRectMake(boundsWidth, 0, boundsWidth/4*3, boundsHeight);
  


    //暗色遮罩
    maskVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 64, boundsWidth, boundsHeight-64
                                                        )];
    maskVIew.backgroundColor  = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:maskVIew];
    maskVIew.alpha = 0;  //由于此时遮罩不显示 即可点击下一个页面
    
    [_setUpViewController getActionBlock:^(id message) {
        maskVIew.frame = CGRectMake(0, 64, boundsWidth, boundsHeight-64);
        maskVIew.alpha = 0;
    }];
    
}

- (void)rightTouchClick{
    click = !click;
    if (!click) {
        [UIView animateWithDuration:0.3 animations:^{
            maskVIew.alpha = 0.3;
            maskVIew.x = -boundsWidth/4*3;
            _setUpViewController.view.x = boundsWidth/4;  //侧滑页
            _homeBGview.x = -boundsWidth/4*3;  //首页
            _myviewController.view.x = -boundsWidth/4*3;
            _tabBarCustemView.x = -boundsWidth/4*3;  //custemTabbar
            self.navigationController.navigationBar.x = -boundsWidth/4*3;  //导航栏

        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            maskVIew.alpha = 0;
            maskVIew.x = 0;
            _setUpViewController.view.x = boundsWidth;
            _myviewController.view.x = 0;
            _homeBGview.x = 0;
            _tabBarCustemView.x = 0;
            self.navigationController.navigationBar.x = 0;
        } completion:^(BOOL finished) {
        }];
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    click = YES;
    [UIView animateWithDuration:0.1 animations:^{
        self.navigationController.navigationBar.x = 0;
        _setUpViewController.view.x = boundsWidth;
        _homeBGview.x = 0;
        _myviewController.view.x = 0;
    }];
    

}
//商品企业
- (IBAction)CommodityInquire:(UIButton *)sender {
    NSLog(@"商品企业");

        //已经登陆
        AuthenticationEnterpriseViewController *AuthenticaionVC = [[AuthenticationEnterpriseViewController alloc]init];
        AuthenticaionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:AuthenticaionVC animated:YES];

}


//溯源商品
- (IBAction)CommodityTrace:(UIButton *)sender {
      NSLog(@"溯源商品");
        //已经登陆
        CertificationGoodsViewController *certificationVC = [[CertificationGoodsViewController alloc]init];
        certificationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:certificationVC animated:YES];
}

//扫一扫
- (IBAction)CommodityPublic:(UIButton *)sender {
    NSLog(@"扫一扫");

        if ([self validateCamera]) {
                 [self createZFBStyle];
        }else{
            [Common pstaAlertWithTitle:@"提示" message:@"请检查摄像头" defaultTitle:@"" cancleTitle:@"取消" defaultBlock:^(id defaultBlock) {
            } CancleBlock:^(id cancleBlock) {
            } ctr:self];
        }
}


- (IBAction)NFCInduction:(id)sender {//NFC感应
    NSLog(@"NFC");
    NFCViewController *nfc = [[NFCViewController alloc] initWithNibName:@"NFCViewController" bundle:nil];
    [self.navigationController pushViewController:nfc animated:YES];
    
}

- (IBAction)ManualInput:(id)sender {//手动输入
    NSLog(@"手动输入");
    ManualSearchSYViewController *v = [[ManualSearchSYViewController alloc] initWithNibName:@"ManualSearchSYViewController" bundle:nil];
    v.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:v animated:YES];
}

#pragma mark - 仿支付宝扫码(style设置)
-(void)createZFBStyle{
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480) {
        //如果是3.5inch 显示的扫码缩小
        style.centerUpOffset = 40;
        style.xScanRetangleOffset = 20;
    }
    
    style.alpa_notRecoginitonArea = 0.6;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2.0;
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    
    
    style.isNeedShowRetangle = NO;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    //使用的支付宝里面网格图片
    UIImage *imgFullNet = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    [self openScanVCWithStyle:style];
    
}
#pragma  mark - 跳转扫码
- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;//区域识别效果
    
    vc.isQQSimulator = YES; //qq功能预写了一些功能按钮 (相册/闪光/二维码按钮)
    vc.isVideoZoom = YES; //增加缩放功能
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/
- (BOOL)validateCamera {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

@end
