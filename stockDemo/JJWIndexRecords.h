//
//  JJWIndexRecords.h
//  stockDemo
//
//  Created by Wang on 15/11/6.
//  Copyright © 2015年 com.jijinwan.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJWIndexRecords : NSObject

+ (NSArray*)indexRecordsWithArray:(NSArray*)array;

- (instancetype)initWithArray:(NSArray*)array;

@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) NSDate *time;
@end
