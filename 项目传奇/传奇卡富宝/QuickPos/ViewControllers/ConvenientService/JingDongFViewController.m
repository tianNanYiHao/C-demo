//
//  JingDongFViewController.m
//  QuickPos
//
//  Created by kuailefu on 16/6/28.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import "JingDongFViewController.h"
#import "Common.h"
#import "JingDongCodeViewController.h"
#import "SubLBXScanViewController.h"
#import "MyQRViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
//#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "UserInfo.h"
#import "JingDongResultViewController.h"
#import "Masonry.h"
#import "RadioButton.h"
#import "OrderData.h"
#import "MBProgressHUD.h"
#import "chooseBankCardListController.h"
#import "PayType.h"


@interface JingDongFViewController ()<UITextFieldDelegate,ResponseData>{
    Request *requst;
    UserInfo *info;
    
    
    
    NSDictionary *dataDic;//请求返回字典
    
    NSString *newCardNumber;//截取卡号后的赋值
    
    BankCardData *bankCardData;//类为属性
    
    NSString *cardNumber;//传值用-卡号
    
    NSString *cardIdx;//传值用-卡索引
    NSInteger _index;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *comfirt;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;//姓名
@property (weak, nonatomic) IBOutlet UILabel *kindLab; //店铺名称
@property (weak, nonatomic) IBOutlet UIImageView *bankImage;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;


@property (nonatomic, strong) UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *headView;// 头像view
@property (weak, nonatomic) IBOutlet UIView *titleVIewBG;// 头像+姓名bg
@property (weak, nonatomic) IBOutlet RadioButton *JingDongSelect;
@property (weak, nonatomic) IBOutlet RadioButton *weixinSelect;
@property (weak, nonatomic) IBOutlet RadioButton *zfbSelect;
@property (weak, nonatomic) IBOutlet RadioButton *baiduSelect;
@property (weak, nonatomic) IBOutlet UIButton *JingDongbtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinbtn;
@property (weak, nonatomic) IBOutlet UIButton *zfbbtn;
@property (weak, nonatomic) IBOutlet UIButton *baidubtn;
@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic,strong)OrderData *orderData;
@end

@implementation JingDongFViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    requst = [[Request alloc]initWithDelegate:self];
    self.comfirt.layer.cornerRadius = 5;
    self.money.delegate = self;
    self.comfirt.layer.cornerRadius = 5;
    self.comfirt.backgroundColor =[Common hexStringToColor:@"ebebeb"];
    self.comfirt.enabled = NO;
    [self.comfirt setTitleColor:[Common hexStringToColor:@"dcdcdc"] forState:UIControlStateNormal];
    
    self.title = @"扫一扫";

//    [self addheadImg];
    
    
    self.JingDongSelect.userInteractionEnabled = NO;
    self.weixinSelect.userInteractionEnabled = NO;
    self.zfbSelect.userInteractionEnabled = NO;
    self.baiduSelect.userInteractionEnabled = NO;
    
    //除了京东支付其他隐藏
    self.weixinbtn.enabled = NO;
    self.zfbbtn.enabled = NO;
    self.baidubtn.enabled = NO;
    
    if ([self.type isEqualToString:@"saoyisao"]) {
    [self.comfirt setTitle:@"扫码收款" forState:UIControlStateNormal];
    }
    if ([self.type isEqualToString:@"fukuai"]) {
    [self.comfirt setTitle:@"生成付款码" forState:UIControlStateNormal];
    }
    
    self.money.clearsOnBeginEditing = YES;
    _nameLab.text = @"";
    _kindLab.text = @"";
    _maskView.hidden = NO;
    
}

//点击进入银行卡列表
- (IBAction)bankBtnClik:(id)sender {
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    chooseBankCardListController *vc61 = [mainStoryboard instantiateViewControllerWithIdentifier:@"chooseBankCardListController"];
    vc61.destinationType = WITHDRAW;
    
    [vc61 chooseBankCardNumBlock:^(id chooseBankCardNum) {
        _index = [chooseBankCardNum integerValue];
        //
        [requst bankListAndbindType:@"01"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"MBPLoading")];
        [hud hide:YES afterDelay:1];

    }];
    
    [self.navigationController pushViewController:vc61 animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return  [self moneyTextField:textField shouldChangeCharactersInRange:range replacementString:string max:1000];
}

-(BOOL)moneyTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string max:(NSInteger)max
{
    //筛选输入内容确保正确性
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    BOOL isHasRadixPoint = YES;
    //小数点后面的位数
    NSInteger RadixPointNum = 2;
    NSString *existText = textField.text;
    //判断是否含有小数点
    if ([existText rangeOfString:@"."].location == NSNotFound) {
        isHasRadixPoint = NO;
    }
    
    if (string.length > 0) {
        unichar newChar = [string characterAtIndex:0];
        //开始进入判断文本
        if (existText.length>0) {
            if ([existText characterAtIndex:0]=='0') {
                //当首位是0的时候
                if (newChar=='0') {
                    //输入是零的时候判断是否有小数点
                    if (isHasRadixPoint) {
                        return range.location<=2;
                    }else{
                        return NO;
                    }
                }else if((newChar > '0' && newChar <= '9') &&existText.length<=1){
                    textField.text = @"";
                }
            }
        }
        
        if ((newChar >= '0' && newChar <= '9') || newChar == '.' ) {
            if (newChar == '.') {
                if (existText.length==0) {
                    textField.text = @"0.";
                    return NO;
                }else{
                    return !isHasRadixPoint;
                }
            }else {
                if (isHasRadixPoint) {
                    NSRange ran = [existText rangeOfString:@"."];
                    return (range.location - ran.location <= RadixPointNum);
                } else{
                    //小数点前面的位数
                    //return existText.length<6;
                    if ([textField.text isEqualToString:@"0"]){
                        textField.text = @"0.";
                    }
                    NSString *nowString;
                    if (range.length==0) {
                        nowString = [NSString stringWithFormat:@"%@%@",textField.text,string];
                    }else{
                        nowString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                    }
                    //                    NSString *nowString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                    if (nowString.doubleValue> max) {
                        textField.text = [NSString stringWithFormat:@"%ld",(long)max];
                        [Common showMsgBox:@"" msg:@"请输入0~1000的金额" parentCtrl:self];
                        return NO;
                    }
                    
                    return nowString.doubleValue <= max;
                }
            }
        }else {
            return YES;
        }
    }
    return YES;
    
}
- (IBAction)paywayAction:(UIButton *)btn {
    //启用按钮
    self.comfirt.backgroundColor =[Common hexStringToColor:@"14b9d5"];
    self.comfirt.enabled = YES;
    [self.comfirt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    if ([tag isEqualToString:@"11"]) {
        self.JingDongSelect.selected = YES;
        self.weixinSelect.selected = NO;
        self.zfbSelect.selected = NO;
        self.baiduSelect.selected = NO;
    }
    if ([tag isEqualToString:@"22"]) {
        self.JingDongSelect.selected = NO;
        self.weixinSelect.selected = YES;
        self.zfbSelect.selected = NO;
        self.baiduSelect.selected = NO;
    }
    if ([tag isEqualToString:@"33"]) {
        self.JingDongSelect.selected = NO;
        self.weixinSelect.selected = NO;
        self.zfbSelect.selected = YES;
        self.baiduSelect.selected = NO;
    }
    if ([tag isEqualToString:@"44"]) {
        self.JingDongSelect.selected = NO;
        self.weixinSelect.selected = NO;
        self.zfbSelect.selected = NO;
        self.baiduSelect.selected = YES;
    }
    
    
}
#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:matchedStr];
}
- (IBAction)comfirtAction:(id)sender {
 
    if ([self.money.text doubleValue] == 0 || [self.money.text doubleValue] >1000 ) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"请输入0~1000的金额"];
        self.money.text = @"";
        return;
    }

    if ([self.type isEqualToString:@"saoyisao"]) {
        
        self.merchantId = @"0008000001";
        self.productId = @"0000000000";
        NSString *priceVer = self.money.text;
        priceVer = [NSString stringWithFormat:@"%.2f",[priceVer doubleValue]];
        NSString *price = [priceVer stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        [requst applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                         MerchanId:self.merchantId
                         productId:self.productId
                          orderAmt:price
                         orderDesc:[AppDelegate getUserBaseData].mobileNo
                       orderRemark:@""
                      commodityIDs:@""
                           payTool:@"11"];
    }
    
    if ([self.type isEqualToString:@"fukuai"]) {
        
        self.merchantId = @"0008000002";
        self.productId = @"0000000000";
        NSString *priceVer = self.money.text;
        priceVer = [NSString stringWithFormat:@"%.2f",[priceVer doubleValue]];
        NSString *price = [priceVer stringByReplacingOccurrencesOfString:@"." withString:@""];
        [requst applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                         MerchanId:self.merchantId
                         productId:self.productId
                          orderAmt:price
                         orderDesc:[AppDelegate getUserBaseData].mobileNo
                       orderRemark:@""
                      commodityIDs:@""
                           payTool:@"12"];
    }
    
}

#pragma mark --模仿支付宝
- (void)ZhiFuBaoStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 60;
    style.xScanRetangleOffset = 30;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480 )
    {
        //3.5inch 显示的扫码缩小
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
#pragma mark --扫描
- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    vc.orderData = self.orderData;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (array.count < 1)
    {
        [self showError:@"识别失败了"];
        return;
    }
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    LBXScanResult *scanResult = array[0];
    //震动提醒
    [LBXScanWrapper systemVibrate];
    //声音提醒
    [LBXScanWrapper systemSound];
}

- (void)showError:(NSString*)str
{
        [LBXAlertAction showAlertWithTitle:@"提示" msg:str chooseBlock:nil buttonsStatement:@"知道了",nil];
}

//-(void)addheadImg{
//    self.headImageView.frame = CGRectMake(16, 16, 60, 60);
//    [_titleVIewBG addSubview:self.headImageView];
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //登陆判断
    if ([[AppDelegate getUserBaseData].mobileNo length] > 0) {
        //已经登陆
        [requst userInfo:[AppDelegate getUserBaseData].mobileNo];
//        [requst getPhotoHeadImage];

    }
    
}
-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{


    if(type == REQUSET_USERINFOQUERY && [dict[@"respCode"] isEqual:@"0000"]){
        NSMutableDictionary *getDic = [NSMutableDictionary dictionary];
        getDic = dict[@"data"];
        info = [[UserInfo alloc]initWithData:getDic[@"resultBean"]];
//        _nameLab.text = info.realName; //姓名
        
    }
    if(type == REQUSET_BANKLIST){
        
        bankCardData = [[BankCardData alloc]initWithData:dict];
        if (bankCardData.bankCardArr == 0) {
            _nameLab.text = @"您还未绑定任何银行卡,请绑定";
            _bankImage.image = [UIImage imageNamed:@"22"];
        }else{
            _maskView.hidden = YES;
            BankCardItem *bcItem = bankCardData.bankCardArr[_index]; //默认显示第一个
            _nameLab.text = bcItem.bankName;
            NSInteger xuhao = [bcItem.accountNo length]-4;
            NSString *num = [bcItem.accountNo substringFromIndex:xuhao];
            //    bankcardCell.cardNumberLabel.text = [Common bankCardNumSecret:bcItem.accountNo];
            _kindLab.text = [NSString stringWithFormat:@"尾号%@储蓄卡",num];
            [_bankImage sd_setImageWithURL:[NSURL URLWithString:bcItem.iconUrl]];
        }

    }
    if (type == REQUEST_GETUPHEADIMAGEHEAD) {
        
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
    
    if (type == REQUSET_ORDER) {
        
        if ([self.type isEqualToString:@"saoyisao"]) {
            self.orderData = [[OrderData alloc]initWithData:dict];
            [self ZhiFuBaoStyle];
        }
        if ([self.type isEqualToString:@"fukuai"]) {
            self.orderData = [[OrderData alloc]initWithData:dict];
            JingDongCodeViewController *JDvc = [[JingDongCodeViewController alloc]initWithNibName:@"JingDongCodeViewController" bundle:nil];
            JDvc.money = self.money.text;
            JDvc.orderData = self.orderData;
            JDvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:JDvc animated:YES];
        }

    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(UIImageView*)headImageView
//{
//    if (!_headImageView) {
//        _headImageView = [self makeHeadImageView];
//    }
//    return _headImageView;
//}
//
//- (UIImageView*)makeHeadImageView
//{
//    UIImageView * view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebar_icon_tx_kb"]];
//    UIImageView * viewMask = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebar_icon_txwk1"]];
//    [view addSubview:viewMask];
//    [viewMask mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(view).insets(UIEdgeInsetsZero);
//    }];
//    return view;
//}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
 self.money.text = @"0";
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSMutableString *str3 = [NSMutableString stringWithFormat:@"%@",textField.text];
    self.money.text = str3;
}
@end
