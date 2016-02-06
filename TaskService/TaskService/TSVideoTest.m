//
//  TSVideoTest.m
//  TaskService
//
//  Created by Rain on 2/1/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSLog.h"
#import "TSVideoAnalyser.h"
#import "TSVideoAnalyserFactory.h"
#import "TSVideoPlayer.h"
#import "TSVideoTest.h"
#import "TSVideoTestSummaryResult.h"

@implementation TSVideoTest
{
    @private

    //播放视频的 UIView 组建
    UIView *_showVideoView;

    // 视频播放器
    TSVideoPlayer *_videoPlayer;

    // 视频测试状态
    bool _finished;

    NSURL *_videoURL;
}

// 执行计算次数
const static int executeTotalTimes = 5;

- (id)initWithView:(UIView *)showVideoView
{
    _showVideoView = showVideoView;
    if (!_videoPlayer)
    {
        TSVideoAnalyser *analyser =
        [TSVideoAnalyserFactory createAnalyser:@"http://v.youku.com/v_show/id_XODMxMzYyMjgw.html"];
        TSVideoInfo *videoInfo = [analyser analyse];
        TSVideoSegement *segement = [videoInfo getAllSegement][0];
        NSString *videoPath = [segement videoSegementURL];
        TSInfo (@"videoPath:%@", videoPath);
        _videoURL = [NSURL fileURLWithPath:videoPath];
        //初始化播放器
        _videoPlayer = [[TSVideoPlayer alloc] initWithURL:_showVideoView videoPath:_videoURL];
    }

    return self;
}

- (void)startTest:(void (^) (TSVideoTestSectionResult *sectionResult, bool status, NSError *error))completionHandler
{
    // 获取视频URL

    @try
    {
        // 开始播放视频
        [_videoPlayer play];


        int i = 0;
        do
        {
            TSVideoTestSectionResult *sectionResult = [[TSVideoTestSectionResult alloc] init];
            //            sectionResult
            NSLog (@"publish section result %@", @"...");

            completionHandler (sectionResult, false, nil);
            [NSThread sleepForTimeInterval:5];
            i++;
        } while (i < executeTotalTimes);
        completionHandler (nil, true, nil);
    }
    @catch (NSException *exception)
    {
        TSError (@"%@", exception);
        // error = exception;
    }
    @finally
    {
        _finished = true;
        // 停止视频播放
        [_videoPlayer stop];
        TSInfo (@"%@", @"test finished");
    }
}

- (void)stopTest
{
    if (!_videoPlayer)
    {
        @try
        {
            //初始化播放器
            [_videoPlayer stop];
        }
        @catch (NSException *exception)
        {
            TSError (@"%@", exception);
        }
        @finally
        {
            //
            _finished = true;
        }
    }
}

@end
