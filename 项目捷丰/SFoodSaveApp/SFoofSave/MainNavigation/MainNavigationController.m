//
//  MainNavigationController.m
//  SFoofSave
//
//  Created by Lff on 16/8/3.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import "MainNavigationController.h"

@implementation MainNavigationController


-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName : [UIFont systemFontOfSize:17]};
    self.navigationBar.tintColor = [Common hexStringToColor:@"589e3e"];
    

    
//    self.navigationBar.translucent = NO;
//    self.navigationBar.backgroundColor = [Common hexStringToColor:@"f"];
    
}



    @end
