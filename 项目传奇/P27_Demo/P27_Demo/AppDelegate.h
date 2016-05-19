//
//  AppDelegate.h
//  P27_Demo
//
//  Created by 爱笑 on 16/1/4.
//  Copyright © 2016年 爱笑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic)MainViewController *mainViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

