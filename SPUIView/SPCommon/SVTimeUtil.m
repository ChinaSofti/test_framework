//
//  TSTimeUtil.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVTimeUtil.h"

@implementation SVTimeUtil

/**
 *  获取当前系统秒级别时间戳
 *
 *  @return 当前系统秒级别时间戳
 */
+ (NSString *)currentTimeStamp
{
    long time = (long)[[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", time];
}

/**
 *  获取当前毫秒时间戳
 *
 *  @return 毫秒时间戳
 */
+ (long)currentMilliSecondStamp
{
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

/**
 *  将毫秒值改成日期格式
 *  @param timeNum 毫秒时间戳
 *  @param formatStr 日期格式
 *  @return 日期字符串
 */
+ (NSString *)formatDateByMilliSecond:(long)timeNum formatStr:(NSString *)formatStr
{
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:timeNum];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatStr];
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString;
}

@end
