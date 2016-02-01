//
//  TSVideoTestTest.m
//  TaskService
//
//  Created by Rain on 2/1/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoTest.h"
#import <XCTest/XCTest.h>

@interface TSVideoTestTest : XCTestCase

@end

@implementation TSVideoTestTest

- (void)testExample
{
    TSVideoTest *t = [[TSVideoTest alloc] initWithView:nil];
    [t startTest:^(TSVideoTestSectionResult *sectionResult, bool status, NSError *error) {
      //
      NSLog (@"U-vMos:%lf  firstBufferTime:%f  cutton:%d   birate:%lf   screenResolution:%@ ",
             sectionResult.UvMos, sectionResult.firstBufferTime, sectionResult.cuttonTimes,
             sectionResult.birate, sectionResult.screenResolution);
      if (status)
      {
          NSLog (@"finished");
      }
    }];
}

@end
