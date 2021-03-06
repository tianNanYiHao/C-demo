//
//  Common.h
//  QuickPos
//
//  Created by 胡丹 on 15/3/23.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cloceBuleToothBlock)(id closeBlock);
typedef void(^cancle)(id cancleBlock);


@interface Common : NSObject


//判断是否为手机号码
+(BOOL)isPhoneNumber:(NSString*)phone;




//消息框
+(void)showMsgBox:(NSString*)title msg:(NSString*)msg parentCtrl:(id)ctrl;

//消息框执行
+(void)showMsgBox2:(NSString*)title msg:(NSString*)msg parentCtrl:(id)ctrl;


+(void)showMsgBox3:(NSString *)title msg:(NSString *)msg parentCtrl:(id)ctrl withBlock:(cloceBuleToothBlock)closeBlock withBloclCancle:(cancle)cancleBlock withTag:(NSInteger)tag;

+(void)showMsgBox4:(NSString *)title msg:(NSString *)msg parentCtrl:(id)ctrl withBlock:(cloceBuleToothBlock)closeBlock withTag:(NSInteger)tag uuidName:(NSString*)uuidName;


+ (NSString *)orderAmtFormat:(NSString*)orderAmt;
+ (NSString *)rerverseOrderAmtFormat:(NSString*)orderAmt;
+ (NSString*)bankCardNumSecret:(NSString*)cardNum;

+ (UIColor *) hexStringToColor: (NSString *) stringToConvert;

+ (void)setExtraCellLineHidden:(UITableView *)tableView;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (BOOL)isPureInt:(NSString*)string;

+ (NSString*)getCurrentVersion;

+ (UIImage *) createImageWithColor: (UIColor *) color;
@end
