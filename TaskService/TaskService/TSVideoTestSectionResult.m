//
//  TSVideoTestSectionResult.m
//  TaskService
//
//  Created by Rain on 2/1/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoTestSectionResult.h"

@implementation TSVideoTestSectionResult

- (id)init
{
    // 构造假数据
    self.screenResolution = [[NSString alloc] initWithFormat:@"%@", @"1080*1920"];
    self.birate = [self getFakeFloatData:1000 max:3000];
    self.UvMos = [self getFakeFloatData:1 max:5];
    self.firstBufferTime = [self getFakeFloatData:1000 max:3000];
    self.cuttonTimes = [self getFakeIntData:0 max:10];

    return self;
}

- (float)getFakeFloatData:(float)min max:(float)max
{
    //    int s_seed = 1;
    //    s_seed = 214013 * s_seed + 2531011;
    //    return min + (s_seed >> 16) * (1.0f / 65535.0f) * (max - min);
    int startVal = min * 10000;
    int endVal = max * 10000;

    int randomValue = startVal + (arc4random () % (endVal - startVal));
    float a = randomValue;

    return (a / 10000.0);
}

- (int)getFakeIntData:(int)min max:(int)max
{
    int value = (arc4random () % max) + 1;
    NSLog (@"value:%d", value);
    return value;
}


@end
