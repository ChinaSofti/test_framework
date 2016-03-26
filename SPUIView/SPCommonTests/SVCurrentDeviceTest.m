//
//  SVSystemUtilsTest.m
//  SpeedPro
//
//  Created by Rain on 3/26/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVCurrentDevice.h"
#import <XCTest/XCTest.h>

@interface SVCurrentDeviceTest : XCTestCase

@end

@implementation SVCurrentDeviceTest


- (void)testDeviceType
{
    NSString *deviceType = [SVCurrentDevice deviceType];
    NSLog (@"deviceType: %@", deviceType);
    NSAssert (deviceType, @"get device type fail!");
}


@end
