//
//  DisplayScanViewController.m
//  QuickPos
//
//  Created by feng Jie on 16/7/21.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "DisplayScanViewController.h"
//#import "Create2DBarcode.h"
#import "Request.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "Common.h"

#import "LBXScanWrapper.h"
#import "LBXAlertAction.h"
#import "UIImageView+CornerRadius.h"

@interface DisplayScanViewController ()<ResponseData>
{
    Request *request;
    int timeTick;
    NSTimer *timer;
    UIImageView *_imageVIew;

}

@property (nonatomic,strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *AmtLabel;//显示金额
@property (nonatomic,strong) NSString *respCodes;//接受后台返回成功与否的值


@end

@implementation DisplayScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"微信收款";
    NSString *amtStr = [NSString stringWithFormat:@"%.2f%@",self.ScanMoney.doubleValue,@"￥"];
    self.AmtLabel.text = amtStr;
    
    NSLog(@"%@",self.scanImage);
    
    self.view.backgroundColor = [UIColor whiteColor];
    request = [[Request alloc]initWithDelegate:self];
    
    _imageVIew = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-150)/2, 120, 150, 150)];
    [self.view addSubview:_imageVIew];
    _imageVIew.hidden = YES;
    
    _imageVIew.image = [LBXScanWrapper createQRWithString:_scanImage size:_imageVIew.bounds.size];
    if (_imageVIew.image) {
        [LBXScanWrapper addImageViewLogo:_imageVIew centerLogoImageView:nil logoSize:CGSizeZero];
        _imageVIew.hidden = NO;
    }
    
    timeTick = 1;//1秒倒计时
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];

}

-(void)timeFireMethod
{
    timeTick--;
    if(timeTick==0){
        [timer invalidate];
        [request queryWeixinOrderStateorderId:self.orderId];
    }
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    if ([dict[@"respCode"]isEqual:@"0000"]) {
        if (type == REQUSET_QUERYWEIXINORDERSTATE) {
            self.respCodes = [[dict objectForKey:@"data" ] objectForKey:@"respCode"];
            if ([self.respCodes integerValue] == 000000) {
                [Common showMsgBox:nil msg:@"支付成功" parentCtrl:self];
            }else
            {
                timeTick = 1;//1秒倒计时
                timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            }
       
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
