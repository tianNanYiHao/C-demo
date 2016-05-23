 //
//  AppDelegate.m
//  QuickPos
//
//  Created by 张倡榕 on 15/3/11.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "AppDelegate.h"
#import "UserBaseData.h"
#import "PosManager.h"
#import "Request.h"
#import "LocationManager.h"
#import "IQKeyboardManager.h"
#import "MyMessageViewController.h"
#import "Common.h"
#import "QuickPosTabBarController.h"
#import "SetupViewController.h"
#import "DDMenuController.h"
#import <BmobSDK/Bmob.h>
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

#define kViewControllerButtonPadding 10
#define kViewControllerButtonHeight 50
 
@interface AppDelegate ()<ResponseData,UIAlertViewDelegate,UMSocialDataDelegate,UMSocialUIDelegate>
{
//    NSString* versionId;
    NSString* updateUrl;
    NSDictionary *dataDic;
    NSString *later;
    
}
@property (nonatomic, copy) NSString *versionUrl;
@property (nonatomic, retain)NSDictionary *configDic;

@end
@implementation AppDelegate
@synthesize versionUrl;

- (void)responseWithDict:(NSDictionary *)dict requestType:(NSInteger)type {
    if (type == REQUEST_USERAGREEMENT && [@"0000" isEqualToString:[dict objectForKey:@"respCode"]]) {
        
        NSString *device = @"111101";
        
        NSDictionary *agreement = [[dict objectForKey:@"data"] objectForKey:@"agreementInfo"];
        if (agreement && [agreement isKindOfClass:[NSDictionary class]]) {
            device = [agreement objectForKey:@"posDevice"];
            NSDictionary *dic1 = [[dict objectForKey:@"data"] objectForKey:@"agreementInfo"];
            [[AppDelegate getUserBaseData] setWebsite:[dic1 objectForKey:@"website"]];
            [[AppDelegate getUserBaseData] setCustomerService:[dic1 objectForKey:@"customerService"]];
            [[AppDelegate getUserBaseData] setShortCompary:[dic1 objectForKey:@"shortCompary"]];
            [[AppDelegate getUserBaseData] setCompany:[dic1 objectForKey:@"company"]];
            [[AppDelegate getUserBaseData] setEmail:[dic1 objectForKey:@"email"]];
            [[AppDelegate getUserBaseData] setDownload:[dic1 objectForKey:@"download"]];
            self.configDic = [NSDictionary dictionaryWithObjectsAndKeys:[dic1 objectForKey:@"website"],@"website",[dic1 objectForKey:@"customerService"],@"customerService",[dic1 objectForKey:@"shortCompary"],@"shortCompary",[dic1 objectForKey:@"company"],@"company",[dic1 objectForKey:@"client_version"],@"client_version", nil];
            
        }
        //截取蓝牙设备判断一次蓝牙设备。
        NSString *blueToothDev = [device substringWithRange:NSMakeRange(device.length-2, 1)];
        if ([blueToothDev isEqualToString:@"1"]) {
            [[PosManager getInstance] getDevice:@"000010"];
        }
        
        //保存device数据并检测设备是否插入。
        [AppDelegate getUserBaseData].device = device;
        if ([[PosManager getInstance] getPluggedType])
        {
            [[PosManager getInstance] getDevice:device];
        }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int def = [[user objectForKey:defDeivecType] intValue];
        if (def <= 0 && def != -99) {
            def = -99;
            [user setObject:[NSNumber numberWithInt:def] forKey:defDeivecType];
            [user synchronize];
        }
        // 这里处理获取的频道信息
//        [[UserBaseData getInstance] setDevice:device];
    }
    if (type == REQUEST_CLIENTUPDATE && [@"0000" isEqualToString:[dict objectForKey:@"respCode"]]) {
        
        if([[dict objectForKey:@"application"] isEqualToString:@"ClientUpdate2.Rsp"]) {
            return [self handleClientUpdate2:dict];
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager];
    PosManager *pos = [PosManager getInstance];
    [pos posNotification];
    
    //友盟
    //APPkey:569de169e0f55a5b18000ad5
    [UMSocialData setAppKey:@"569de169e0f55a5b18000ad5"];

    
    //QQ分享
    //APP ID:1105051091  十六进制:41ddbdd3
    //APP KEY:21QqFBFmYxqIxUbC
    [UMSocialQQHandler setQQWithAppId:@"1105051091" appKey:@"21QqFBFmYxqIxUbC" url:@"http://www.pgyer.com/lkZH"];
    
    //微信
    //AppID：wxfa38d1a9da9f0753
    //AppSecret：7646ad242982fb4aaa3fc13abaca308e
    [UMSocialWechatHandler setWXAppId:@"wxfa38d1a9da9f0753" appSecret:@"7646ad242982fb4aaa3fc13abaca308e" url:@"http://www.pgyer.com/lkZH"];

    
    
    
    
    [Bmob registerWithAppKey:@"64631556f023608af2374be183d3a29f"];
//    BmobObject *gameScore = [BmobObject objectWithClassName:@"user"];
//    [gameScore setObject:@"ddddd" forKey:@"content"];
//    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        //进行操作
//    }];
    
//    NSBundle* mainBundle = [NSBundle mainBundle];
//    versionId = [[mainBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    
    [[[Request alloc] initWithDelegate:self] userAgreement];
    
    [[[Request alloc] initWithDelegate:self] ClientUpdateInstrVersion:[Common getCurrentVersion] dateType:@"json"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//状态栏白色
    
    if(![UIDevice currentDevice].isIOS6){
        
      [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];//去除导航返回的文字
    
    }

    if(iOS8){
        UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert)];
    }
    return YES;
}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
//    NSLog(@"---Token--%@", pToken);
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    
//    NSLog(@"userInfo == %@",userInfo);
//    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
//    [Common showMsgBox:@"提示" msg:message parentCtrl:self.window.rootViewController];
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
////    
////    [alert show];
//}

//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
//    
//    NSLog(@"Regist fail%@",error);
//}


-(void)handleClientUpdate2:(NSDictionary *)respData{
    NSDictionary *summary = [[respData objectForKey:@"data"] objectForKey:@"summary"];
    
    NSString *sVersion = [summary objectForKey:@"version"];
    NSString *appVersion = [Common getCurrentVersion];
    int intSV = [[sVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    int intAV = [[appVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    if([sVersion length]!=0 && intSV > intAV) {
        later = nil;
        updateUrl = [summary objectForKey:@"updateUrl"];
        if( [[summary objectForKey:@"must"] isEqualToString:@"y"] ) {
            later = nil;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"IsLoginNotification" object:[NSNumber numberWithBool:YES]];
        }
        else {
            later = L(@"Later");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"IsLoginNotification" object:[NSNumber numberWithBool:NO]];
        }
        self.versionUrl = [NSString stringWithString:[summary objectForKey:@"updateUrl"]];
        
        NSArray *desc = [respData objectForKey:@"resultBean"];
        NSMutableArray *s = [NSMutableArray array];
        
        [s addObject:L(@"Update")];
        for (NSDictionary *d in desc) {
            [s addObject:[d objectForKey:@"updateContent"]];
        }
        
        if(iOS8){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:L(@"NewVersion") message:[s componentsJoinedByString:@"\n"]  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:L(@"Confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                //版本更新url
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                
                exit(0);

            }];
            if (later != nil) {
                 UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:later style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];
            }

            [alert addAction:defaultAction];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:L(@"NewVersion") message:nil delegate:self cancelButtonTitle:later otherButtonTitles:L(@"Confirm"), nil];
//            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alert show];
        }
    }
    else {
        NSLog(@"暂时没有更新!");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"IsLoginNotification" object:[NSNumber numberWithBool:NO]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 1 || (buttonIndex == 0 && !later)) {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
    }
}
//
////通知
//
//-(void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
//   
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    MyMessageViewController * myMessageVC = [storyboard instantiateViewControllerWithIdentifier:@"MyMessageViewControllerVC"];
//    
//    [(UINavigationController *)self.window.rootViewController pushViewController:myMessageVC animated:YES];
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
//禁止横屏==============================================
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


+ (UserBaseData*)getUserBaseData{
    if(!userBaseData){
        userBaseData = [UserBaseData getInstance];
    }
    return userBaseData;
}

+(void)setUserBaseData:(UserBaseData*)_userBaseData{
    userBaseData = _userBaseData;
}

-(NSDictionary*)getConfigDic{

    return self.configDic;
}



@end
