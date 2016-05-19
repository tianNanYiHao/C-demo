//
//  AppDelegate.m
//  BluetoothTest
//
//  Created by gui hua on 15/3/18.
//  Copyright (c) 2015年 szjhl. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "JhlblueController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   // return YES;
    /*
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    NSLog(@"launchOptions = %@",[launchOptions description]); //seem launchOptions alway be nil when restore
    //if (launchOptions[UIApplicationLaunchOptionsBluetoothPeripheralsKey]) {
    //    [ISControlManager sharedInstance];
    //}
    //[[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    
    // Add the view controller's view to the window and display.
    //[window addSubview:viewController.view];
    ViewController *chat = [[[ViewController alloc] init] autorelease];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    nav.navigationBarHidden = YES;
    window.rootViewController = chat;
    //window.rootViewController = nav;
    NSLog(@"application");
    //	viewController.accessory = [self obtainAccessoryForProtocol:MFi_SPP_Protocol[0]];
    //    viewController.accessory2 = [self obtainAccessoryForProtocol:MFi_SPP_Protocol[1]];
    //    [viewController setAccessories];
     [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(acessoryDidConnectNotification:)
     name:EAAccessoryDidConnectNotification
     object:NULL];
     */
    //[window makeKeyAndVisible];
    return YES;

    
}

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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
