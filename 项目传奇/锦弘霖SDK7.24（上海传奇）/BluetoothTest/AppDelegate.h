//
//  AppDelegate.h
//  BluetoothTest
//
//  Created by gui hua on 15/3/18.
//  Copyright (c) 2015年 szjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ViewController *viewController;


@end

