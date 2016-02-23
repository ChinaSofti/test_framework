//
//  SVLogUploaderTest.m
//  SpeedPro
//
//  Created by Rain on 2/23/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

//
#import "SVLog.h"
#import "SVLogUploader.h"
#import <XCTest/XCTest.h>

@interface SVLogUploaderTest : XCTestCase

@end

@implementation SVLogUploaderTest

- (void)testExample
{
    SVLogUploader *uploader = [[SVLogUploader alloc] init];
    [uploader upload];
}

@end
