//
//  TSContextGetterTest.m
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSContextGetter.h"
#import "TSIPAndISP.h"
#import <XCTest/XCTest.h>

@interface TSContextGetterTest : XCTestCase

@end

@implementation TSContextGetterTest

- (void)testExample
{
    TSIPAndISP *ipAndISP = [[TSIPAndISP alloc] init];
    [ipAndISP setCountryCode:@"CN"];
    TSContextGetter *getter = [[TSContextGetter alloc] initWithIPAndISP:ipAndISP];
    [getter requestForData];
    [getter parseData];
    TSVideoContext *videoContext = [getter getVideoContext];
    NSLog (@"videoContext URL:%@", [videoContext getOneOfURLs]);
}


@end
