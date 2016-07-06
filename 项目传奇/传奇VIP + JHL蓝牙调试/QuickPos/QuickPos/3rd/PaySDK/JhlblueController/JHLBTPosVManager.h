//
//  JHLBTPosVManager.h
//  BluetoothTest
//
//  Created by Aotu on 16/6/7.
//  Copyright © 2016年 szjhl. All rights reserved.
//

#import <UIKit/UIKit.h>
enum{
    timeOutType1,   //一般情况下超时 
    timeOutType2,   //手机设备未开启蓝牙超时
    
};
@interface JHLBTPosVManager : NSObject

@property (nonatomic,strong) UIViewController *viewController;


-(instancetype)initwithType:(int)type withAmount:(NSString*)amount;
@end
