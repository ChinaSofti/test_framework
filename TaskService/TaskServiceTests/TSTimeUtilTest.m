//
//  TSTimeUtilTest.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//
#import "TSTimeUtil.h"
#import <XCTest/XCTest.h>

@interface TSTimeUtilTest : XCTestCase

@end

@implementation TSTimeUtilTest

- (void)testExample
{
    NSString *timestamp = [TSTimeUtil getCurTimeStamp];
    NSLog (@"curtimestamp: %@", timestamp);
}

@end
