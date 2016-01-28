//
//  TSIPAndISPGetterTest.m
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TSIPAndISPGetter.h"

@interface TSIPAndISPGetterTest : XCTestCase

@end

@implementation TSIPAndISPGetterTest


- (void)testExample
{
    TSIPAndISP *ipAndISP = [TSIPAndISPGetter getIPAndISP];
    NSLog (@"AS:%@", ipAndISP.as);
}

@end
