//
//  CTLogTest.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TaskService.h"
#import <XCTest/XCTest.h>

@interface CTLogTest : XCTestCase

@end

@implementation CTLogTest

- (void)testExample
{
    TSError (@"Name: %@", @"Rain");
    TSWarn (@"Name: %@", @"Rain");
    TSInfo (@"Name: %@", @"Rain");
    TSDebug (@"Name: %@", @"Rain");
}

@end
