//
//  SureNowRedeemViewController.m
//  QuickPos
//
//  Created by Aotu on 16/1/15.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "SureNowRedeemViewController.h"
#import "Masonry.h"
#import "SureBuyTableViewCell.h"
#import "hongBaoModel.h"
#import "Request.h"
#import "Common.h"
#import "MangePayViewController.h"

@interface SureNowRedeemViewController ()<ResponseData>
{
    
    hongBaoModel *_hongBaoModel;
    NSMutableArray *_dataArray;
    Request *_request;
    SureBuyTableViewCell *_cell;
    
    NSTimer *timer;//倒计时
    int Second;//秒数

}
@property (weak, nonatomic) IBOutlet UIView *headView;


@property (weak, nonatomic) IBOutlet UIButton *nowBuy; //立即赎回
@end

@implementation SureNowRedeemViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"赎回";
    
    self.view.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _headView.backgroundColor = [Common hexStringToColor:@"eeeeee"];
      _view4.backgroundColor = [Common hexStringToColor:@"eeeeee"];
    _view4Text.textColor = [Common hexStringToColor:@"b3b3b3"];
    _yzCodeBtn.layer.cornerRadius = 5;
    _nowBuy.layer.cornerRadius = 5;
    _nowBuy.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    _yzCodeBtn.backgroundColor = [Common hexStringToColor:@"47a8ef"];
    
    _icon.image = [UIImage imageNamed:@"22"];
    
    _redeemMoneyLab.text = _redemRealMoney;
    
    
    _request = [[Request alloc] initWithDelegate:self];

  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_request userInfo:[AppDelegate getUserBaseData].mobileNo];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"数据加载中..."];
    
    
    
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (type == REQUSET_USERINFOQUERY) {
        if ([dict objectForKey:@"respCode"]) {
            _userName.text = [[[dict objectForKey:@"data"] objectForKey:@"resultBean"] objectForKey:@"customerName"];

        }
        
    }
    if (type == REQUSET_getRedeemCode) {
        if ([[dict objectForKey:@"flag"] isEqualToString:@"00"]) {
            [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"VerificationCodeSentSuccessfully")];
        }
    }
    if (type == REQUSET_finalyRedeem) {
        
        if ([[dict objectForKey:@"orderid"] isEqualToString:_redemOrderID]) {
            [self.navigationController popToRootViewControllerAnimated:YES]; //返回页面
            [MBProgressHUD showHUDAddedTo:self.view WithString:@"赎回成功"];

        }
        if ([[dict objectForKey:@"msgcode"] isEqualToString:@"11"]) {
             [MBProgressHUD showHUDAddedTo:self.view WithString:[dict objectForKey:@"msgtext"]];
        }
        
    }
}
//获取验证码
- (IBAction)yzCodeBtn:(id)sender {
    Second = 60;
    [timer invalidate];
    timer = nil;
    
    
    NSLog(@"_redemOrderID%@",_redemOrderID);
    
    if (_redemOrderID) {
        [_request getRedeemCodeWithOrderId:_redemOrderID];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"获取验证码"];
        
         timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeats) userInfo:nil repeats:YES];
    }
    
}

- (void)repeats{
    
    if (Second >0){
        
        --Second;
        
        self.yzCodeBtn.enabled = NO;
        [self.yzCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
        [self.yzCodeBtn setTitle:[NSString stringWithFormat:L(@"ToResendToSecond"),Second] forState:UIControlStateNormal];
    }else{
        
        self.yzCodeBtn.enabled = YES;
        
        [self.yzCodeBtn setTitle:[NSString stringWithFormat:L(@"ToResend")] forState:UIControlStateNormal];
        [self.yzCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
}

//确认购买
- (IBAction)sureBuy:(id)sender {
    
    [_request finalyRedeemWithOrderID:_redemOrderID withRedeemCode:_yzCodeTextfiled.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"正在赎回中,请稍后..."];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 验证码倒计时




@end
