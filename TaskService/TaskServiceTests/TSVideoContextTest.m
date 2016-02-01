//
//  TSVideoContextTest.m
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoContext.h"
#import <XCTest/XCTest.h>

@interface TSVideoContextTest : XCTestCase

@end

@implementation TSVideoContextTest

- (void)testExample
{
    TSVideoContext *context =
    [[TSVideoContext alloc] initWithVideoURLs:@"a\r\nb\r\nc\r\nd\r\ne\r\nf"];
    NSString *url = [context getOneOfURLs];

    NSLog (@"URL:%@", url);
}

@end
