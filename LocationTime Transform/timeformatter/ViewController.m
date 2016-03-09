//
//  ViewController.m
//  timeformatter
//
//  Created by Aotu on 15/11/18.
//  Copyright © 2015年 Aotu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    static NSString *GLOBAL_TIMEFORMAT = @"yyyy-MM-dd HH:mm:ss";
//    static NSString *GLOBAL_TIMEBASE = @"2012-01-01 00:00:00";
//    
//    NSTimeZone* localzone = [NSTimeZone localTimeZone];
//    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:GLOBAL_TIMEFORMAT];
//    [dateFormatter setTimeZone:GTMzone];
//    NSDate *bdate = [dateFormatter dateFromString:GLOBAL_TIMEBASE];
//    
//    NSDate *day = [NSDate dateWithTimeInterval:3600 sinceDate:bdate];
//    
//    [dateFormatter setTimeZone:localzone];
//    NSLog(@"CurrentTime = %@", [dateFormatter stringFromDate:day]);
//    
//    
//    
    
    //获取iOS当前时间 转换为全球范围内 时区的 时间
    //GMT+0800 东八区  GMT-0500 美国华盛顿DC西五区
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *now = [NSDate date];
//    NSLog(@"LocalTime now:%@", [dateFormatter stringFromDate:now]);
//    
//    // 也可直接修改NSDateFormatter的timeZone变量
//    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
//    
//    NSLog(@"changeTime now:%@", [dateFormatter stringFromDate:now]);
//    
    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyyMMdd-HHmmss"];
//    
//    
//    NSString*strDate = [format stringFromDate:date];
//    NSLog(@"now:%@",[strDate componentsSeparatedByString:@"-"]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"HHmmss"];
    NSString *currenttime = [dateFormatter1 stringFromDate:[NSDate date]];
    
    NSLog(@"localTimeDay:%@",currentDate);
    NSLog(@"localTimeTim:%@",currenttime);
    
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-0500"];
    dateFormatter1.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT-0500"];
     NSString *currentDate1 = [dateFormatter stringFromDate:[NSDate date]];
     NSString *currenttime1 = [dateFormatter1 stringFromDate:[NSDate date]];
    
    NSLog(@"changeTimeDay:%@",currentDate1);
    NSLog(@"changeTimeTim:%@",currenttime1);
    
    
    //http://blog.csdn.net/gilnuy0106/article/details/8451911
    
}
/*
 
 
 
 
 
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
