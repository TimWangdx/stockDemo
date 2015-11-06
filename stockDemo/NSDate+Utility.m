//
//  NSDate+Utility.m
//  GushiJianghu
//
//  Created by Wang on 15/9/18.
//  Copyright (c) 2015年 com.jijinwan. All rights reserved.
//

#import "NSDate+Utility.h"

#define kDAY                    (60 * 60 * 24)
#define kHOUR                   (60 * 60)
#define kMINUTES                (60)

#define kNINEOCLOCK             @"09:00:00"
#define kEIGHTHALFOCLOCK        @"08:29:59"
#define KTWELVEOCLOCK           @"12:00:00"
#define kTestNineHalf           @"09:30:00"

@implementation NSDate (Utility)

+ (NSComparisonResult)compareWithDateString:(NSString*)dateString
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate* date = [formatter dateFromString:dateString];
    
    NSComparisonResult result = [currentDate compare:date];
    return result;
}

+ (NSString*)remainTimeString:(NSString*)dateString
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate* date = [formatter dateFromString:dateString];
    NSTimeInterval dateTime = [date timeIntervalSince1970];
    
    NSTimeInterval interval = dateTime - currentTime;
    
    NSInteger day = interval / kDAY;
    NSInteger hour = (interval - day * kDAY) / kHOUR;
    
    NSString *result = [NSString stringWithFormat:@"%@天%@小时", @(day),@(hour)];
    return result;
}

+ (NSString*)currentTime
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *currentTime = [formatter stringFromDate:currentDate];
    return currentTime;
}

+ (NSString*)currentTimeForOrder
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString *currentTime = [formatter stringFromDate:currentDate];
    return currentTime;
}

+ (NSString*)stringSince1970
{
    //1441960136703 ,1442217598356
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger timei  =  (NSInteger)time;
    NSString * timeStr = [NSString stringWithFormat:@"%@",@(timei)];
    return timeStr;
}

+ (NSString*)convertTimeFromFormat:(NSString*)time convertType:(NSDateConvertType)type;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *date = [formatter dateFromString:time];
    NSString *newTime = nil;
    if(type == NSDateConvertType_One)
    {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }
    else if(type == NSDateConvertType_Two)
    {
        [formatter setDateFormat:@"MM月dd日"];
    }
    else if(type == NSDateConvertType_Three)
    {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    newTime = [formatter stringFromDate:date];
    return newTime;
}

+ (NSString*)convertServerTime:(NSString*)time convertType:(NSDateConvertType)type
{
    time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    NSString *newTime = nil;
    if(type == NSDateConvertType_One)
    {
        [formatter setDateFormat:@"YYYY-MM-dd"];
    }
    else if(type == NSDateConvertType_Two)
    {
        [formatter setDateFormat:@"MM月dd日"];
    }
    else if(type == NSDateConvertType_Three)
    {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    }
    newTime = [formatter stringFromDate:date];
    return newTime;
}

+ (NSString*)convertGameTimeFromFormat:(NSString*)time convertType:(NSDateConvertType)type
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *newGameTime = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    // 参数所在时间
    NSDate* date = [formatter dateFromString:newGameTime];
    if(type == NSDateConvertType_Two)
    {
        [formatter setDateFormat:@"MM月dd日"];
        newGameTime = [formatter stringFromDate:date];
    }
    return newGameTime;
}

+ (BOOL) isLaterThanNineOClock
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *currentDate = [NSDate date];
    NSString *dayTime = [formatter stringFromDate:currentDate];
    dayTime = [NSString stringWithFormat:@"%@ %@",dayTime, kNINEOCLOCK];
    [formatter setDateFormat:@"YYYYMMdd HH:mm:ss"];
    NSDate *nineOClock = [formatter dateFromString:dayTime];
    NSComparisonResult result = [nineOClock compare:currentDate];
    if(result == NSOrderedDescending)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL) isLaterThanNineHalfOClock:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *currentDate = [NSDate date];
    NSString *dayTime = [formatter stringFromDate:currentDate];
    dayTime = [NSString stringWithFormat:@"%@ %@",dayTime, kTestNineHalf];
    [formatter setDateFormat:@"YYYYMMdd HH:mm:ss"];
    NSDate *nineOClock = [formatter dateFromString:dayTime];
    NSComparisonResult result = [nineOClock compare:date];
    if(result == NSOrderedDescending)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL) isAfternoonRound:(NSString *)gameTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *newGameTime = [gameTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    // 参数所在时间
    NSDate* date = [formatter dateFromString:newGameTime];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *tempTime = [formatter stringFromDate:date];
    tempTime = [NSString stringWithFormat:@"%@ %@",tempTime,KTWELVEOCLOCK];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // 参数所在的12点
    NSDate *twelveOclock = [formatter dateFromString:tempTime];
    
    NSComparisonResult result = [twelveOclock compare:date];
    if(result == NSOrderedDescending)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSString*)currentDayForGame
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate date];
    NSString *currentDay = [formatter stringFromDate:date];
    return currentDay;
}
+ (NSString*)remainTimeForGame
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *currentDate = [NSDate date];
    NSString *dayTime = [formatter stringFromDate:currentDate];
    NSString *nineOClockString = [NSString stringWithFormat:@"%@ %@",dayTime, kNINEOCLOCK];
    [formatter setDateFormat:@"YYYYMMdd HH:mm:ss"];
    NSDate *nineOClock = [formatter dateFromString:nineOClockString];
    
    NSString *eightHalfOClockString = [NSString stringWithFormat:@"%@ %@",dayTime, kEIGHTHALFOCLOCK];
    NSDate *eightHalfOClock = [formatter dateFromString:eightHalfOClockString];
    
    if([eightHalfOClock compare:currentDate] == NSOrderedAscending && [currentDate compare:nineOClock] == NSOrderedAscending)
    {
        NSTimeInterval nineTimeInterval = [nineOClock timeIntervalSince1970];
        NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
        NSTimeInterval interval = nineTimeInterval  - currentTimeInterval;
        
        NSInteger minutes = interval / kMINUTES;
        NSInteger seconds = (interval - minutes * kMINUTES);
        
        NSString *result = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes,(long)seconds];
        return result;
    }
    return nil;
}

+ (NSTimeInterval)remainTimeForGameInSeconds
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *currentDate = [NSDate date];
    NSString *dayTime = [formatter stringFromDate:currentDate];
    NSString *nineOClockString = [NSString stringWithFormat:@"%@ %@",dayTime, kNINEOCLOCK];
    [formatter setDateFormat:@"YYYYMMdd HH:mm:ss"];
    NSDate *nineOClock = [formatter dateFromString:nineOClockString];
    
    NSString *eightHalfOClockString = [NSString stringWithFormat:@"%@ %@",dayTime, kEIGHTHALFOCLOCK];
    NSDate *eightHalfOClock = [formatter dateFromString:eightHalfOClockString];
    
    if([eightHalfOClock compare:currentDate] == NSOrderedAscending && [currentDate compare:nineOClock] == NSOrderedAscending)
    {
        NSTimeInterval nineTimeInterval = [nineOClock timeIntervalSince1970];
        NSTimeInterval currentTimeInterval = [currentDate timeIntervalSince1970];
        NSTimeInterval interval = nineTimeInterval  - currentTimeInterval;
        
        return interval;
    }
    return kInvalidTime;
}

+ (NSString*)stringFromSomeTime:(NSString*)dayTime
{
     NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* someDate = [dateformatter dateFromString:dayTime];
    NSTimeInterval someSeconds = [someDate timeIntervalSince1970];
    
    NSInteger timei  =  (NSInteger)someSeconds;
    NSString *timeStr = [NSString stringWithFormat:@"%@",@(timei)];
    return timeStr;
}

@end
