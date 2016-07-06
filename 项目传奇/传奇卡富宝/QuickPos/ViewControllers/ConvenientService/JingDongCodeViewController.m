//
//  JingDongCodeViewController.m
//  QuickPos
//
//  Created by kuailefu on 16/6/28.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "JingDongCodeViewController.h"
#import "LBXScanWrapper.h"
#import "LBXAlertAction.h"
#import "UIImageView+CornerRadius.h"
#import "Request.h"
#import "SJAvatarBrowser.h"

@interface JingDongCodeViewController ()<ResponseData>
{
    Request *request;
}
@property (weak, nonatomic) IBOutlet UIView *bottom;
@property (weak, nonatomic) IBOutlet UIImageView *Qcode;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

@implementation JingDongCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫码收款";
    self.bottom.layer.cornerRadius = 5;
    self.moneyLab.text = self.money;
    request = [[Request alloc]initWithDelegate:self];
    [request scanCodeOrderRequestWalletType:@"1"
                                 merchantId:self.orderData.merchantId
                                  productId:self.orderData.productId
                                   orderAmt:self.orderData.orderAmt
                                    orderId:self.orderData.orderId
                                  orderDesc:@""
                                orderRemark:@""
     ];
    
    self.Qcode.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    [self.Qcode addGestureRecognizer:tap];
}
- (void)magnifyImage
{
    [SJAvatarBrowser showImage:self.Qcode];//调用方法
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    if (type == REQUSET_CodeOrderPic && [[dict objectForKey:@"respCode"] isEqualToString:@"0000"]) {
        NSString *codePic = dict[@"codePic"];
//        NSString *codePic = @"http://www.2345.com/";//测试
        
        self.Qcode.image = [LBXScanWrapper createQRWithString:codePic size:self.Qcode.bounds.size];
        CGSize logoSize=CGSizeMake(30, 30);
        [LBXScanWrapper addImageViewLogo:nil centerLogoImageView:nil logoSize:logoSize];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view WithString:[dict objectForKey:@"respDesc"]];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
