//
//  SVVideoTest.m
//  SPUIView
//
//  Created by Rain on 2/6/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//
#import "SVDBManager.h"
#import "SVIPAndISPGetter.h"
#import "SVLog.h"
#import "SVProbeInfo.h"
#import "SVTestContextGetter.h"
#import "SVTimeUtil.h"
#import "SVVideoPlayer.h"
#import "SVVideoTest.h"

@implementation SVVideoTest
{
    @private

    // 测试ID
    long _testId;

    //播放视频的 UIView 组建
    UIView *_showVideoView;

    // 视频地址
    NSString *_videoPath;

    // 视频播放器
    SVVideoPlayer *_videoPlayer;

    // 测试状态
    TestStatus testStatus;
}

@synthesize testResult, testContext;

/**
 *  初始化视频测试对象，初始化必须放在UI主线程中进行
 *
 *  @param testId        测试ID
 *  @param showVideoView UIView 用于显示播放视频
 *
 *  @return 视频测试对象
 */
- (id)initWithView:(long)testId
     showVideoView:(UIView *)showVideoView
      testDelegate:(id<SVVideoTestDelegate>)testDelegate
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    _testId = testId;
    _showVideoView = showVideoView;
    testStatus = TEST_TESTING;

    if (!_videoPlayer)
    {
        //初始化播放器
        _videoPlayer =
        [[SVVideoPlayer alloc] initWithView:_showVideoView testDelegate:testDelegate];
    }
    SVInfo (@"SVVideoTest testID:%ld  showVideoView:%@", testId, showVideoView);
    return self;
}

/**
 *  初始化TestContext
 */
- (BOOL)initTestContext
{
    @try
    {
        // 初始化TestContext
        SVTestContextGetter *contextGetter = [SVTestContextGetter sharedInstance];
        testContext = [contextGetter getVideoContext];
        if (!testContext)
        {
            SVError (@"test[testId=%ld] fail. there is no test context", _testId);
            return false;
        }
        return true;
    }
    @catch (NSException *exception)
    {
        SVError (@"init test context fail:%@", exception);
        testStatus = TEST_ERROR;
        return false;
    }
}

/**
 *  开始测试
 */
- (BOOL)startTest
{
    @try
    {
        @synchronized (_videoPlayer)
        {
            if (testStatus == TEST_TESTING)
            {
                // 初始化TestResult
                if (!testResult)
                {
                    testResult = [[SVVideoTestResult alloc] init];
                    [testResult setTestId:_testId];
                    [testResult setTestTime:_testId];
                }


                // 开始播放视频
                [_videoPlayer setTestContext:testContext];
                [_videoPlayer setTestResult:testResult];
                [_videoPlayer play];
            }
        }

        while (!_videoPlayer.isFinished)
        {
            [NSThread sleepForTimeInterval:1];
        }

        SVInfo (@"test[%ld] finished", _testId);

        //        // 持久化结果和明细
        [self persistSVSummaryResultModel];
        [self persistSVDetailResultModel];
        SVInfo (@"persist test[testId=%ld] result success", _testId);
        return true;
    }
    @catch (NSException *exception)
    {
        SVError (@"start test video fail:%@", exception);
        testStatus = TEST_ERROR;
        return false;
    }
}

/**
 *   停止测试
 */
- (BOOL)stopTest
{
    @synchronized (_videoPlayer)
    {
        if (testStatus == TEST_TESTING)
        {
            testStatus = TEST_FINISHED;
        }

        if (_videoPlayer)
        {
            @try
            {
                //初始化播放器
                [_videoPlayer stop];
                SVInfo (@"stop test [testId=%ld]", _testId);
            }
            @catch (NSException *exception)
            {
                SVError (@"stop play video fail. %@", exception);
                return false;
            }
        }
    }

    return true;
}


/**
 *  持久化汇总结果
 */
- (void)persistSVSummaryResultModel
{
    // 结果持久化
    SVDBManager *db = [SVDBManager sharedInstance];
    // 如果表不存在，则创建表
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SVSummaryResultModel(ID integer PRIMARY KEY "
                      @"AUTOINCREMENT, testId integer, type integer, testTime integer, UvMOS "
                      @"real, loadTime integer, bandwidth real);"];

    NSString *insertSVSummaryResultModelSQL =
    [NSString stringWithFormat:@"INSERT INTO "
                               @"SVSummaryResultModel(testId,type,testTime,UvMOS,loadTime,"
                               @"bandwidth)VALUES(%ld, 0, %ld, %lf, %d, %lf);",
                               _testId, testResult.testTime, testResult.UvMOSSession,
                               testResult.firstBufferTime, testResult.downloadSpeed];
    // 插入汇总结果
    [db executeUpdate:insertSVSummaryResultModelSQL];
}


/**
 *  持久化结果明细
 */
- (void)persistSVDetailResultModel
{
    SVDBManager *db = [SVDBManager sharedInstance];
    // 如果表不存在，则创建表
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SVDetailResultModel(ID integer PRIMARY KEY "
                      @"AUTOINCREMENT, testId integer, testType integer, testResult text, "
                      @"testContext text, probeInfo text);"];

    NSString *insertSVDetailResultModelSQL =
    [NSString stringWithFormat:@"INSERT INTO "
                               @"SVDetailResultModel (testId,testType,testResult, testContext, "
                               @"probeInfo) VALUES(%ld, %d, "
                               @"'%@', '%@', '%@');",
                               _testId, VIDEO, [self testResultToJsonString],
                               [self testContextToJsonString], [self testProbeInfo]];
    // 插入结果明细
    [db executeUpdate:insertSVDetailResultModelSQL];
}

- (NSString *)testProbeInfo
{
    SVProbeInfo *probeInfo = [SVProbeInfo sharedInstance];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:probeInfo.ip forKey:@"ip"];
    [dictionary setObject:probeInfo.isp forKey:@"isp"];

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error)
    {
        SVError (@"%@", error);
        return @"";
    }
    else
    {
        NSString *resultJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return resultJson;
    }
}

- (NSString *)testResultToJsonString
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[[NSNumber alloc] initWithLong:testResult.testTime] forKey:@"testTime"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.sQualitySession]
                   forKey:@"sQualitySession"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.sInteractionSession]
                   forKey:@"sInteractionSession"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.sViewSession]
                   forKey:@"sViewSession"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.UvMOSSession]
                   forKey:@"UvMOSSession"];
    [dictionary setObject:[[NSNumber alloc] initWithLong:testResult.firstBufferTime]
                   forKey:@"firstBufferTime"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:testResult.videoCuttonTimes]
                   forKey:@"videoCuttonTimes"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:testResult.videoCuttonTotalTime]
                   forKey:@"videoCuttonTotalTime"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.downloadSpeed]
                   forKey:@"downloadSpeed"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:testResult.videoWidth]
                   forKey:@"videoWidth"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:testResult.videoHeight]
                   forKey:@"videoHeight"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.frameRate]
                   forKey:@"frameRate"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.bitrate] forKey:@"bitrate"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testResult.screenSize]
                   forKey:@"screenSize"];

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error)
    {
        SVError (@"%@", error);
        return @"";
    }
    else
    {
        NSString *resultJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return resultJson;
    }
}

- (NSString *)testContextToJsonString
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:testContext.videoSegementURLString forKey:@"videoSegementURLString"];
    //    [dictionary setObject:testContext.videoSegementURL forKey:@"videoSegementURL"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:testContext.videoSegementSize]
                   forKey:@"videoSegementSize"];
    [dictionary setObject:[[NSNumber alloc] initWithLong:testContext.videoSegementDuration]
                   forKey:@"videoSegementDuration"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:testContext.videoSegementBitrate]
                   forKey:@"videoSegementBitrate"];
    [dictionary setObject:testContext.videoSegementIP forKey:@"videoSegementIP"];
    [dictionary setObject:testContext.videoSegemnetLocation forKey:@"videoSegemnetLocation"];
    [dictionary setObject:testContext.videoSegemnetISP forKey:@"videoSegemnetISP"];

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error)
    {
        SVError (@"%@", error);
        return @"";
    }
    else
    {
        NSString *resultJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return resultJson;
    }
}

@end
