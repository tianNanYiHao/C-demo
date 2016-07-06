//
//  SigninViewController.m
//  YoolinkIpos
//
//  Created by 张倡榕 on 15/3/4.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "SigninViewController.h"
#import "QuickPosNavigationController.h"
#import "QuickPosTabBarController.h"
#import "DDMenuController.h"
#import "SetupViewController.h"
#import "LocationManager.h"
#import "RadioButton.h"

@interface SigninViewController ()<ResponseData>{
    
    int showpasswordChangeTag;//标记
    NSTimer *timer;//倒计时用
    int Second;//秒数
    Request *requst;
}
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;//账号输入框

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;//密码输入框

@property (weak, nonatomic) IBOutlet UITextField *comfirtPwdTextField;


@property (weak, nonatomic) IBOutlet UIButton *UserAgreementButton;//用户协议按钮

@property (weak, nonatomic) IBOutlet UIButton *ShowThePasswordButton;//显示密码

@property (weak, nonatomic) IBOutlet UIButton *verificationCodeButton;//获取验证码按钮

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;//验证码输入框

@property (weak, nonatomic) IBOutlet UIButton *registeredButton;//注册按钮

@property (weak, nonatomic) IBOutlet UIView *accountTextFieldBg;

@property (weak, nonatomic) IBOutlet UIView *passwordTextFieldBg;

@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property (weak, nonatomic) IBOutlet UIImageView *switchImage;
@property (weak, nonatomic) IBOutlet UINavigationItem *registNavGationitem;

@property (nonatomic, assign)NSString *hide;
@property (weak, nonatomic) IBOutlet RadioButton *btnlittle;

@end

@implementation SigninViewController


- (void)viewDidLoad {
    [super viewDidLoad];

     self.navigationController.navigationBar.hidden = YES;
    _btnlittle.selected = YES;
    requst = [[Request alloc]initWithDelegate:self];
    showpasswordChangeTag = 1;
    self.hide = @"1";
    self.codeBgView.layer.masksToBounds = YES;
    self.codeBgView.layer.cornerRadius = 1;
    
    self.accountTextFieldBg.layer.masksToBounds = YES;
    self.accountTextFieldBg.layer.cornerRadius = 1;
    
    self.passwordTextFieldBg.layer.masksToBounds = YES;
    self.passwordTextFieldBg.layer.cornerRadius = 1;
    
    self.verificationCodeButton.layer.masksToBounds = YES;
    self.verificationCodeButton.layer.cornerRadius = 4;
    
    self.registeredButton.layer.masksToBounds = YES;
    self.registeredButton.layer.cornerRadius = 5;
    
    self.switchImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOn:)];
    [self.switchImage addGestureRecognizer:tap];
    
    //自定义键盘
    //    NumberKeyBoard *numberkeyboard = [[NumberKeyBoard alloc]init];
    //    [numberkeyboard setTextView:self.accountTextField];
    //
    //    NumberKeyBoard *verificationCodenumberkeyboard = [[NumberKeyBoard alloc]init];
    //    [verificationCodenumberkeyboard setTextView:self.verificationCodeTextField];
    //
    //    SafeStringKeyBoard *strkeyboard = [[SafeStringKeyBoard alloc]init];
    //    [strkeyboard setTextView:self.passwordTextField];
    
    
    self.passwordTextField.secureTextEntry = YES;
    
}
- (IBAction)goBackPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [timer setFireDate:[NSDate distantPast]];//继续计时
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.hide isEqualToString:@"2"]) {
         self.navigationController.navigationBar.hidden = NO;
    }else{
         self.navigationController.navigationBar.hidden = YES;
    }
    self.navigationController.navigationBar.hidden = NO;
}



- (void)viewDidLayoutSubviews{
    self.navigationController.navigationBarHidden = NO;
}
//点击切换密码显示
- (void)tapOn:(UITapGestureRecognizer *)tap{
    
    //密码的可见显示
    if(showpasswordChangeTag == 1){
        self.passwordTextField.secureTextEntry = NO;
        showpasswordChangeTag = 2;
        self.switchImage.image = [UIImage imageNamed:@"login_abc_press"];
        
    }
    else{
        self.switchImage.image = [UIImage imageNamed:@"login_abc_nomal"];
        self.passwordTextField.secureTextEntry = YES;
        showpasswordChangeTag = 1;
    }
    
}


- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES)
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (IBAction)accountAct:(UITextField *)sender {
    
    
    
    
}
- (IBAction)UserAgreement:(UIButton *)sender {
    self.hide = @"2";
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *b = [sb instantiateViewControllerWithIdentifier:@"WebViewController"];
    b.title = @"使用协议";
    b.url = @"http://app.cqjrpay.com:8080/kafubao/protocol-1.html";
    [self.navigationController pushViewController:b animated:YES];
    
    
    
}
- (IBAction)getcode:(UIButton *)sender {
    
    Second = 60;
    [timer invalidate];
    timer = nil;
    if([self isMobileNumber:self.accountTextField.text]){
        
        [requst getMobileMacWithAccount:self.accountTextField.text appType:@"UserRegister"];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeats) userInfo:nil repeats:YES];
        
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectNumber")];
    }
    
}
//重复填写密码
- (void)repeats
{
    
    if (Second >0)
    {  --Second;
        
        self.verificationCodeButton.enabled = NO;
//        [self.verificationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:L(@"ToResendToSecond"),Second] forState:UIControlStateNormal];
    }
    else
    {
        //[self.verificationCodeButton setBackgroundImage:[UIImage imageNamed:@"fasongyanzma2.png"] forState:UIControlStateNormal];
        self.verificationCodeButton.enabled = YES;
        
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:L(@"ToResend")] forState:UIControlStateNormal];
//        [self.verificationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        
        
    }
    
}
- (IBAction)registereAct:(UIButton *)sender {
    
    
    if ([self.accountTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputAccount")];
        
    }else if (self.accountTextField.text.length < 11){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectNumber")];
        
    }else if (self.accountTextField.text.length > 11){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCorrectNumber")];
        
    }else if([_passwordTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCode")];
        
        
    }else if([_verificationCodeTextField.text isEqual:@""]){
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"InputCode")];
        
        
    }else if (![self.passwordTextField.text isEqualToString:self.comfirtPwdTextField.text]){
      [MBProgressHUD showHUDAddedTo:self.view WithString:@"两次密码不一致"];
    }
    else{
        
        [requst userSignWithAccount:self.accountTextField.text password:self.passwordTextField.text mobileMac:_verificationCodeTextField.text];
        
        
    }
    
}


- (void)back{
    
    [requst userLoginWithAccount:self.accountTextField.text password:self.passwordTextField.text];
    
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type {
    
    if ([dict[@"respCode"] isEqualToString:@"0000"]) {
        if (type == REQUEST_USERREGISTER) {
            
            [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"SigninSuccessful")];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(back) userInfo:nil repeats:NO];
            
        }
        else if(type == REQUEST_USERLOGIN){
            
            UserBaseData *u = [[UserBaseData alloc]initWithData:dict];
            
            [AppDelegate getUserBaseData].token = u.token;
            
            [AppDelegate getUserBaseData].userName = u.userName;
            
            [AppDelegate getUserBaseData].userType = u.userType;
            
            [AppDelegate getUserBaseData].mobileNo = u.mobileNo;
            
            [AppDelegate getUserBaseData].token = u.token;
            
            [AppDelegate getUserBaseData].pic = u.pic;
            
            [[LocationManager instance] startLocationManager:^(float lon, float lat) {
                [AppDelegate getUserBaseData].lon = lon;
                [AppDelegate getUserBaseData].lat = lat;
            }];
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            QuickPosTabBarController *quick = [storyBoard instantiateViewControllerWithIdentifier:@"QuickPosTabBarController"];
            
            SetupViewController  *setupCtrl = [storyBoard instantiateViewControllerWithIdentifier:@"SetupViewController"];
            
            DDMenuController *dd = [[DDMenuController alloc]initWithRootViewController:quick];
//            dd.rightViewController = setupCtrl;
            dd.leftViewController = setupCtrl;
            quick.parentCtrl = dd;
            
            
            //通过通知中心发送通知,注册成功后清空账号和密码
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanText" object:nil];
            
            
            [self.navigationController presentViewController:dd animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:NO];
            }];
            
        }
        else if(type == REQUEST_GETMOBILEMAC){
            [MBProgressHUD showHUDAddedTo:self.view WithString:L(@"VerificationCodeSentSuccessfully")];
        }
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view WithString:dict[@"respDesc"]];
    }
    
    
}

//- (void)viewDidDisappear:(BOOL)animated{
//    if (timer) {
//        [timer invalidate];
//        timer = nil;
//    }
//    
//}

@end
