//
//  SVUvMOSCalculater.m
//  SPUIView
//
//  Created by Rain on 2/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//
#import "SVAdvancedSetting.h"
#import "SVContentProviderGetter.h"
#import "SVLog.h"
#import "SVUvMOSCalculator.h"
#import "SVUvMOSVideoResolutionGetter.h"
#import "SVVideoUtil.h"

@implementation SVUvMOSCalculator
{
    SVVideoTestContext *_testContext;
    SVVideoTestResult *_testResult;
    int _iServiceId;
}

/**
 *  初始化UvMOS值计算器
 *
 *  @param testContext Test Context
 *  @param testResult Test Result
 *
 *  @return UvMOS值计算器
 */
- (id)initWithTestContextAndResult:(SVVideoTestContext *)testContext
                        testResult:(SVVideoTestResult *)testResult
{
    _testContext = testContext;
    _testResult = testResult;
    return self;
}


- (void)registeService
{
    /* 赋值视频静态参数  */
    UvMOSMediaInfo stMediaInfo = { 0 };
    // 视频提供商
    stMediaInfo.eContentProvider =
    [SVContentProviderGetter getContentProvider:_testContext.videoSegementURL.host];
    // 视频帧率
    stMediaInfo.iFrameRate = _testResult.frameRate;
    // 媒体文件平均码率，单位kbps --媒体文件整体码率
    stMediaInfo.iAvgBitrate = _testContext.videoSegementBitrate;
    stMediaInfo.eVideoCodec = VIDEO_CODEC_H264;
    // 屏幕尺寸，单位英寸，输入为0时，屏幕映射默认为42寸TV
    //    stMediaInfo.fScreenSize = [SVVideoUtil getScreenScale];
    // 孙海龙 2016/02/13  屏幕尺寸 固定为42寸
    SVAdvancedSetting *setting = [SVAdvancedSetting sharedInstance];
    float screenSize = [[setting getScreenSize] floatValue];
    stMediaInfo.fScreenSize = screenSize;
    [_testResult setScreenSize:screenSize];

    // 视频分辨率
    stMediaInfo.eVideoResolution =
    [SVUvMOSVideoResolutionGetter getUvMOSVideoResolution:_testResult.videoWidth
                                                   height:_testResult.videoHeight];
    // 屏幕分辨率
    CGSize scressSize = [SVVideoUtil getScreenSize];
    stMediaInfo.eScreenResolution = [SVUvMOSVideoResolutionGetter getUvMOSVideoResolution:scressSize.width
                                                                                   height:scressSize.height];
    /* 第一步：申请U-vMOS服务号 (携带视频静态参数 )  */
    _iServiceId = registerUvMOSService (&stMediaInfo);
    SVInfo (@"registe UvMOS calculate service. iServiceID:%d", _iServiceId);
}

/**
 *  计算样本的UvMOS
 *
 *  @param testSample SVVideoTestSample
 */
- (void)calculateTestSample:(SVVideoTestSample *)testSample
{
    SVDebug (@"iPeriodLength:%d  iInitBufferLatency:%d iAvgVideoBitrate:%d iAvgKeyFrameSize:%d "
             @"iStallingFrequency:%d  iStallingDuration:%d",
             testSample.periodLength, testSample.initBufferLatency, testSample.avgVideoBitrate,
             testSample.avgKeyFrameSize, testSample.stallingFrequency, testSample.stallingDuration);


    /* 赋值周期性采样参数 */
    UvMOSVODPeriodInfo stVODInfo = { 0 };
    UvMOSResult stResult = { 0 };
    stVODInfo.iPeriodLength = testSample.periodLength;
    stVODInfo.iInitBufferLatency = testSample.initBufferLatency;
    stVODInfo.iAvgVideoBitrate = testSample.avgVideoBitrate;
    stVODInfo.iAvgKeyFrameSize = testSample.avgKeyFrameSize;
    stVODInfo.iStallingFrequency = testSample.stallingFrequency;
    stVODInfo.iStallingDuration = testSample.stallingDuration;

    /* 第二步：每个周期调用计算(携带周期性参数) */
    int iErrorCode = calculateUvMOSVODPeriod (_iServiceId, &stVODInfo, &stResult);
    if (SUCCESS != iErrorCode)
    {
        SVError (@"calculate UvMOS fail. iErrorCode:%d", iErrorCode);
        return;
    }

    SVDebug (@"------sQualitySession: %.2f  sInteractionSession:%.2f sViewSession:%.2f  "
             @"uvmosSession:%.2f",
             stResult.sQualitySession, stResult.sInteractionSession, stResult.sViewSession,
             stResult.uvmosSession);

    /* U-vMOS结果输出 */
    if (stResult.sQualitySession == NAN)
    {
        [testSample setSQualitySession:-1];
    }
    else
    {
        [testSample setSQualitySession:stResult.sQualitySession];
    }

    if (stResult.sInteractionSession == NAN)
    {
        [testSample setSInteractionSession:-1];
    }
    else
    {
        [testSample setSInteractionSession:stResult.sInteractionSession];
    }

    if (stResult.sViewSession == NAN)
    {
        [testSample setSViewSession:-1];
    }
    else
    {
        [testSample setSViewSession:stResult.sViewSession];
    }

    if (stResult.uvmosSession == NAN)
    {
        [testSample setUvMOSSession:-1];
    }
    else
    {
        [testSample setUvMOSSession:stResult.uvmosSession];
    }

    SVDebug (@"sQualitySession: %.2f  sInteractionSession:%.2f sViewSession:%.2f  "
             @"uvmosSession:%.2f",
             testSample.sQualitySession, testSample.sInteractionSession, testSample.sViewSession,
             testSample.UvMOSSession);
}

- (void)unRegisteService
{

    /* 第三步：去注册服务 */
    int iResult = unregisterUvMOSService (_iServiceId);
    SVInfo (@"unregiste UvMOS calculate service. iResult:%d", iResult);
}


@end
