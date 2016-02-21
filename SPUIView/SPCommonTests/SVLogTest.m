//
//  SVLogTest.m
//  SPUIView
//
//  Created by Rain on 2/18/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVLog.h"
#import "SVTimeUtil.h"
#import <XCTest/XCTest.h>

@interface SVLogTest : XCTestCase

@end

@implementation SVLogTest

- (void)testLogInfo
{
    SVError (@"error message");
    SVWarn (@"warn message");
    SVInfo (@"info message");
    SVDebug (@"debug message");
}

- (void)testGetLogFilePath
{
    SVLog *log = [SVLog sharedInstance];
    NSString *logFile = [log getLogFilePath];
    NSAssert (logFile, @"logFile can't be null!");
}

- (void)testCompressLogFiles
{
    SVLog *log = [SVLog sharedInstance];
    NSString *compressedLogFile = [log compressLogFiles];
    NSAssert (compressedLogFile, @"compressed log file can't be null!");
    NSLog (@"compressed log file:%@", compressedLogFile);
}

- (void)testLogAsync
{
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      //
      for (int i = 0; i < 500000; i++)
      {
          //
          SVInfo (@"info message %ld", [SVTimeUtil currentMilliSecondStamp]);
      }

    });

    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      for (int i = 0; i < 500000; i++)
      {
          //
          SVError (@"error message %ld", [SVTimeUtil currentMilliSecondStamp]);
      }
    });
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      for (int i = 0; i < 500000; i++)
      {
          //
          SVDebug (@"debug message %ld", [SVTimeUtil currentMilliSecondStamp]);
      }
    });
    for (int i = 0; i < 5000000; i++)
    {
        //
        SVInfo (@"info message %ld", [SVTimeUtil currentMilliSecondStamp]);
    }
}

@end
