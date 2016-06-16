//
//  NewProductDetailsViewController.h
//  QuickPos
//
//  Created by Aotu on 16/1/6.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewProductDetailsViewController : UIViewController


@property (nonatomic,strong) NSString *productID; //产品ID
@property (nonatomic,strong) UILabel *productDetail;//产品基本介绍
@property (nonatomic,strong) UILabel *productSMM; //产品说明
@property (nonatomic,strong) NSString *productInfoString; //基本信息
@property (nonatomic,strong) NSString *productSMMString ; //产品说明String


@property (nonatomic,strong)NSString *titleLabb;//
@property (nonatomic,strong)NSString *yearProfitt;//
@property (nonatomic,strong)NSString *lastMoneyy;//
@property (nonatomic,strong)NSString *qigouMoneyy;//
@property (nonatomic,strong)NSString *touziDayy;//
@property (nonatomic,strong)NSString *mujiOverDayy;//



@end
