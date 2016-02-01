//
//  TSTimeUtil.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSTimeUtil.h"

@implementation TSTimeUtil

/**
 *  获取当前系统时间戳
 *
 *  @return 当前系统时间戳
 */

+ (NSString *)getCurTimeStamp
{
    long time;
    NSDate *fromdate = [NSDate date];
    time = (long)[fromdate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld", time];
}

@end
