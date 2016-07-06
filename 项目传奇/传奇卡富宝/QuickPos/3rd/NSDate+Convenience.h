//
//  NSDate+Convenience.h
//  veryWallen
//
//  Created by qiuqiu's imac on 14-9-22.
//  Copyright (c) 2014年 qiuqiu's imac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Convenience)
- (NSUInteger)daysAgo;
-(NSDate *)offsetMonth:(int)numMonths;
-(NSDate *)offsetDay:(int)numDays;
-(NSDate *)offsetHours:(int)hours;
-(NSUInteger)numDaysInMonth;
-(NSUInteger)firstWeekDayInMonth;
-(NSUInteger)year;
-(NSUInteger)month;
-(NSUInteger)day;

+(NSDate *)dateStartOfDay:(NSDate *)date;
+(NSDate *)dateStartOfWeek;
+(NSDate *)dateEndOfWeek;
+(BOOL)isEqulToToday:(NSDate*)date;
+(NSUInteger)fromDate:(NSDateComponents*)fromDate toDate:(NSDateComponents*)date;
+(NSString*)retrunWeekByDate:(NSString*)date;
+(NSDate*)dateByString:(NSString*)string AndFromat:(NSString*)format;
+(NSString*)stringByDate:(NSDate*)date AndFromat:(NSString*)format;
+(NSDate*)dateByComment:(NSDateComponents*)cmoppon;


+(NSString*)getTime;
+(NSString*)lastDateString;
+(NSInteger)hour:(NSDate*)date;

@end
