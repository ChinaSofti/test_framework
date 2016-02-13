//
//  SVSystemUtilTest.m
//  SPUIView
//
//  Created by Rain on 2/11/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVSystemUtil.h"
#import <XCTest/XCTest.h>

@interface SVSystemUtilTest : XCTestCase

@end

@implementation SVSystemUtilTest


- (void)testIsConnectionAvailable
{
    BOOL connection = [SVSystemUtil isConnectionAvailable];
    NSAssert (connection == YES, @"connection not available");
}

- (void)testGetConnectionType
{
    NetworkStatus status = [SVSystemUtil currentNetworkType];
    NSAssert (status == ReachableViaWiFi, @"network connection type not correct");
}


@end
