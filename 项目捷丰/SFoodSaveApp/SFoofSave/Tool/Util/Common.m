//
//  Common.m
//  QuickPos
//
//  Created by 胡丹 on 15/3/23.
//  Copyright (c) 2015年 张倡榕. All rights reserved.
//

#import "Common.h"
#import "PSTAlertController.h"
@implementation Common

+(BOOL)isPhoneNumber:(NSString*)phone{

    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:phone] == YES)
        
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(void)showMsgBox:(NSString*)title msg:(NSString*)msg parentCtrl:(id)ctrl{
    if(iOS8){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alert addAction:defaultAction];
        [(UIViewController*)ctrl presentViewController:alert animated:YES completion:nil];
    
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    
    }
    
}

+ (NSString *)orderAmtFormat:(NSString*)orderAmt{
    NSString *newOrderAmt = [NSString stringWithFormat:@"%.2f",orderAmt.doubleValue];
    newOrderAmt = [newOrderAmt stringByReplacingOccurrencesOfString:@"." withString:@""];
    return newOrderAmt;
}

+ (NSString *)rerverseOrderAmtFormat:(NSString*)orderAmt{
    NSString *newOrderAmt = [NSString stringWithFormat:@"%.2f",[orderAmt doubleValue]/100];
    return newOrderAmt;
}

+ (NSString*)bankCardNumSecret:(NSString*)cardNum{
    for (int i = 0 ; i < cardNum.length - 4;i ++) {
        cardNum = [cardNum stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
    }
    return cardNum;
}

//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}

+ (void)setExtraCellLineHidden:(UITableView *)tableView//隐藏多余的分割线
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
}


//图片压缩
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

//判断整数
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (NSString *)getCurrentVersion {
    NSString *version = @"";
    version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

+(void)pstaAlertWithTitle:(NSString*)title message:(NSString*)message defaultTitle:(NSString*)defaultTitle cancleTitle:(NSString*)cancaleTitle defaultBlock:(CommonShowBoxdefaultBlock)defaultBlock CancleBlock:(CommonShowBoxcancleBlock)cacleBlock ctr:(UIViewController*)ctrller{
    
    PSTAlertController *past = [PSTAlertController alertWithTitle:title message:message];
    [past addAction:[PSTAlertAction actionWithTitle:defaultTitle handler:^(PSTAlertAction * _Nonnull action) {
        defaultBlock(action);
    } ]];

    [past addAction:[PSTAlertAction actionWithTitle:cancaleTitle handler:^(PSTAlertAction * _Nonnull action) {
        cacleBlock(action);
    }]];
     [past showWithSender:nil controller:ctrller animated:YES completion:NULL];
    
}


@end
