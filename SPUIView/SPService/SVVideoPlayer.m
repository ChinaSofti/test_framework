//
//  VideoPlayer.m
//  TaskService
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVLog.h"
#import "SVProbeInfo.h"
#import "SVTimeUtil.h"
#import "SVVideoPlayer.h"
#import "SVVideoUtil.h"

#define FITWIDTH(W) W / 320.0 * ([UIScreen mainScreen].bounds.size.width)
#define FITHEIGHT(H) H / 568.0 * ([UIScreen mainScreen].bounds.size.height)

@implementation SVVideoPlayer
{
    // 视频是否准备好，可以进行播放
    BOOL _didPrepared;

    // 第三方视频播放对象
    VMediaPlayer *_VMpalyer;

    // 首次缓冲开始毫秒时间戳
    long _firstBufferTime;

    // 开始缓冲时间
    long _bufferStartTime;

    // 总下载大小
    int _downloadSize;
    // 总下载时长
    int _downloadTime;

    // 每5秒周期卡顿次数
    int videoCuttonTimes;
    // 每5秒周期卡顿总时长
    int videoCuttonTotalTime;

    // 缓冲时间集合
    NSMutableArray *bufferedTimeArray;

    // 加载图标
    UIActivityIndicatorView *activityView;

    // 每隔5秒推送一次结果
    id<SVVideoTestDelegate> _testDelegate;

    // 定时器
    NSTimer *timer;

    // 计算UvMOS次数
    int execute_times;

    BOOL isFinished;

    long startPlayTime;

    BOOL _isSetup;

    int _videoPlayTime;
}

@synthesize showOnView, testResult, testContext, uvMOSCalculator;

// 样本时长5秒
static const int test_period = 5;

// 计算UvMOS总次数
static int execute_total_times = 4;

/**
 *  初始化视频播放器对象
 *
 *  @param showOnView 视频在指定的UIView上进行展示并进行播放
 *
 *  @return 视频播放器对象
 */
- (id)initWithView:(UIView *)_showOnView testDelegate:(id<SVVideoTestDelegate>)testDelegate;
{
    showOnView = _showOnView;
    [self addLoadingUIView:showOnView];
    _testDelegate = testDelegate;
    NSLog (@"init player view:%@", _showOnView);
    if (!_VMpalyer)
    {
        _VMpalyer = [VMediaPlayer sharedInstance];
        [_VMpalyer setVideoFillMode:VMVideoFillModeFit];
        _isSetup = [_VMpalyer setupPlayerWithCarrierView:showOnView withDelegate:self];
    }

    SVProbeInfo *probeInfo = [SVProbeInfo sharedInstance];
    _videoPlayTime = [probeInfo getVideoPlayTime];
    execute_total_times = _videoPlayTime / test_period;
    SVInfo (@"video play time is:%d", _videoPlayTime);
    return self;
}

/**
 *  添加视频缓冲加载圆圈图标
 *
 *  @param view 父UIView
 */
- (void)addLoadingUIView:(UIView *)view
{
    // 视频播放缓冲进度
    UIView *activityCarrier = [[UIView alloc]
    initWithFrame:CGRectMake ((showOnView.frame.size.width - 40) / 2,
                              (showOnView.frame.size.height - 40) / 2, FITWIDTH (40), FITWIDTH (40))];
    activityView = [[UIActivityIndicatorView alloc]
    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityCarrier addSubview:activityView];
    [showOnView addSubview:activityCarrier];
    [activityView startAnimating];
}

/**
 *  播放视频
 */
- (void)play
{

    if (!testContext || !testResult)
    {
        SVError (@"test context or test result is null. so refuse play video.");
        return;
    }

    // 初始化UvMOS组件
    [self initUvMOSCompent];

    testContext.testStatus = TEST_TESTING;
    if (testContext.videoSegementURL)
    {
        BOOL isPlaying = [_VMpalyer isPlaying];
        if (isPlaying)
        {
            // 如果视频正在播放，不做任何处理
            NSLog (@"have been playing");
            return;
        }
        else
        {
            [testResult setVideoStartPlayTime:[SVTimeUtil currentMilliSecondStamp]];
            if (_didPrepared)
            {
                // 开始播放视频
                NSLog (@"start play");
                [_VMpalyer start];
            }
            else
            {
                NSLog (@"paly prepareVideo");
                [self prepareVideo];
            }
        }
    }
}

/**
 *  初始化UvMOS组件
 */
- (void)initUvMOSCompent
{
    uvMOSCalculator =
    [[SVUvMOSCalculator alloc] initWithTestContextAndResult:testContext testResult:testResult];
}

/**
 *  停止视频播放
 */
- (void)stop
{
    @try
    {
        // 隐藏加载图标
        [activityView stopAnimating];
        //取消定时器
        [timer invalidate];
        timer = nil;
        // 视频正在播放，则停止视频
        if (_VMpalyer)
        {
            BOOL isPlaying = [_VMpalyer isPlaying];
            if (isPlaying)
            {
                NSLog (@"vmplayer pause");
                [_VMpalyer pause];
            }

            [_VMpalyer reset];
            NSLog (@"vmplayer reset");
            [_VMpalyer unSetupPlayer];
        }
    }
    @catch (NSException *exception)
    {
        SVError (@"stop video fail. exception:%@", exception);
    }

    [testResult setDownloadSize:_downloadSize];
    if (_downloadTime > 0)
    {
        [testResult setDownloadSpeed:(_downloadSize * 8 / _downloadTime)];
    }
    [testResult setVideoEndPlayTime:[SVTimeUtil currentMilliSecondStamp]];

    // 取消 UvMOS 注册服务
    [uvMOSCalculator unRegisteService];
    if (testContext.testStatus == TEST_TESTING)
    {
        testContext.testStatus = TEST_FINISHED;
    }

    isFinished = TRUE;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

/**
 *  是否完成播放
 *
 *  @return TRUE 完成
 */
- (BOOL)isFinished
{
    return isFinished;
}


- (void)prepareVideo
{
    if (testContext.videoSegementURL)
    {
        NSLog (@"prepareVideo");
        //播放时不要锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [_VMpalyer setDataSource:testContext.videoSegementURL];
        [_VMpalyer prepareAsync];
    }
}

/**
 * Called when the player prepared.
 * 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start]来开始音视频的播放.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    // 隐藏加载图标
    if ([activityView isAnimating])
    {
        [activityView stopAnimating];
    }
    NSLog (@"didPrepared.......");
    _didPrepared = YES;
    [player start];
    startPlayTime = [SVTimeUtil currentMilliSecondStamp];
}

/**
 * Called when the player playback completed.
 * 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后操作, 如: 重置播放器,
 * 准备播放下一个音视频等
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    _didPrepared = NO;
    NSLog (@"playbackComplete: %@", arg);
}

/**
 * Called when the player have error occur.
 * 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参数 arg 包含了错误原因.

 * @param player The shared media player instance.
 * @param arg Contain the detail error information.
 */
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    NSLog (@"VMediaPlayer Error: %@", arg);
    [activityView stopAnimating];
    testContext.testStatus = TEST_ERROR;
    [self stop];
}


/**
 * Called when the download rate change.
 *
 * This method is only useful for online media stream.
 *
 * @param player The shared media player instance.
 * @param arg *NSNumber* type, *int* value. The rate in KBytes/s.
 */
- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
    NSLog (@"downloadRate: %d", [arg intValue]);
    _downloadSize += [arg intValue];
    _downloadTime += 1;
    if ((int)arg >= testContext.videoSegementBitrate)
    {
        long bufferedTime = [SVTimeUtil currentMilliSecondStamp] - startPlayTime;
        [self startCalculateUvMOS:player bufferedTime:bufferedTime];
    }
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    NSLog (@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&& bufferingStart");
    _bufferStartTime = [SVTimeUtil currentMilliSecondStamp];
    [player pause];
    // 显示加载图标
    if (![activityView isAnimating])
    {
        [activityView startAnimating];
    }
}

/**
 *  缓冲结束开始播放视频
 *
 *  @param player 播放器
 *  @param arg    arg
 */
- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    // 隐藏加载图标
    if ([activityView isAnimating])
    {
        [activityView stopAnimating];
    }

    long bufferedTime = [SVTimeUtil currentMilliSecondStamp] - _bufferStartTime;

    // 注意：
    // 首次缓冲时长不计入卡顿时长，且第一次缓冲不算卡顿。首次缓冲时长只是首次缓冲时长
    if (_firstBufferTime > 0)
    {
        // 卡顿次数加一
        videoCuttonTimes += 1;
        videoCuttonTotalTime += bufferedTime;
        [testResult setVideoCuttonTimes:(testResult.videoCuttonTimes + 1)];
        [testResult setVideoCuttonTotalTime:(testResult.videoCuttonTotalTime + (int)bufferedTime)];
    }

    NSLog (@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&  bufferingEnd");
    [self startCalculateUvMOS:player bufferedTime:bufferedTime];
    [player start];
}

- (void)startCalculateUvMOS:(VMediaPlayer *)player bufferedTime:(long)bufferedTime
{
    // 注意：
    // 首次缓冲时长不计入卡顿时长，且第一次缓冲不算卡顿。首次缓冲时长只是首次缓冲时长
    if (!_firstBufferTime || _firstBufferTime == 0)
    {
        _firstBufferTime = bufferedTime;
        SVInfo (@"first buffer time(ms):%ld", bufferedTime);
        // 设置首次缓冲时间
        [testResult setFirstBufferTime:(int)bufferedTime];
        // 视频宽度
        int videoWidth = [player getVideoWidth];
        // 视频高度
        int videoHeight = [player getVideoHeight];
        // 视频帧率
        NSDictionary *metaData = [player getMetadata];
        float frame_rate = [[metaData valueForKey:@"video_frame_rate"] floatValue];

        [testResult setVideoWidth:videoWidth];
        [testResult setVideoHeight:videoHeight];
        if (videoHeight && videoWidth)
        {
            [testResult setVideoResolution:[NSString stringWithFormat:@"%d*%d", videoWidth, videoHeight]];
        }

        [testResult setBitrate:(testContext.videoSegementBitrate)];
        [testResult setFrameRate:frame_rate];

        // 注册UvMOS计算服务
        [uvMOSCalculator registeService];

        SVVideoTestSample *sample = [[SVVideoTestSample alloc] init];
        [sample setPeriodLength:0];
        [sample setInitBufferLatency:(int)bufferedTime];
        [sample setAvgVideoBitrate:testResult.bitrate];
        //         孙海龙 2016/02/14 帧率字节目前暂不支持,设置默认值0
        [sample setAvgKeyFrameSize:testResult.frameRate];
        [sample setStallingFrequency:20];
        [sample setStallingDuration:0];
        [sample setVideoStartPlayTime:[testResult videoStartPlayTime]];
        [sample setVideoTotalCuttonTime:0];
        [uvMOSCalculator calculateTestSample:sample];
        if (!testResult.videoTestSamples)
        {
            testResult.videoTestSamples = [[NSMutableArray alloc] init];
        }
        [testResult.videoTestSamples addObject:sample];
        [_testDelegate updateTestResultDelegate:testContext testResult:testResult];
        timer = [NSTimer scheduledTimerWithTimeInterval:test_period
                                                 target:self
                                               selector:@selector (pushTestSample)
                                               userInfo:nil
                                                repeats:YES];
    }
}

- (void)pushTestSample
{
    @try
    {
        SVVideoTestSample *sample = [[SVVideoTestSample alloc] init];
        [sample setPeriodLength:5];
        [sample setInitBufferLatency:0];
        [sample setAvgVideoBitrate:testResult.bitrate];
        // 孙海龙 2016/02/14 帧率字节目前暂不支持,设置默认值0
        [sample setAvgKeyFrameSize:testResult.frameRate];
        [sample setVideoStartPlayTime:[testResult videoStartPlayTime]];
        [sample setVideoTotalCuttonTime:testResult.videoCuttonTotalTime];
        if (videoCuttonTimes <= 0)
        {
            [sample setStallingFrequency:0];
            [sample setStallingDuration:0];
        }
        else
        {
            [sample setStallingFrequency:videoCuttonTimes];
            [sample setStallingDuration:(videoCuttonTotalTime / videoCuttonTimes)];
        }

        [uvMOSCalculator calculateTestSample:sample];
        [testResult.videoTestSamples addObject:sample];
        videoCuttonTimes = 0;
        videoCuttonTotalTime = 0;

        execute_times += 1;
        if (execute_times >= execute_total_times)
        {
            [testResult setSViewSession:sample.sViewSession];
            [testResult setSInteractionSession:sample.sInteractionSession];
            [testResult setSQualitySession:sample.sQualitySession];
            [testResult setUvMOSSession:sample.UvMOSSession];
            [self stop];
        }

        [_testDelegate updateTestResultDelegate:testContext testResult:testResult];
    }
    @catch (NSException *exception)
    {
        SVError (@"%@", exception);
    }
}


@end
