//
//  VideoPlayer.m
//  TaskService
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVLog.h"
#import "SVTimeUtil.h"
#import "SVVideoPlayer.h"

#define FITWIDTH(W) W / 320.0 * ([UIScreen mainScreen].bounds.size.width)
#define FITHEIGHT(H) H / 568.0 * ([UIScreen mainScreen].bounds.size.height)

@implementation SVVideoPlayer
{
    // 视频是否准备好，可以进行播放
    BOOL _didPrepared;

    // 第三方视频播放对象
    VMediaPlayer *_VMpalyer;

    // 首次缓冲开始毫秒时间戳
    long firstBufferTime;

    // 开始缓冲时间
    long bufferStartTime;

    // 总下载大小
    int downloadSize;
    // 总下载时长
    int downloadTime;

    // 缓冲时间集合
    NSMutableArray *bufferedTimeArray;

    BOOL isFirstCalculateUvMOS;

    SVVideoTestSample *sample;

    // 加载图标
    UIActivityIndicatorView *activityView;

    // 每隔5秒推送一次结果
    id<SVVideoTestDelegate> _testDelegate;

    // 定时器
    NSTimer *timer;
}

@synthesize showOnView, testResult, testContext, uvMOSCalculator;

// 样本时长5秒
static const int test_period = 5;

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
        [_VMpalyer setupPlayerWithCarrierView:showOnView withDelegate:self];
        isFirstCalculateUvMOS = true;
    }

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
    initWithFrame:CGRectMake (FITWIDTH (60), FITWIDTH (30), FITWIDTH (40), FITWIDTH (40))];
    activityView = [[UIActivityIndicatorView alloc]
    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityCarrier addSubview:activityView];
    [showOnView addSubview:activityCarrier];
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

    uvMOSCalculator =
    [[SVUvMOSCalculator alloc] initWithTestContextAndResult:testContext testResult:testResult];

    NSLog (@"avgrate %lf: ", self.testContext.videoSegementBitrate);
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
 *  停止视频播放
 */
- (void)stop
{
    //取消定时器
    [timer invalidate];
    timer = nil;

    // 隐藏加载图标
    [activityView stopAnimating];

    BOOL isPlaying = [_VMpalyer isPlaying];
    // 视频正在播放，则停止视频
    if (_VMpalyer)
    {
        if (isPlaying)
        {
            NSLog (@"vmplayer pause");
            [_VMpalyer pause];
        }

        NSLog (@"vmplayer reset");
        [_VMpalyer reset];
    }

    [testResult setDownloadSize:downloadSize];
    if (downloadTime == 0)
    {
        [testResult setDownloadSpeed:0];
    }
    else
    {
        [testResult setDownloadSpeed:(downloadSize / downloadTime)];
    }

    [testResult setVideoEndPlayTime:[SVTimeUtil currentMilliSecondStamp]];

    // 取消 UvMOS 注册服务
    [uvMOSCalculator unRegisteService];
}

- (void)prepareVideo
{
    if (testContext.videoSegementURL)
    {
        NSLog (@"prepareVideo");
        //播放时不要锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        //        [_VMpalyer setBufferSize:(512 * 1024)];
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
    NSLog (@"didPrepared.......");
    _didPrepared = YES;
    testContext.testStatus = TEST_TESTING;
    [player start];
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
    // [self stop];
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
    NSLog (@"downloadRate: %@", arg);
    downloadSize += (int)arg;
    downloadTime += 1;
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    // 显示加载图标
    [activityView startAnimating];
    NSLog (@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&& bufferingStart");
    bufferStartTime = [SVTimeUtil currentMilliSecondStamp];
    [player pause];
}


- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    NSLog (@"Buffering... %d%%", [((NSNumber *)arg)intValue]);
    //    NSDictionary *metaData = [player getMetadata];
    //    float bitRate1 = [[metaData valueForKey:@"bit_rate"] floatValue];
    //    NSLog (@"Buffering...  %@%%    %f", arg, bitRate1);
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    long bufferedTime = [SVTimeUtil currentMilliSecondStamp] - bufferStartTime;
    // 视频帧率
    NSDictionary *metaData = [player getMetadata];
    float frame_rate = [[metaData valueForKey:@"video_frame_rate"] floatValue];
    //  码率单位转换为kbps
    int bit_rate = [[metaData valueForKey:@"bit_rate"] floatValue] / 1000;

    if (!firstBufferTime)
    {
        SVInfo (@"first buffer time(ms):%ld", bufferedTime);
        firstBufferTime = bufferedTime;
        // 设置首次缓冲时间
        [testResult setFirstBufferTime:bufferedTime];

        // 视频宽度
        int videoWidth = [player getVideoWidth];
        // 视频高度
        int videoHeight = [player getVideoHeight];
        [testResult setVideoWidth:videoWidth];
        [testResult setVideoHeight:videoHeight];
        [testResult setVideoResolution:[NSString stringWithFormat:@"%d*%d", videoWidth, videoHeight]];
        [testResult setBitrate:testContext.videoSegementBitrate];
        [testResult setFrameRate:frame_rate];

        // 注册UvMOS计算服务
        [uvMOSCalculator registeService];

        sample = [[SVVideoTestSample alloc] init];
        [sample setStallingFrequency:0];
        [sample setStallingDuration:1];
        [sample setInitBufferLatency:(int)bufferedTime];

        [self pushTestSample];
        timer = [NSTimer scheduledTimerWithTimeInterval:test_period
                                                 target:self
                                               selector:@selector (pushTestSample)
                                               userInfo:nil
                                                repeats:YES];
    }

    // 当缓冲时间大于100ms时才计算卡顿
    if (bufferedTime > 100)
    {
        // 卡顿次数加一
        [sample setStallingFrequency:(sample.stallingFrequency + 1)];
        [testResult setVideoCuttonTimes:(testResult.videoCuttonTimes + 1)];

        // 卡顿总时长
        [sample setStallingTotalTime:(int)(sample.stallingTotalTime + bufferedTime)];
        [testResult setVideoCuttonTotalTime:(int)(testResult.videoCuttonTotalTime + bufferedTime)];
    }

    NSLog (@"%@", sample);

    // 隐藏加载图标
    [activityView stopAnimating];
    [player start];
    NSLog (@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&  bufferingEnd");
}

- (void)pushTestSample
{
    @try
    {
        [sample setPeriodLength:test_period];
        [sample setAvgKeyFrameSize:testResult.frameRate];
        [sample setAvgVideoBitrate:testResult.bitrate];
        // 如果未设置初始缓冲时长，则将值设置为卡顿总时长
        if (!sample.initBufferLatency)
        {
            [sample setInitBufferLatency:sample.stallingTotalTime];
        }

        // 如果不存在卡顿，设置平均卡顿时长为0
        if (!sample.stallingFrequency)
        {
            [sample setStallingDuration:0];
        }
        else
        {
            [sample setStallingDuration:(sample.stallingTotalTime / sample.stallingFrequency)];
        }

        [uvMOSCalculator calculateTestSample:sample];
        // 当前周期内测试样本指标计算完成，将测试样本存入结果中
        if (!testResult.videoTestSamples)
        {
            testResult.videoTestSamples = [[NSMutableArray alloc] init];
        }

        [testResult.videoTestSamples addObject:sample];
        [_testDelegate updateTestResultDelegate:testContext testResult:testResult];

        // 上一个样本测试完成，初始化一个新的测试样本
        sample = [[SVVideoTestSample alloc] init];
    }
    @catch (NSException *exception)
    {
        SVError (@"%@", exception);
    }
}

@end
