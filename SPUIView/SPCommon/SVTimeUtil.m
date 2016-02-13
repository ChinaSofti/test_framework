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
 *  获取当前系统时间戳
 *
 *  @return 当前系统时间戳
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

@end
