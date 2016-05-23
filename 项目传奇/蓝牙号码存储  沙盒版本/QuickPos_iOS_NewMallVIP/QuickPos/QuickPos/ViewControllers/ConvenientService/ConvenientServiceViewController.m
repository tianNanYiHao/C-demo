//
//  ConvenientServiceViewController.m
//  YoolinkIpos
//
//  Created by 张倡榕 on 15/3/4.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "ConvenientServiceViewController.h"
#import "CollectionCell.h"
#import "BalanceEnquiryViewController.h"
#import "WaterElectricityCoalViewController.h"
#import "CreditCardPayViewController.h"
#import "LotteryViewController.h"
#import "WithdrawalViewController.h"
#import "PhoneRechargeViewController.h"
#import "QuickPosTabBarController.h"
#import "PayType.h"
#import "Request.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+Add.h"
#import "NoteViewController.h"
#import "RechargeViewController.h"
#import "TransferAccountViewController.h"
#import "SDCycleScrollView.h"
#import "Common.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "LoginViewController.h"
#import "ABCIntroView.h"
#import "RechargeFixedViewController.h"
#import "MangeMoneyViewController.h"
#import "EAIntroView.h"
#import "BigHongBaoViewControl.h"
#import "MyPosMangerViewController.h"
#import "ADIMageViewController.h"
#import "FlowRechargeViewController.h"

@interface ConvenientServiceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, ResponseData,SDCycleScrollViewDelegate,ABCIntroViewDelegate,EAIntroDelegate,UIAlertViewDelegate>
{
    NSMutableArray *vcArr;
    float contentY;
    UIView *rootView;
}
@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;

@property ABCIntroView *introView;
@property (nonatomic, strong) EAIntroView *intro;
@property (strong, nonatomic)NSMutableArray * menuDataArr;//数据源数组。
@property (weak, nonatomic) IBOutlet UIImageView *ADImage;

@end

@implementation ConvenientServiceViewController


- (void)awakeFromNib{
    
    
}
//轮播图创建
- (void)creatScrollView{
    
    // 情景一：采用本地图片实现
    NSArray *images = @[[UIImage imageNamed:@"banner1"],
                        [UIImage imageNamed:@"banner2"]
                        ];
    
    CGFloat w = self.view.bounds.size.width;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, w, 150) imagesGroup:images];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.delegate = self;
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.view addSubview:cycleScrollView];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}
- (void)addintro{
    
    /////用来判断第一次启动而是否加载引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"intro_screen_viewed"]) {
        
        self.navigationController.navigationBarHidden = YES;
        //引导页的的方法
        //        self.introView = [[ABCIntroView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //        self.introView.delegate = self;
        //        self.introView.backgroundColor = [UIColor blackColor];
        //        [self.view addSubview:self.introView];
        [self showIntroWithCustomView];
         self.tabBarController.tabBar.hidden = YES;
        
    }
    
}

- (void)updateVersion{
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"1ba1503d1226fb770c3c5d07b85ef2f5"];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
    //    NSLog(@"检查更新");
}
- (void)viewDidLoad {
    [super viewDidLoad];

    contentY = 0;
    self.menuCollectionView.alwaysBounceVertical = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    Request *req = [[Request alloc]initWithDelegate:self];
    rootView = self.view;
    
    
    [self creatADImage];
    
    
    
    //不需要登陆改成这样
    [self setUpCollection:nil isResult:NO];
    
    //    [req getChannelApplication];//原来的
    //    [self initViewController];
    //创建轮播图
//    [self creatScrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addintro];//引导图
    [self checkUpdate];//fir.im检查新版本
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateVersion) userInfo:nil repeats:YES];
    
}
-(void)creatADImage{
    _ADImage.image = [UIImage imageNamed:@"NewBaner"];
    
    _ADImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap =
    
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whenClickImage)];
    
    [_ADImage addGestureRecognizer:singleTap];

}
-(void)whenClickImage{
    ADIMageViewController *imageVc = [[ADIMageViewController alloc]init];
    imageVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imageVc animated:YES];
}

- (void)checkUpdate{
    
    NSString *idUrlString = @"http://api.fir.im/apps/latest/5620c9de748aac38b0000003?apiToken=f6a3137ee5b81cdbd8fb04ab48992c95";
    NSURL *requestURL = [NSURL URLWithString:idUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            //do something
        }else {
            NSError *jsonError = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (!jsonError && [object isKindOfClass:[NSDictionary class]]) {
                //do something
                
                NSString *localversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];//本地版本
                localversion = [localversion stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString  *newversion = [object objectForKey:@"versionShort"];//线上版本
                newversion = [newversion stringByReplacingOccurrencesOfString:@"." withString:@""];
                
                if ([newversion doubleValue] > [localversion doubleValue]) {
                    
                    
                    NSString *message = [NSString stringWithFormat:@"有新版本%@,%@,前往更新？",[object objectForKey:@"versionShort"],[object objectForKey:@"changelog"]];
                    UIAlertController *newVersion = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *comfirt =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        NSString *updateurl = [NSString stringWithFormat:@"%@",[object objectForKey:@"update_url"]];
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateurl]];
                    }];
                    [newVersion addAction:comfirt];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [newVersion addAction:cancel];
                    [self presentViewController:newVersion animated:YES completion:nil];
                    
                }
                
            }
        }
    }];
}
- (void)updateMethod:(NSDictionary *)dic{
    
    if(dic == nil) return;
    NSString *message = [NSString stringWithFormat:@"有新版本,是否更新？"];
    //    NSString *message = [NSString stringWithFormat:@"有新版本%@,是否更新？",[dic objectForKey:@"versionCode"]];
    UIAlertController *newVersion = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfirt =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *updateurl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"downloadURL"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateurl]];
    }];
    [newVersion addAction:comfirt];
    
    [self presentViewController:newVersion animated:YES completion:nil];
    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
}
- (IBAction)showSetup:(UIBarButtonItem *)sender {
    
    //登陆判断
    if ([[AppDelegate getUserBaseData].mobileNo length] > 0) {
        
        //已经登陆
        [(DDMenuController*)[(QuickPosTabBarController*)self.tabBarController parentCtrl] showRightController:YES];
        
    }else{
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"QuickPosNavigationController"];
        [self presentViewController:login animated:YES completion:nil];
    }
    
}

- (void)viewDidLayoutSubviews {
    //    self.navigationController.navigationBarHidden = YES;
}

-(void)setUpCollection:(NSDictionary*)dict isResult:(BOOL)isResult{
    self.menuDataArr = [NSMutableArray array];
    if (!isResult) {
        
        NSArray *titleArr = @[@"掌上商城",@"账户充值",@"即时取",@"转账汇款",@"水电煤",@"手机充值",@"流量充值",@"克拉充值",@"余额查询",@"红包",@"Pos管理"];
        NSArray *imageArr = @[@"serve_shopping",@"serve_payment",@"serve_take",@"serve_transfer",@"serve_Waterr",@"serve_phone",@"serve_traffic",@"karaRe",@"serve_query",@"redbag",@"serve_guanli"];
        NSArray *noteArr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray *channelArr = @[@"0001",@"0002",@"0003",@"0004",@"0005",@"0006",@"0007",@"0008",@"0009",@"00111",@"00112"];
        
        
        for(int index = 0;index < titleArr.count; index++){
            NSString *title = [titleArr objectAtIndex:index];
            NSString *image = [imageArr objectAtIndex:index];
            NSString *announce = [noteArr objectAtIndex:index];
            NSString *channelID = [channelArr objectAtIndex:index];
            NSDictionary *dic = @{@"image": image, @"title":title,@"announce":announce,@"channelID":channelID};
            [self.menuDataArr addObject:dic];
        }
    }else{
        for (NSDictionary *item in [dict objectForKey:@"channel"]) {
            NSString *title = [item objectForKey:@"channelTitle"];
            NSString *image = [item objectForKey:@"channelIconUrl"];
            NSString *announce = [item objectForKey:@"announce"];
            NSString *channelID = [item objectForKey:@"channelID"];
            NSString *isShow = [item objectForKey:@"isShow"];
            NSDictionary *dic = @{@"image": image, @"title":title,@"announce":announce,@"channelID":channelID,@"isShow":isShow};
            if (isShow.boolValue) {
                //                if ([channelID isEqualToString:@"0001"]) {
                //                    [self.menuDataArr insertObject:dic atIndex:0];
                //                }else{
                [self.menuDataArr addObject:dic];
                //                }
            }
        }
        
    }
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.dataSource = self;
    [self initViewController];
    [self.menuCollectionView reloadData];
    
    
}

-(void)initViewController{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    vcArr = [NSMutableArray array];
    for (NSDictionary *item in self.menuDataArr) {
        NSString *channelID = [item objectForKey:@"channelID"];
        if ([channelID isEqualToString:@"0009"]) {//余额查询
            BalanceEnquiryViewController *vc1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"BalanceEnquiryViewController"];
            vc1.item = item;
            [vcArr addObject:vc1];
        }
        else if ([channelID isEqualToString:@"0005"]) {//水电煤
            WaterElectricityCoalViewController *vc2 = [mainStoryboard instantiateViewControllerWithIdentifier:@"WaterElectricityCoalViewController"];
            vc2.item = item;
            [vcArr addObject:vc2];
        }
        else if ([channelID isEqualToString:@"0010"]) {//信用卡还款
            CreditCardPayViewController *vc3 = [mainStoryboard instantiateViewControllerWithIdentifier:@"CreditCardPayViewController"];
            vc3.item = item;
            vc3.destinationType = CREDIT;
            [vcArr addObject:vc3];
        }
        else if ([channelID isEqualToString:@"0007"]) {//流量充值
            FlowRechargeViewController *vc4 = [mainStoryboard instantiateViewControllerWithIdentifier:@"FlowRechargeID"];
            vc4.item = item;
            [vcArr addObject:vc4];
        }
     
        else if ([channelID isEqualToString:@"0004"]) {//转账汇款
            TransferAccountViewController *vc5 = [mainStoryboard instantiateViewControllerWithIdentifier:@"TransferAccountViewController"];
            vc5.item = item;
            [vcArr addObject:vc5];
            
            
        }
        else if ([channelID isEqualToString:@"0006"]) {//手机充值
            PhoneRechargeViewController *vc6 = [mainStoryboard instantiateViewControllerWithIdentifier:@"PhoneRechargeViewController"];
            vc6.item = item;
            [vcArr addObject:vc6];
        }
        else if ([channelID isEqualToString:@"0003"]) {//即时取
            WithdrawalViewController *vc61 = [mainStoryboard instantiateViewControllerWithIdentifier:@"WithdrawalVC"];
            vc61.item = item;
            vc61.destinationType = WITHDRAW;
            [vcArr addObject:vc61];
            
        }
        else if([channelID isEqualToString:@"0001"]){
            
            //            MallViewController *vc9 = [mainStoryboard instantiateViewControllerWithIdentifier:@"MallViewController"];
            //            vc9.item = item;
            //            [vcArr addObject:vc9]
            [vcArr insertObject:@"" atIndex:0];
        }
        else if ([channelID isEqualToString:@"0008"]){//克拉充值
            
            RechargeFixedViewController *vc8 = [mainStoryboard instantiateViewControllerWithIdentifier:@"RechargeFixedViewController"];
            vc8.item = item;
            [vcArr addObject:vc8];
        }
        //        else if ([channelID isEqualToString:@"0008"]){
        //
        //            RechargeViewController *vc9 = [mainStoryboard instantiateViewControllerWithIdentifier:@"RechargeViewController"];
        //            vc9.item = item;
        //            [vcArr addObject:vc9];
        //        }
        
        //        else if ([channelID isEqualToString:@"0004"])//理财
        //        {
        //            MangeMoneyViewController *vc11 = [mainStoryboard instantiateViewControllerWithIdentifier:@"MangeMoneyViewController"];
        //            [vcArr addObject:vc11];
        //        }
        else if ([channelID isEqualToString:@"00111"]){
            
            BigHongBaoViewControl *vc111 = [[BigHongBaoViewControl alloc] init];
            vc111.hidesBottomBarWhenPushed = YES;
            
            [vcArr addObject:vc111];
            
        }
//        else if([channelID isEqualToString:@"00112"]){
//            MyPosMangerViewController *vc112 = [[MyPosMangerViewController alloc] init];
//            vc112.hidesBottomBarWhenPushed = YES;
//            [vcArr addObject:vc112];
//        }
        
        else{
            NoteViewController *vc7 = [mainStoryboard instantiateViewControllerWithIdentifier:@"NoteViewController"];
            vc7.item = item;
            [vcArr addObject:vc7];
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ABCIntroViewDelegate Methods

- (void)onDoneButtonPressed{
    
    //    Uncomment so that the IntroView does not show after the user clicks "DONE"
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.introView.alpha = 0;
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        [self.introView removeFromSuperview];
        
    }];
}
#pragma mark - CollectionView Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collectionCellID = @"CollectionCellId";
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    //    int row = indexPath.row/3;
    //    int coloum  = indexPath.row%3;
    //    float cellWidth = SCREEN_WIDTH/3 - 10;
    //    float cellHeight = cellWidth;
    //    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y,cellWidth, cellHeight);
    NSDictionary *dic = self.menuDataArr[indexPath.row];
    NSString *image = dic[@"image"];
    NSString *title = dic[@"title"];
    //    NSString *announce = dic[@"announce"];
    //    NSString *isShow = dic[@"isShow"];
    //    NSString *channelID = dic[@"channelID"];
    
    if (indexPath.row == 0) {
        title = @"掌上商城";
    }
    
    if (![image hasPrefix:@"http"]) {
        [cell.imageView setImage:[UIImage imageNamed:image]];
    }else{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image]];
    }
    cell.titleLabel.text = title;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWidth = SCREEN_WIDTH/3 - 10;
    float cellHeight = cellWidth-20;
    
    return CGSizeMake(cellWidth, cellHeight);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //登陆判断
    if ([[AppDelegate getUserBaseData].mobileNo length] > 0) {
        //已经登陆
        NSString *str = [[self.menuDataArr objectAtIndex:indexPath.row] objectForKey:@"channelID"];
        if ([@"0002" isEqualToString:str]) {
            //        [self.tabBarController setSelectedIndex:0];
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RechargeViewController *vc1 = [mainStoryboard instantiateViewControllerWithIdentifier:@"RechargeViewController"];
            vc1.isRechargeView = YES;
            vc1.hidesBottomBarWhenPushed = YES;
            vc1.titleNmae = @"账户充值";
            vc1.moneyTitle = @"输入充值金额";
            vc1.comfirBtnTitle = @"确认充值";
            [self.navigationController pushViewController:vc1 animated:YES];
            
        }else if ([@"0001" isEqualToString:str]){
            
            [self.tabBarController setSelectedIndex:1];
        }else if ([@"00112" isEqualToString:str]){  //Pos管理
            
            MyPosMangerViewController *vc112 = [[MyPosMangerViewController alloc] init];
            vc112.hidesBottomBarWhenPushed = YES;
            [self presentModalViewController:vc112 animated:YES];
        }
        
        else {
            ((UIViewController*)vcArr[indexPath.row]).hidesBottomBarWhenPushed = YES;
            //    [self initViewController];
            [self.navigationController pushViewController:(UIViewController*)vcArr[indexPath.row] animated:YES];
            NSLog(@"%d",indexPath.row);
            NSLog(@"-- %@",vcArr[indexPath.row]);
        }
    }else{
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *login = [storyBoard instantiateViewControllerWithIdentifier:@"QuickPosNavigationController"];
        [self presentViewController:login animated:YES completion:nil];
    }
}

#pragma  mark 引导图
- (void)showIntroWithCustomView {
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help1.png"]];
    image1.frame = rootView.bounds;
    EAIntroPage *page1 = [EAIntroPage pageWithCustomView:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help2.png"]];
    image2.frame = rootView.bounds;
    EAIntroPage *page2 = [EAIntroPage pageWithCustomView:image2];
    
    CGFloat w = CGRectGetWidth(self.view.bounds);
    UIButton *lastguidebtn = [[UIButton alloc]initWithFrame:CGRectMake((w - 100)/2, rootView.bounds.size.height - 80, 100, 29)];
    [lastguidebtn setImage:[UIImage imageNamed:@"lastguidebtn.png"] forState:UIControlStateNormal];
    [lastguidebtn addTarget:self action:@selector(gotoMain:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help3.png"]];
    image3.frame = rootView.bounds;
    image3.userInteractionEnabled = YES;
    [image3 addSubview:lastguidebtn];
    EAIntroPage *page3 = [EAIntroPage pageWithCustomView:image3];
    
    self.intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3]];
    [self.intro.skipButton setTitle:@"跳过" forState:UIControlStateNormal];
    self.intro.skipButton.hidden = YES;
    [self.intro setDelegate:self];
    [self.intro showInView:rootView animateDuration:0.3];
}
-(void)gotoMain:(UIButton *)btn{
    [self.intro hideWithFadeOutDuration:0.3];
    [self introDidFinish];
}
- (void)introDidFinish:(EAIntroView *)introView {
    [self introDidFinish];
}
#pragma mark - Navigation
- (void)introDidFinish{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"forKey:@"intro_screen_viewed"];
    [defaults synchronize];
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.introView.alpha = 0;
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        [self.introView removeFromSuperview];
        
    }];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type {
    NSLog(@"dict %@",dict);
    if ([[dict objectForKey:@"respCode"]isEqualToString:@"0000"]) {
        
        if(type == REQUEST_GETCHANNELAPPLICATION){
            
            [self setUpCollection:[dict objectForKey:@"data"] isResult:NO];//设置为NO在本地加载
        }
    }else{
        [self setUpCollection:[dict objectForKey:@"data"] isResult:NO];
        //        [MBProgressHUD showHUDAddedTo:self.view WithString:@"网络不给力,正在重新请求。。。"];
        //        [self initViewController];
        //        Request *req = [[Request alloc]initWithDelegate:self];
        //        [req getChannelApplication];
    }
}

@end