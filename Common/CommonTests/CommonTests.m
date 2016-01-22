//
//  CommonTests.m
//  CommonTests
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "CTCommon.h"

#import <XCTest/XCTest.h>

@interface CommonTests : XCTestCase

@end

@implementation CommonTests

//CTLog* L = nil;

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    CTError(@"aaa Rain");
    //NSLog(s);
    //(@"hi test ");
}

- (void)testPerformanceExample
{
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
