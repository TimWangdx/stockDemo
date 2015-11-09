//
//  NSDate+Utility.h
//  GushiJianghu
//
//  Created by Wang on 15/9/18.
//  Copyright (c) 2015年 com.jijinwan. All rights reserved.
//

#import <Foundation/Foundation.h>

// 名字不知道怎么定义
typedef NS_ENUM(NSInteger, NSDateConvertType)
{
    NSDateConvertType_Unset,
    NSDateConvertType_One, // 2015-10-08
    NSDateConvertType_Two, // 10月08日
    NSDateConvertType_Three, // 2015-10-08 10:23
};

#define kInvalidTime            -1.0

@interface NSDate (Utility)

/**
 *  与当前时间比较,传入的参数是从服务器获取的 2015-10-25T00:00:00
 *
 *  @param dateString 例如 2015-10-25T00:00:00
 *
 *  @return 比较结果
 */
+ (NSComparisonResult)compareWithDateString:(NSString*)dateString;

/**
 *  与当前时间比较,传入的参数是从服务器获取的，得到剩余的时间。因为我是先用了第一个函数，所以参数的时间比当前时间大，晚
 *
 *  @param dateString dateString 例如 2015-10-25T00:00:00
 *
 *  @return 1天10小时
 */
+ (NSString*)remainTimeString:(NSString*)dateString;

/**
 *  得到当前时间 2015-10-25 00:00:00
 *
 *  @return 字符串 2015-10-25 00:00:00
 */
+ (NSString*)currentTime;
+ (NSString*)currentTimeForOrder;
/**
 *  返回紫1970以后的秒数
 *
 *  @return 秒数
 */
+ (NSString*)stringSince1970;
/**
 *  转化时间的形式  获取到下一个交易日的地日期格式如下 20150930
 *
 *  @param time 1.@“20150930”,2.@"10月08日" 3.2015-10-23 10:29
 *
 *  @return 2015-09-30
 */
+ (NSString*)convertTimeFromFormat:(NSString*)time convertType:(NSDateConvertType)type;

/**
 *  服务器 时间 2015-10-25T00:00:00 to 1.@“20150930”,2.@"10月08日" 3.2015-10-23 10:29
 *
 *  @param time 2015-10-25T00:00:00
 *  @param type 1.@“20150930”,2.@"10月08日" 3.2015-10-23 10:29
 *
 *  @return 1.@“20150930”,2.@"10月08日" 3.2015-10-23 10:29
 */
+ (NSString*)convertServerTime:(NSString*)time convertType:(NSDateConvertType)type;
/**
 *  转化时间的形式
 *
 *  @param time @"2015-10-09T11:00:00"
 *  @param type 1.@"10月08日"
 *
 *  @return 1.@"10月08日"
 */
+ (NSString*)convertGameTimeFromFormat:(NSString*)time convertType:(NSDateConvertType)type;

/**
 *  判断是否是上下午场
 *
 *  @param gameTime @"2015-10-25T00:00:00"
 *
 *  @return YES : 下午场，NO : 上午场
 */
+ (BOOL) isAfternoonRound:(NSString *)gameTime;

/**
 *  比较当前时间是否晚于今日的9点
 *
 *  @return YES:晚于9点，NO:早于9点
 */
+ (BOOL) isLaterThanNineOClock;
+ (BOOL) isLaterThanNineHalfOClock:(NSDate*)date;

/**
 *  获取游戏日期，格式如下 09月30日
 *
 *  @return 09月30日
 */
+ (NSString*)currentDayForGame;

/**
 *  获取本场游戏竞猜剩余时间,在8:30:00 和 09:00:00
 *
 *  @return 返回剩余时间 25：23，如果为空，则还没有开始倒计时
 */
+ (NSString*)remainTimeForGame;
/**
 *  获取本场游戏竞猜剩余时间,在8:30:00 和 09:00:00
 *
 *  @return 秒数
 */
+ (NSTimeInterval)remainTimeForGameInSeconds;

/**
 *  获取时间的秒数，以字符串的形式
 *
 *  @param dayTime dayTime @"2015-10-25 00:00:00"
 *
 *  @return 秒数
 */
+ (NSString*)stringFromSomeTime:(NSString*)dayTime;


/**
 *  测试函数
 *
 *  @param timeInterval 时间戳
 *
 *  @return 暂定
 */
+ (NSInteger)locationForTimeInterval:(NSString*)timeInterval;
@end
