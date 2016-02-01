//
//  TSYouKu__ysuid.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSTimeUtil.h"
#import "TSYouKu__ysuid.h"

@implementation TSYouKu__ysuid


+ (NSString *)getYsuid:(int)length
{

    NSString *ts = [TSTimeUtil getCurTimeStamp];
    return [ts stringByAppendingString:@"abc"];
}

@end
