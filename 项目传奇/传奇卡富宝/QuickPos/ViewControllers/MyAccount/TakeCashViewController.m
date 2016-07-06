//
//  TakeCashViewController.m
//  QuickPos
//
//  Created by Leona on 15/4/3.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "TakeCashViewController.h"
#import "XYSwitch.h"
#import "Common.h"
#import "WebViewController.h"
#import "HelpViewController.h"
#import "TradePwdView.h"
#import "RadioButton.h"
#import "Masonry.h"
@interface TakeCashViewController ()<ResponseData,TradePwdViewDelegate,UITextFieldDelegate>{
    
    NSTimer *timer;//倒计时
    
    int Second;//秒数
    
    Request*request;
    
    NSDictionary *dataDic;//请求返回字典
    
    NSString *availableAmtStr;//账户余额
    
    NSString *cashAvailableAmtStr;//可提现余额
    
    NSString *realNameStr;//用来取用户名
    
    NSString *newCardNumber;//截取卡号后的赋值
    
    NSString *picStr;//头像str
    
    int requestType;//请求标记
    
    UIImage *image;//GCD头像用
    
    NSData *data;//GCD转换数据库的头像用
    
    int buttonTag;//提现属性标记
    
    NSString *cashType;//提现类型
    Request *requstGet;
}
@property (weak, nonatomic)IBOutlet UIImageView *headImageView;//头像容器

@property (weak, nonatomic) IBOutlet UIView *infoView;//显示信息的容器view

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;//账户名

@property (weak, nonatomic) IBOutlet UILabel *accountBalanceLabel;//账户余额

@property (weak, nonatomic) IBOutlet UILabel *CanCashBalancesLabel;//可提现余额

@property (weak, nonatomic) IBOutlet UITextField *amountTextField;//提款金额输入框

@property (weak, nonatomic) IBOutlet UITextField *mobileMacTextField;//验证码输入框

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;//获取验证码按钮

@property (weak, nonatomic) IBOutlet UIButton *takeCashButton;//提现按钮

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//登入密码输入框

@property (weak, nonatomic) IBOutlet XYSwitch *normalButton;//普通提现

@property (weak, nonatomic) IBOutlet XYSwitch *fastButton;//快速提现
@property (nonatomic, strong)UIBarButtonItem *help;

@property (weak, nonatomic) IBOutlet UIButton *comfirt;

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet RadioButton *agreebtn;
@property (weak, nonatomic) IBOutlet UILabel *cashForTack;//手续费laber

@end

@implementation TakeCashViewController

@synthesize cardIdx;
@synthesize cardNumber;

- (IBAction)webBtn:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *b = [sb instantiateViewControllerWithIdentifier:@"WebViewController"];
    b.title = @"卡富宝交易通用规则";
    b.url = @"http://app.cqjrpay.com:8080/kafubao/protocol-2.html";
    [self.navigationController pushViewController:b animated:YES];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    requstGet = [[Request alloc]initWithDelegate:self];
    [requstGet getPhotoHeadImage];
    self.title = L(@"TakeCash");
    
    self.phone.text = [AppDelegate getUserBaseData].mobileNo;
    self.comfirt.layer.cornerRadius = 5;
    self.infoView.layer.masksToBounds = YES;
    self.infoView.layer.cornerRadius = 1;
    
    self.amountTextField.layer.masksToBounds = YES;
    self.amountTextField.layer.cornerRadius = 1;
    self.amountTextField.tag = 100909;
    self.amountTextField.delegate = self;
    
    
    self.passwordTextField.layer.masksToBounds = YES;
    self.passwordTextField.layer.cornerRadius = 1;
    
    self.getCodeButton.layer.masksToBounds = YES;
    self.getCodeButton.layer.cornerRadius = 5;
    
    
    self.takeCashButton.layer.masksToBounds = YES;
    self.takeCashButton.layer.cornerRadius = 5;
    
    self.takeCashButton.backgroundColor =[Common hexStringToColor:@"ebebeb"];
    self.takeCashButton.enabled = NO;
    [self.takeCashButton setTitleColor:[Common hexStringToColor:@"dcdcdc"] forState:UIControlStateNormal];
    
    self.mobileMacTextField.layer.masksToBounds = YES;
    self.mobileMacTextField.layer.cornerRadius = 1;
    
    self.help = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"phone_help"] style:UIBarButtonItemStylePlain target:self action:@selector(helpClick)];
    //    [self.navigationItem setRightBarButtonItem:self.help];
    
    
    
    requestType = 1;
    
    
    UIImageView * viewMask = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebarwhile"]];
    [self.headImageView addSubview:viewMask];
    [viewMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headImageView).insets(UIEdgeInsetsZero);
    }];

    
//    self.headImageView.layer.masksToBounds = YES;
//    self.headImageView.layer.cornerRadius = 35;
    
//    self.headImageView.frame = CGRectMake(20, 10, 60, 60);
//    self.headImageView.userInteractionEnabled = YES;
//    
//    [self.view addSubview:self.headImageView];
//    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20.f);
//        make.top.equalTo(self.view.mas_top).offset(10.f);
//        make.width.equalTo(@60.f);
//        make.height.equalTo(@60.f);
//    }];
    
    //获取到的卡号做截取后4位的操作
    
    newCardNumber = [cardNumber substringFromIndex:cardNumber.length-4];
    self.agreebtn.selected = YES;
    
    
    //键盘绑定
    
    //    NumberKeyBoard *numberkeyboard = [[NumberKeyBoard alloc]init];
    //    [numberkeyboard setTextView:self.amountTextField];
    //
    //    NumberKeyBoard *numberkeyboard2 = [[NumberKeyBoard alloc]init];
    //    [numberkeyboard2 setTextView:self.mobileMacTextField];
    
    
    
    [self.normalButton setOnImage:[UIImage imageNamed:@"xuanzeyuandian"] offImage:[UIImage imageNamed:@"yuandian"]];//设置图片
    
    [self.fastButton setOnImage:[UIImage imageNamed:@"xuanzeyuandian"] offImage:[UIImage imageNamed:@"yuandian"]];//设置图片
    
    buttonTag = 9;
    
    self.fastButton.on=YES;//默认快速提款
    
    if(self.fastButton.on){
        
        cashType = @"1";
        
        
    }
    _normalButton.hidden = YES;
    _fastButton.hidden = YES;
    
    
    
    
    request = [[Request alloc]initWithDelegate:self];
    
    
    
    [request userInfo:[AppDelegate getUserBaseData].mobileNo];//用户信息
    
    [request getVirtualAccountBalance:@"00" token:[AppDelegate getUserBaseData].token];//账户信息
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:L(@"MBPLoading")];
    [hud hide:YES afterDelay:2];
    
    
    
    
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (void)helpClick{
    HelpViewController *helpVc = [HelpViewController new];
    [self.navigationController pushViewController:helpVc animated:YES];
    
    //    WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    //    [web setTitle:L(@"help")];
    //    [web setUrl:WithdrawHelp];
    //    [self.navigationController pushViewController:web animated:YES];
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type{
    
    
    if(type == REQUSET_USERINFOQUERY && [dict[@"respCode"]isEqual:@"0000"] ){
        
        //用户名的返回
        
        dataDic = dict;
        
        NSMutableDictionary *getDic = [NSMutableDictionary dictionary];
        getDic = dict[@"data"];
        
        NSDictionary*realNameDic=[NSDictionary dictionary];
        realNameDic = getDic[@"resultBean"];
        
        realNameStr = realNameDic[@"realName"];
        
        self.NameLabel.text = realNameStr;
        
        picStr = realNameDic[@"pic"];
        
        //state = realNameDic[@"authenFlag"];
        
        
        //GCD操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            
            image = [UIImage imageWithData:[self headImage:picStr]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                if([picStr isEqual:@""]){
                    
//                    self.headImageView.image = [UIImage imageNamed:@"icon"];
                    
                }else{
                    
//                    self.headImageView.image = image;
                    
                }
                
            });
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        
        
    }else if(type == REQUEST_ACCTENQUIRY && [dict[@"respCode"]isEqual:@"0000"] ){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        //账户金额的返回
        
        dataDic = dict;
        double userSum = [[dict objectForKey:@"availableAmt"] doubleValue];
        double withdrawSum = [[dict objectForKey:@"cashAvailableAmt"] doubleValue];
        
        availableAmtStr = [NSString stringWithFormat:@"%0.2f",userSum/100];
        cashAvailableAmtStr = [NSString stringWithFormat:@"%0.2f",withdrawSum/100];
        
        self.accountBalanceLabel.text = availableAmtStr;
        self.CanCashBalancesLabel.text = cashAvailableAmtStr;
        self.amountTextField.placeholder = [NSString stringWithFormat:@"本次最多可转%@",cashAvailableAmtStr];
        
    }else if([dict[@"respCode"]isEqual:@"0000"] && type == REQUSET_JFPalCash){
        
        //提现的返回
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"TakeCashComplete")];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(back) userInfo:nil repeats:NO];
        
        
        
        
    }else if( type == REQUEST_GETFEERATE){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        int a = [[[dict objectForKey:@"data"] objectForKey:@"counterFee"] intValue]/100;
        NSString *aa = [NSString stringWithFormat:@"%d",a];
        float b = [aa floatValue];
        _cashForTack.text = [NSString stringWithFormat:@"%.2f元",b];    }

    else if([dict[@"respCode"]isEqual:@"0000"] && type == REQUEST_GETMOBILEMAC){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"VerificationCodeSentSuccessfully")];
        
    }
    else if (type == REQUEST_GETUPHEADIMAGEHEAD) {

        NSString *pic = dict[@"data"][@"pic"];
        if ([pic isKindOfClass:[NSNull class]]) {
        self.headImageView.image = [UIImage imageNamed:@"VW_UserCenter_HeadImage"];
        };
        
        NSString *urlstring = dict[@"data"][@"pic"][@"headpic"];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
        self.headImageView.image = img;
    }
    else {
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:dict[@"respDesc"]];
        
        
    }
    
}


- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}



- (IBAction)getcode:(UIButton *)sender {
    
    
    if ([self.amountTextField.text isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self.view WithString:@"提款金额不正确"];
        return;
    }
    
    
    Second = 60;
    
    [timer invalidate];
    
    timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeats) userInfo:nil repeats:YES];
    
    [request getMobileMacWithAccount:[AppDelegate getUserBaseData].mobileNo appType:@"JFPalAcctPay"];
    
    
    self.takeCashButton.backgroundColor =[Common hexStringToColor:@"14b9d5"];
    self.takeCashButton.enabled = YES;
    [self.takeCashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
}




- (void)repeats
{
    
    if (Second > 0)
    {  --Second;
        
        self.getCodeButton.enabled = NO;
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
        [self.getCodeButton setTitle:[NSString stringWithFormat:L(@"ToResendToSecond"),Second] forState:UIControlStateNormal];
        
    }else
    {
        [self.getCodeButton setBackgroundImage:[UIImage imageNamed:@"fasongyanzma2.png"] forState:UIControlStateNormal];
        self.getCodeButton.enabled =YES;
        
        [self.getCodeButton setTitle:[NSString stringWithFormat:L(@"ToResend")] forState:UIControlStateNormal];
        [self.getCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
    }
    
    
}

- (IBAction)takeCashAct:(UIButton *)sender {
    if([self.amountTextField.text isEqual:@""]){
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"TakeCashAmount")];
        return;
    }
    
    if(![Common isPureInt:self.amountTextField.text]){
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"AmountMustBeInteger")];
        return;
    }
    
    if([self.passwordTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputLoginPassward")];
        return;
        
    }
    if([self.mobileMacTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCode")];
        return;
    }
    
    if([Common isPureInt:self.amountTextField.text] && self.amountTextField.text.length >6){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"Highest")];
        return;
    }
    
    TradePwdView *tradePwdView = [[TradePwdView alloc]initWithFrame:self.view.bounds];
    tradePwdView.amountMoney.text = [NSString stringWithFormat:@"%@元",_amountTextField.text];
    tradePwdView.delegate = self;
    [self.view addSubview:tradePwdView];
    
}
- (void)tradePwdfinish:(NSString *)pwd{
    NSLog(@"%@",pwd);
    
    requestType = 7;
    //元转分
    float turnCash = [self.amountTextField.text floatValue];
    NSString *turnStr = [NSString stringWithFormat:@"%0.2f",turnCash];
    turnStr = [turnStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    [request takeCash:turnStr andPassword:pwd andMobileMac:self.mobileMacTextField.text andCashType:cashType andCardTag:newCardNumber andCardIdx:cardIdx];
    
}


-(NSData *)headImage:(NSString *)icon{
    
    int len = [icon length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i = 0; i < [icon length] / 2; i++) {
        byte_chars[0] = [icon characterAtIndex:i*2];
        byte_chars[1] = [icon characterAtIndex:i*2+1];
        * whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    data = [NSData dataWithBytes:buf length:len];
    
    
    return data;
}


- (IBAction)normalButtonAct:(UIButton *)sender {
    buttonTag = 9;
    
    if(buttonTag == 9){
        
        NSLog(@"开启");
        
        self.fastButton.on = NO;
        
        cashType = @"0";
        
        
    }else {
        
        NSLog(@"关闭");
    }
    
}

- (IBAction)fastButtonAct:(UIButton *)sender {
    
    buttonTag = 3;
    
    
    if(buttonTag == 3){
        
        NSLog(@"开启");
        
        self.normalButton.on = NO;
        
        cashType = @"1";
        
        
    }else {
        
        NSLog(@"关闭");
    }
    
    
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 100909) {//最少输入10元 限定
        if ([textField.text intValue] <10) {
            self.amountTextField.text = @"";
            self.amountTextField.placeholder = [NSString stringWithFormat:@"本次最多可转%@",cashAvailableAmtStr];
            [Common showMsgBox:@"" msg:@"提现不能少于10元" parentCtrl:self];
        }else{
            
            //元转分
            float turnCash = [self.amountTextField.text floatValue];
            NSString *turnStr = [NSString stringWithFormat:@"%0.2f",turnCash];
            turnStr = [turnStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            [request getFeerateWithVersionStatus:@"1" tradeDelay:@"1" money:turnStr];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES WithString:@"计算手续费中..."];

        }
        
        
        
    }
    
}
#pragma mark - 正则判断
- (BOOL)matchStringFormat:(NSString *)matchedStr withRegex:(NSString *)regex
{
    //SELF MATCHES一定是大写
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:matchedStr];
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

-(void)dealloc
{
    
}

@end
