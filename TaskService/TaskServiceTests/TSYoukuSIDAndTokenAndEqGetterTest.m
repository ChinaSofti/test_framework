//
//  TSTest.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSYoukuSIDAndTokenAndEqGetter.h"
#import <XCTest/XCTest.h>

@interface TSYoukuSIDAndTokenAndEqGetterTest : XCTestCase

@end

@implementation TSYoukuSIDAndTokenAndEqGetterTest

- (void)testExample
{
    TSYoukuSIDAndTokenAndEqGetter *getter = [[TSYoukuSIDAndTokenAndEqGetter alloc]
    initWithEncrpytString:@"NQXVSgwdL77f0/DB9eJxU4b8vxtu1wXKXR0="
                      vid:@"XODMxMzYyMjgw"];
    NSLog (@"sid:%@  token:%@  eq:%@", getter.getSID, getter.getToken, getter.getEq);
}

@end
