//
//  TSHttpGetterTest.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSHttpGetter.h"
#import <XCTest/XCTest.h>

@interface TSHttpGetterTest : XCTestCase

@end

@implementation TSHttpGetterTest

- (void)testExample
{
    [TSHttpGetter requestWithoutParameter:@"http://ip-api.com/json"];
}


@end
