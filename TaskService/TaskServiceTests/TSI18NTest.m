//
//  TSI18NTest.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TaskService.h"
#import <XCTest/XCTest.h>

@interface TSI18NTest : XCTestCase

@end

@implementation TSI18NTest


- (void)testExample
{
    NSString *value = I18N (@"aa");
    NSLog (@"%@", value);
}


@end
