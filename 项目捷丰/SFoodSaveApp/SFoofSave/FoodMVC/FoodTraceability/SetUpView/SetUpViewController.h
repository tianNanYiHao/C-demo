//
//  SetUpViewController.h
//  SFoofSave
//
//  Created by Lff on 16/8/5.
//  Copyright © 2016年 Lff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SetUPviewControllerBlock)(id message);


@interface SetUpViewController : UIViewController
@property (nonatomic,strong)SetUPviewControllerBlock block;

- (void)getActionBlock:(SetUPviewControllerBlock)block;


@end
