//
//  JJWIndexRecords.m
//  stockDemo
//
//  Created by Wang on 15/11/6.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import "JJWIndexRecords.h"
#import "NSDate+Utility.h"

@implementation JJWIndexRecords

+ (NSArray*)indexRecordsWithArray:(NSArray*)array
{
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:array.count];
    for(NSArray *arr in array)
    {
        JJWIndexRecords *records = [[JJWIndexRecords alloc]initWithArray:arr];
        if([NSDate isLaterThanNineHalfOClock:records.time])
        {
            [models addObject:records];   
        }
    }
    return models;
}
- (instancetype)initWithArray:(NSArray*)array
{
    if(self = [super init])
    {
        self.timeStamp = array[0];
        self.value = array[1];
        NSTimeInterval t = [self.timeStamp doubleValue] / 1000;
        self.time = [NSDate dateWithTimeIntervalSince1970:t];
    }
    return self;
}

@end
