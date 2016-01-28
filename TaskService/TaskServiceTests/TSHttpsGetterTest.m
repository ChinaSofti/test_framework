//
//  TSHttpsGetter.m
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSHttpsGetter.h"
#import <XCTest/XCTest.h>

@interface TSHttpsGetterTest : XCTestCase

@end

@implementation TSHttpsGetterTest

- (void)testExample
{

    TSHttpsGetter *gettter = [[TSHttpsGetter alloc]
    initWithURLNSString:@"https://58.60.106.188:12210/speedpro/configapi?lang=CN"];
    NSLog (@"Heeloe");
}

@end
