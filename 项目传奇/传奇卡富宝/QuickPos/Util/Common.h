//
//  Common.h
//  QuickPos
//
//  Created by 胡丹 on 15/3/23.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^payWayBlock)(NSString* payWayStr);


@interface Common : NSObject

//判断是否为手机号码
+(BOOL)isPhoneNumber:(NSString*)phone;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//消息框
+(void)showMsgBox:(NSString*)title msg:(NSString*)msg parentCtrl:(id)ctrl;

+ (NSString *)orderAmtFormat:(NSString*)orderAmt;
+ (NSString *)rerverseOrderAmtFormat:(NSString*)orderAmt;
+ (NSString*)bankCardNumSecret:(NSString*)cardNum;

+ (UIColor *) hexStringToColor: (NSString *) stringToConvert;

+ (void)setExtraCellLineHidden:(UITableView *)tableView;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (BOOL)isPureInt:(NSString*)string;

+ (NSString*)getCurrentVersion;

+ (UIImage *) createImageWithColor: (UIColor *) color;

+(NSString *)payWayChangePayWayBlocl:(payWayBlock)payblock;

@end
