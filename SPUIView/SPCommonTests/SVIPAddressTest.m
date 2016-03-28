//
//  SVIPAddressTest.m
//  SpeedPro
//
//  Created by Rain on 3/28/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVIPAddress.h"
#import <XCTest/XCTest.h>

@interface SVIPAddressTest : XCTestCase

@end

@implementation SVIPAddressTest


- (void)testExample
{
    NSLog (@"aaaaaaa");
    NSString *ipAddress = [SVIPAddress getIPAddress];
    NSLog (@"%@", ipAddress);
}


@end
