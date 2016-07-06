//
//  chooseBankCardListController.h
//  QuickPos
//
//  Created by Aotu on 16/7/5.
//  Copyright © 2016年 张倡榕. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^chooseBankCardListControllerBlocl)(id chooseBankCardNum);
@interface chooseBankCardListController : UIViewController
@property (nonatomic,strong) chooseBankCardListControllerBlocl chooseBankCardNumBlock;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,assign)NSUInteger destinationType;

@property (weak, nonatomic) IBOutlet UILabel *Notes;

@property (retain, nonatomic) NSDictionary *item;

-(void)chooseBankCardNumBlock:(chooseBankCardListControllerBlocl)block;
@end
