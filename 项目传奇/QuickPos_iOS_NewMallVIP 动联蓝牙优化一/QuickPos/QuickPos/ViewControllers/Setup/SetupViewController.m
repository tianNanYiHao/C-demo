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
#import "OperationViewController.h"

#define SETUPCTRLX 50
#define SETUPCTRLY 50


typedef enum : NSUInteger {
    ShareType = 0,//分享
    FAQType,//FAQ
    ClearType,//清理缓存
    TipsType,//意见和反馈
    ContractType,//联系我们
    VersionType,//版本信息
    OperationType,//操作手册
} SetupType;


@interface SetupViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ResponseData,UMSocialUIDelegate,UMSocialDataDelegate>{
    CGRect originFrame;
    NSString *customerService;
    NSString *shortCompary;
    NSString *website;
    NSString *company;
    NSString *client_version;
    MBProgressHUD *hud;
}
@property(strong,nonatomic)NSMutableArray *setupArr;
@property(strong,nonatomic)NSMutableArray *setupImgArr;

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
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.
    self.setupArr = [NSMutableArray arrayWithObjects:L(@"Share"),L(@"FAQ"),L(@"ClearCache"),L(@"CommentsAndFeedback"),L(@"ContactUs"),L(@"Version"),L(@"Operation"),nil];
//    self.setupImgArr = [NSMutableArray arrayWithObjects:@"share",@"FAQ",@"qingli",@"yijian",@"lianxi",@"yonghu",nil];
    originFrame = self.view.frame;
//    [[[Request alloc] initWithDelegate:self] userAgreement];
//    hud = [MBProgressHUD showMessag:@"正在加载。。" toView:self.view];
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
    
    static NSString *cellIdentifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
//    cell.imageView.image = [UIImage imageNamed:self.setupImgArr[indexPath.row]];
    cell.textLabel.text = self.setupArr[indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:215/255.0 green:215/255. blue:215/255. alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    cell.alpha = 0.5;
    switch (indexPath.row) {
        case ShareType:{
//            [ShareView showShareView:self];
            
            [UMSocialData openLog:YES];
            
            //注意：分享到微信好友、微信朋友圈、微信收藏、QQ空间、QQ好友、来往好友、来往朋友圈、易信好友、易信朋友圈、Facebook、Twitter、Instagram等平台需要参考各自的集成方法
            //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
            [UMSocialSnsService presentSnsController:self
                                              appKey:@"5695bb63e0f55a6749000609"
                                           shareText:@"传奇金融VIP,让您理财更方便/快捷,http://www.pgyer.com/3zy8"                                          shareImage:[UIImage imageNamed:@"icon"]
                                     shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToAlipaySession, nil]
                                            delegate:self];
            

        }
            break;
        
        case FAQType:{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            NSString *url;
            if ([[[delegate getConfigDic] objectForKey:@"website"]hasPrefix:@"http"]) {
                url = [NSString stringWithFormat:@"%@",[[delegate getConfigDic] objectForKey:@"website"]];
            }else{
                url = [NSString stringWithFormat:@"http://%@",[[delegate getConfigDic] objectForKey:@"website"]];
            }
            WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
            web.url = url;
            web.navigationItem.title = L(@"FAQ");
            DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
            
            UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
            UINavigationController *ctr = (UINavigationController*)[tb selectedViewController];
            [menuController showRootController:YES];
            UIViewController *ctrl = [ctr visibleViewController];
            [web setHidesBottomBarWhenPushed:YES];
            [[ctrl navigationController] pushViewController:web animated:YES];

        }
            break;
        case ClearType:{
            [ClearUpView showVersionView:self];
//            [Common showMsgBox:@"清理缓存" msg:@"清理缓存将删您的账号信息，您确定要这样做吗？" parentCtrl:self];
//                if (iOS8) {
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"清理缓存将删您的账号信息，您确定要这样做吗？" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    //清理缓存
//                    
//                    
//                }];
//                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//                }];
//                
//                [alert addAction:defaultAction];
//                [alert addAction:cancelAction];
//                [self presentViewController:alert animated:YES completion:nil];
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"清理缓存" message:@"清理缓存将删您的账号信息，您确定要这样做吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.tag = ClearType;
//                [alert show];
//            
//                }
//            
            }
            break;
        case TipsType:{
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            NSString *url;
            if ([[[delegate getConfigDic] objectForKey:@"website"]hasPrefix:@"http"]) {
                url = [NSString stringWithFormat:@"%@",[[delegate getConfigDic] objectForKey:@"website"]];
            }else{
                url = [NSString stringWithFormat:@"http://%@",[[delegate getConfigDic] objectForKey:@"website"]];
            }
            
            WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
            web.url = url;
            web.navigationItem.title = L(@"CommentsAndFeedback");
            DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
            
            UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
            UINavigationController *ctr = (UINavigationController*)[tb selectedViewController];
            [menuController showRootController:YES];
            UIViewController *ctrl = [ctr visibleViewController];
            [web setHidesBottomBarWhenPushed:YES];
            [[ctrl navigationController] pushViewController:web animated:YES];
        }
            
            break;
        case ContractType:{
            [ContractView showVersionView:self];
//            ContractView *contract = [[ContractView alloc]init];
//            [self.view addSubview:contract];
            
//            [self presentViewController:contract animated:NO completion:^{
//                
//            }];
            
//            if(iOS8){
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"联系我们" message:@"公司网址：www.ddd.com \n 客服电话：12345678" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"访问官网" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    //访问官网
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
//                }];
//                UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    NSString *telUrl = @"telephone:12345678";
//                    NSURL *url = [[NSURL alloc] initWithString:telUrl];
//                    [[UIApplication sharedApplication] openURL:url];
//                }];
//                
//                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
//                }];
//                
//                [alert addAction:defaultAction1];
//                [alert addAction:defaultAction2];
//                [alert addAction:cancelAction];
//                [self presentViewController:alert animated:YES completion:nil];
//            
//            }else{
//            
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系我们" message:@"公司网址：www.ddd.com \n 客服电话：12345678" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"访问官网",@"拨打电话", nil];
//                alert.tag = ContractType;
//                [alert show];
//                
//            }
            
        }
            break;
        case VersionType:{
            [VersionView showVersionView:self];
        }
            break;
            
        case OperationType:{
            
            OperationViewController *operation = [[OperationViewController alloc]init];
            
           AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            NSString *url;
            if ([[[delegate getConfigDic] objectForKey:@"website"]hasPrefix:@"http"]) {
                url = [NSString stringWithFormat:@"%@",[[delegate getConfigDic] objectForKey:@"website"]];
            }else{
                url = [NSString stringWithFormat:@"http://%@",[[delegate getConfigDic] objectForKey:@"website"]];
            }
            
//            WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewController"];
////            web.url = url;
//            
//            web.url = @"http://www.chuanqijr.com/h-nd-120.html";
//            web.navigationItem.title = L(@"Operation");
            DDMenuController *menuController = (DDMenuController*)[QuickPosTabBarController getQuickPosTabBarController].parentCtrl;
            
            UITabBarController *tb = (UITabBarController*)[menuController rootViewController];
            UINavigationController *ctr = (UINavigationController*)[tb selectedViewController];
            [menuController showRootController:YES];
            UIViewController *ctrl = [ctr visibleViewController];
            [operation setHidesBottomBarWhenPushed:YES];
            [[ctrl navigationController] pushViewController:operation animated:YES];
        }
            break;
        default:
            break;
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
    [hud hide:YES];
    if (type == REQUEST_USERAGREEMENT && [@"0000" isEqualToString:[dict objectForKey:@"respCode"]]) {
        NSString *device = [[[dict objectForKey:@"data"] objectForKey:@"agreementInfo"] objectForKey:@"posDevice"];
        website = [dict objectForKey:@"website"];
        customerService = [dict objectForKey:@"customerService"];
        shortCompary = [dict objectForKey:@"shortCompary"];
        company = [dict objectForKey:@"company"];
        client_version = [dict objectForKey:@"client_version"];
        [AppDelegate getUserBaseData].device = device;
  
    }
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == ClearType) {
//        if (buttonIndex == 1) {
//            //清理缓存
//        }
//    }else if(alertView.tag == ContractType){
//        if (buttonIndex == 1){
//            //访问官网
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
//        }else if(buttonIndex == 2){
//            //拨打电话
//            NSString *telUrl = @"telephone:12345678";
//            NSURL *url = [[NSURL alloc] initWithString:telUrl];
//            [[UIApplication sharedApplication] openURL:url];
//
//        }else{
//        }
//    }
//    
//
//}


@end
