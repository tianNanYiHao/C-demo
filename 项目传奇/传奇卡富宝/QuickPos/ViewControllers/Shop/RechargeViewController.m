//
//  RechargeViewController.m
//  QuickPos
//
//  Created by Leona on 15/9/25.
//  Copyright © 2015年 张倡榕. All rights reserved.
//

#import "RechargeViewController.h"
#import "ShoppingCartViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "OrderViewController.h"
#import "Request.h"
#import "UIImageView+WebCache.h"
#import "MallData.h"
#import "OrderData.h"
#import "PayType.h"
#import "ChooseView.h"
#import "MallViewController.h"
#import "Common.h"
#import "WebViewController.h"
#import "HelpViewController.h"
#import "RadioButton.h"
#import "PaywayView.h"

@interface RechargeViewController ()<UITableViewDataSource,UITableViewDelegate,ResponseData,ChooseViewDelegate,paywayViewDelegate>
{
    long long  Sumprice;
    Request *request;
    NSMutableArray *commodityIDArr;
    NSString *orderDesc;
    NSString *payTool;
    OrderData *orderData;
    NSUInteger payType;
    NSString *commodityIDs;
    NSString *merchantId;
    NSString *productId;
    
}
@property (weak, nonatomic) IBOutlet UITextField *finalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UITableView *sTableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *comfirt;
@property (weak, nonatomic) IBOutlet RadioButton *button1;
@property (weak, nonatomic) IBOutlet RadioButton *button2;
@property (weak, nonatomic) IBOutlet RadioButton *button3;
@property (weak, nonatomic) IBOutlet UIView *radioBottomView;
@property (weak, nonatomic) IBOutlet RadioButton *button4;

@property (weak, nonatomic) IBOutlet RadioButton *button5;

@property (weak, nonatomic) IBOutlet RadioButton *button6;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (nonatomic, strong) NSString *isAccount;//是否是账户充值的标准

@property (weak, nonatomic) IBOutlet UIButton *paywayBtn;

@property (weak, nonatomic) IBOutlet UILabel *choosePayWayLab;
@property (weak, nonatomic) IBOutlet UIView *choosePayWayView;

@property (weak, nonatomic) IBOutlet RadioButton *button7;
@property (weak, nonatomic) IBOutlet RadioButton *button8;
@property (weak, nonatomic) IBOutlet RadioButton *button9;

@property (nonatomic,strong) NSString *payWay;
@property (weak, nonatomic) IBOutlet RadioButton *agreebtn;
@property (nonatomic,strong) PayWayViewController *payWayViewC;


@end

@implementation RechargeViewController
@synthesize finalPrice;
@synthesize totalPrice;
@synthesize CartArr;
@synthesize mobileNo;
@synthesize sTableView;
@synthesize item;
- (IBAction)webViewBtn:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *b = [sb instantiateViewControllerWithIdentifier:@"WebViewController"];
    b.title = @"卡富宝交易通用规则";
    b.url = @"http://app.cqjrpay.com:8080/kafubao/protocol-2.html";
    [self.navigationController pushViewController:b animated:YES];
}

- (IBAction)payway:(id)sender {
    
    self.comfirt.backgroundColor =[Common hexStringToColor:@"14b9d5"];
    self.comfirt.enabled = YES;
    [self.comfirt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    PaywayView *paywayView = [PaywayView new];
    paywayView.delegate = self;
    [self.view addSubview:paywayView];
    [self.paywayBtn setTitle:@"刷卡支付" forState:UIControlStateNormal];
}

- (IBAction)typeAction:(RadioButton *)sender {
    
    if (sender.tag == 44) {
        //刷卡支付
        self.radioBottomView.hidden = YES;
        _choosePayWayView.hidden = NO;
        _choosePayWayLab.hidden = NO;
        merchantId = @"0002000002";
        productId = @"0000000000";
        payTool = @"01";
        
        if (_isRechargeViewController == NO) {
            self.phoneView.hidden = YES;
        }else{
            self.phoneView.hidden = YES;
        }

        self.isAccount = @"0";
        payType = CardPayType;
    }else if (sender.tag == 66){
        //账户支付
        _choosePayWayLab.hidden = YES;
        _choosePayWayView.hidden = YES;
        self.radioBottomView.hidden = YES;
        merchantId = @"0002000002";
        productId = @"0000000004";
        payTool = @"02";
        self.phoneView.hidden = YES;
        self.isAccount = @"1";
        payType = AccountPayType;
    }else{
        //快捷支付
        _choosePayWayLab.hidden = YES;
        _choosePayWayView.hidden = YES;
        self.radioBottomView.hidden = YES;
        merchantId = @"0004000001";
        productId = @"0000000001";
        payTool = @"03";
        self.phoneView.hidden = YES;
        self.isAccount = @"0";
        payType = QuickPayType;
    }
}

- (IBAction)radioAction:(RadioButton *)sender{
    if (sender.tag == 11) {// 批发
        
        if ([payTool isEqualToString:@"03"]) {
            merchantId = @"0004000001";
            productId = @"0000000001";
        }
        else
        {
            merchantId = @"0002000002";
            productId = @"0000000000";
        }
        
    }else if (sender.tag == 22){//零售
        
        if ([payTool isEqualToString:@"03"]) {
            merchantId = @"0004000001";
            productId = @"0000000002";
                    }
        else
        {
            merchantId = @"0005000001";
            productId = @"0000000000";

        }
        
    }else{//团购
        
        if ([payTool isEqualToString:@"03"]) {
            merchantId = @"0004000001";
            productId = @"0000000003";
        }
        else
        {
            merchantId = @"0002000002";
            productId = @"0000000002";
        }
    
    }
    
        NSLog(@"%@,%@",merchantId,productId);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comfirt.layer.cornerRadius = 5;
    self.comfirt.backgroundColor =[Common hexStringToColor:@"ebebeb"];
    self.comfirt.enabled = NO;
    [self.comfirt setTitleColor:[Common hexStringToColor:@"dcdcdc"] forState:UIControlStateNormal];
    self.agreebtn.selected = YES;
    
    if (self.isRechargeViewController == NO) {
        self.title = @"个人付款";
    }else{
        self.title = @"个人充值";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.finalPrice becomeFirstResponder];
    });
    self.phone.text = [AppDelegate getUserBaseData].mobileNo;
    self.comfirt.layer.cornerRadius = 5;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:NO];
    
    commodityIDArr = [NSMutableArray array];
    orderDesc = [NSMutableString string];
    payTool = @"01";
    payType = CardPayType;
    request = [[Request alloc]initWithDelegate:self];
//    
//    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
//    [rightButton setImage:[UIImage imageNamed:@"phone_help"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(helpClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightbar;
//    
//  [self computePrice];
    [self cancelFristResponder];
    //默认
    merchantId = @"0002000002";
    productId = @"0000000000";
//    int count = ISQUICKPAY?3:2;
    int count = 2;
    float x = (self.bottomView.frame.size.width - [ChooseView chooseWidth]*count)/2.0 - 50;
    float y = self.finalPrice.frame.origin.y + self.finalPrice.frame.size.height  + 175;
//    [self.bottomView addSubview:[ChooseView secondCreatChooseViewWithOriginX:x Y:y delegate:self count:count]];
    [Common setExtraCellLineHidden:self.sTableView];//去除多余的线
    
//    _button1.groupButtons = @[_button1,_button2,_button3];
//    _button4.groupButtons = @[_button4,_button5,_button6];
    _button4.selected = YES;
    _button1.selected = YES;

//    _button7.groupButtons = @[_button7,_button8,_button9];
    
    _button4.selected = YES;
    _button1.selected = YES;
    _button7.selected = YES;
    
    _choosePayWayLab.hidden = NO;
    _choosePayWayView.hidden = NO;

    
    self.radioBottomView.hidden = YES;
    if (_isRechargeViewController == NO) {
        self.phoneView.hidden = YES;
    }else{
        self.phoneView.hidden = YES;
        
    }
    self.phoneView.hidden = NO;
    self.isAccount = @"0";
    
    
    
    //刷卡器选择页面
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _payWayViewC = [SB instantiateViewControllerWithIdentifier:@"PayWayViewController"];
    [self addChildViewController:_payWayViewC];
    [self.view addSubview:_payWayViewC.view];
    _payWayViewC.view.hidden = YES;
    
    [_payWayViewC getpayWayTypeWithBlock:^(NSString *payWayTpye, UIView *view) {
        _payWay = payWayTpye;
        view.hidden = YES;
    }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //    if([UIDevice currentDevice].isIphone4){
    //
    //        self.sTableView.contentSize = CGSizeMake(0,1000);
    //
    //    }
}

-(void)viewWillAppear:(BOOL)animated
{
    //    int count = ISQUICKPAY?3:2;
    //    float x = (self.bottomView.frame.size.width - [ChooseView chooseWidth]*count)/2.0;
    //    float y = self.finalPrice.frame.origin.y + self.finalPrice.frame.size.height + 12;
    //    [self.bottomView addSubview:[ChooseView creatChooseViewWithOriginX:x Y:y delegate:self count:count]];
    //    merchantId = @"0002000002";
    //    productId = @"0000000000";
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.navigationController.navigationBarHidden = NO;
    NSLog(@"%@=====%@",productId,merchantId);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (IBAction)helpClick:(id)sender {
    
    HelpViewController *helpVc = [HelpViewController new];
    [self.navigationController pushViewController:helpVc animated:YES];

//    WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    [web setTitle:L(@"help")];
//    [web setUrl:ShopHelp];
//    [self.navigationController pushViewController:web animated:YES];
}

-(void)chooseView:(ChooseView *)chooseView chooseAtIndex:(NSUInteger)chooseIndex
{
    
    payType = chooseIndex;
    payTool = [NSString stringWithFormat:@"0%d",chooseIndex];
    
    if (payType == CardPayType){
        self.radioBottomView.hidden = NO;
        merchantId = @"0002000002";
        productId = @"0000000000";
    }else{
        self.radioBottomView.hidden = YES;
        merchantId = @"0004000001";
        productId = @"0000000001";
    }
    
    UIView *v = chooseView.superview;
    for (UIView *c in v.subviews) {
        if ([c isKindOfClass:[ChooseView class]]) {
            if (c.tag != chooseIndex) {
                for (UIView *sv in c.subviews) {
                    if ([sv isKindOfClass:[UIButton class]]) {
                        [(UIButton*)sv setSelected:NO];
                    }
                    
                }
            }
        }
    }
    
}
//计算价格//拼装商品订单号（订单ID集合）
- (void)computePrice
{
    for (MallItem *dic  in CartArr) {
        int sum = [dic.sum intValue];
        NSString *pr = [NSString stringWithFormat:@"%.2f",[dic.price doubleValue]];
        long long price = [[pr stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        Sumprice += sum * price;
        
        [commodityIDArr addObject:dic.commodityID];
    }
    
    NSMutableString *temp = [NSMutableString string];
    for (NSMutableString *str in commodityIDArr) {
        [temp appendFormat:@"%@,",str];
    }
    
    orderDesc = mobileNo;
    commodityIDs = [temp substringToIndex:temp.length-1];
    
    finalPrice.text = [NSString stringWithFormat:@"%.2f",Sumprice / 100.0];
    totalPrice.text = [NSString stringWithFormat:@"%.2f",Sumprice / 100.0];
    
    
}
//图片解析。从string拼接后转成data
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getBuyType:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0://批发
            if ([payTool isEqualToString:@"03"]) {
                merchantId = @"0004000001";
                productId = @"0000000001";
            }
            else
            {
                merchantId = @"0002000002";
                productId = @"0000000000";
            }
            break;
        case 1://零售
            if ([payTool isEqualToString:@"03"]) {
                merchantId = @"0004000001";
                productId = @"0000000002";
            }
            else
            {
                merchantId = @"0005000001";
                productId = @"0000000000";
            }
            break;
        case 2://团购
            if ([payTool isEqualToString:@"03"]) {
                merchantId = @"0004000001";
                productId = @"0000000003";
            }
            else
            {
                merchantId = @"0002000002";
                productId = @"0000000002";
            }
        default:
            break;
    }
    NSLog(@"%@,%@",merchantId,productId);
}

#pragma mark - 选择支付方式delegate!!!!
- (void)paywayViewFinishTag:(NSInteger)tag{
    NSString *tagNum = [NSString stringWithFormat:@"%ld",(long)tag];
    if ([tagNum isEqualToString:@"1001"]) {
        //刷卡支付
        self.radioBottomView.hidden = YES;
        _choosePayWayView.hidden = NO;
        _choosePayWayLab.hidden = NO;
        merchantId = @"0002000002";
        productId = @"0000000000";
        payTool = @"01";
        
//        if (_isRechargeViewController == NO) {
//            self.phoneView.hidden = YES;
//        }else{
//            self.phoneView.hidden = YES;
//        }
        
        self.isAccount = @"0";
        payType = CardPayType;
        
        [self.paywayBtn setTitle:@"刷卡支付" forState:UIControlStateNormal];
        _payWayViewC.view.hidden = NO;
        
        
        
        
    }
    if ([tagNum isEqualToString:@"1002"]) {
        //账户支付
        _choosePayWayLab.hidden = YES;
        _choosePayWayView.hidden = YES;
        self.radioBottomView.hidden = YES;
        merchantId = @"0002000002";
        productId = @"0000000004";
        payTool = @"02";
//        self.phoneView.hidden = YES;
        self.isAccount = @"1";
        payType = AccountPayType;
        [self.paywayBtn setTitle:@"账户支付" forState:UIControlStateNormal];
    }
    if ([tagNum isEqualToString:@"1003"]) {
        //快捷支付
        _choosePayWayLab.hidden = YES;
        _choosePayWayView.hidden = YES;
        self.radioBottomView.hidden = YES;
        merchantId = @"0004000001";
        productId = @"0000000001";
        payTool = @"03";
//        self.phoneView.hidden = YES;
        self.isAccount = @"0";
        payType = QuickPayType;
         [self.paywayBtn setTitle:@"快捷支付" forState:UIControlStateNormal];
    }

}
//发送订单信息。得到回调信息才push
- (IBAction)pushToOrder:(id)sender {
    
    
    NSString *priceVer = finalPrice.text;
    priceVer = [NSString stringWithFormat:@"%.2f",[priceVer doubleValue]];
    NSString *priceVerde = finalPrice.text;
    if ([priceVer length] > 9 || [priceVerde isEqualToString:@""] || ![self matchStringFormat:priceVer withRegex:@"^([0-9]+\\.[0-9]{2})|([0-9]+\\.[0-9]{1})|[0-9]*$"]  || [priceVer isEqualToString:@"0.00"]) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"请输入充值金额")];
    }
    else if (![self matchStringFormat:priceVerde withRegex:@"^([0-9]+\\.[0-9]{2})|([0-9]+\\.[0-9]{1})|[0-9]*$"])
    {
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"CorrectPrice")];
    }
    else
    {
        NSString *price = [priceVer stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        if ([self.isAccount isEqualToString:@"1"]) {
            
            if (self.phone.text.length == 0) {
                [Common showMsgBox:@"" msg:L(@"InputNumber") parentCtrl:self];
                return;
            }
            
            if(![Common isPhoneNumber:self.phone.text]){
                [Common showMsgBox:@"" msg:L(@"MobilePhoneNumberIsWrong") parentCtrl:self];
                return;
            }
            if ([self.phone.text isEqualToString:[AppDelegate getUserBaseData].mobileNo]) {
                [Common showMsgBox:@"" msg:@"账户支付不能为自己充值" parentCtrl:self];
                return;
                
            }
            
            //账户支付
            [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                              MerchanId:merchantId
                              productId:productId
                               orderAmt:price
                              orderDesc:self.phone.text
                            orderRemark:@""
                           commodityIDs:@""
                                payTool:payTool];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"OrderHasBeenSubmitted-PleaseLater")];
            
        }else{
            if (payType == QuickPayType) {   //快捷支付
                [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                                  MerchanId:merchantId
                                  productId:productId
                                   orderAmt:price
                                  orderDesc:[AppDelegate getUserBaseData].mobileNo
                                orderRemark:@""
                               commodityIDs:@""
                                    payTool:payTool];
                
            }else{
                //刷卡支付
                if (_isRechargeViewController == NO) {   // 个人付款 (暂时这个功能没有了 不看这段)
                    [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                                      MerchanId:merchantId
                                      productId:productId
                                       orderAmt:price
                                      orderDesc:[AppDelegate getUserBaseData].mobileNo
                                    orderRemark:@""
                                   commodityIDs:@""
                                        payTool:payTool];
                    
                }else{ //  账户充值
                    if (self.phone.text.length == 0) {
                        [Common showMsgBox:@"" msg:L(@"InputNumber") parentCtrl:self];
                        return;
                    }
                    
                    [request applyOrderMobileNo:[AppDelegate getUserBaseData].mobileNo
                                      MerchanId:merchantId
                                      productId:productId
                                       orderAmt:price
                                      orderDesc:self.phone.text
                                    orderRemark:@""
                                   commodityIDs:@""
                                        payTool:payTool];
                }
                
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"OrderHasBeenSubmitted-PleaseLater")];
        }
        
    }
}

-(void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type
{
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"1001"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    if([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]){
        if (type == REQUSET_ORDER) {

            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OrderViewController *shopVc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
            shopVc.payWay = _payWay; //当刷卡支付时,设置刷卡方式
            orderData = [[OrderData alloc]initWithData:dict];
            orderData.orderAccount = [AppDelegate getUserBaseData].mobileNo;
            orderData.orderPayType = payType;
            orderData.merchantId = merchantId;
            orderData.productId = productId;
            orderData.orderDesc = [dict objectForKey:@"orderDesc"];
            orderData.mallOrder = NO;
            shopVc.orderData = orderData;
            
            for (UIViewController *v in self.navigationController.viewControllers) {
                if ([v isKindOfClass:[MallViewController class]]) {
                    shopVc.delegate = v;
                }
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController pushViewController:shopVc animated:YES];
            //            [self.navigationController presentViewController:shopVc animated:YES completion:nil];
        }
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view WithString:[dict objectForKey:@"respDesc"]];
    }
}

#pragma mark - tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ShoppingCartTableViewCell";
    ShoppingCartTableViewCell *cell =(ShoppingCartTableViewCell*) [sTableView dequeueReusableCellWithIdentifier:cellID];
    MallItem *dic    = CartArr[indexPath.row];
    
    [cell.shopCartMerchandiseImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic.iconurl]]];
    cell.shopCartMerchandiseName.text = dic.title;
    cell.shopCartMerchandisePrice.text = dic.price;
    cell.shopCartMerchandiseSum.text = dic.sum;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CartArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 147;
    
}

-(void)cancelFristResponder
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}
//取消第一响应者事件
- (void)keyboardHide
{
    [finalPrice resignFirstResponder];
}

#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:matchedStr];
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
