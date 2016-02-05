//
//  TSVideoAnalyserFactoryTest.m
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoAnalyserFactory.h"
#import <XCTest/XCTest.h>

@interface TSVideoAnalyserFactoryTest : XCTestCase

@end

@implementation TSVideoAnalyserFactoryTest

- (void)testExample
{
    TSVideoAnalyser *analyser =
    [TSVideoAnalyserFactory createAnalyser:@"http://v.youku.com/v_show/id_XODMxMzYyMjgw.html"];
    TSVideoInfo *videoInfo = [analyser analyse];
    NSLog (@"%@", videoInfo._videoRealURL);
}

@end
