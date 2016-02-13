//
//  SVUvMOSCalculater.m
//  SPUIView
//
//  Created by Rain on 2/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//
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
    stMediaInfo.fScreenSize = [SVVideoUtil getScreenScale];
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
 *  计算UvMOS
 *
 *  @param periodLength
 * 采样周期时长，单位秒(s)，建议按照观看时间反馈，近似可以按照内容的实际时间反馈
 *  @param initBufferLatency 初始缓冲时长，单位毫秒(ms)，采样周期内没有初始缓冲事件时，输入0
 *  @param initBufferLatencyavgVideoBitrate
 * 支持VBR特性时，采样周期内视频文件平均码率，单位kbps，无法获得时输入0
 *  @param avgKeyFrameSize 支持VBR特性时，采样周期内I帧平均大小，单位字节，无法获得时输入0
 *  @param stallingFrequency                采样周期内，卡顿次数
 *  @param stallingDuration                 采样周期内，平均卡顿时长，单位毫秒(ms)
 */
- (void)calculate:(int)periodLength
initBufferLatency:(int)initBufferLatency
  avgVideoBitrate:(int)avgVideoBitrate
  avgKeyFrameSize:(int)avgKeyFrameSize
stallingFrequency:(int)stallingFrequency
 stallingDuration:(int)stallingDuration;
{
    /* 赋值周期性采样参数 */
    UvMOSVODPeriodInfo stVODInfo = { 0 };
    UvMOSResult stResult = { 0 };
    stVODInfo.iPeriodLength = periodLength;
    stVODInfo.iInitBufferLatency = initBufferLatency;
    stVODInfo.iAvgVideoBitrate = avgVideoBitrate;
    stVODInfo.iAvgKeyFrameSize = avgKeyFrameSize;
    stVODInfo.iStallingFrequency = stallingFrequency;
    stVODInfo.iStallingDuration = stallingDuration;

    /* 第二步：每个周期调用计算(携带周期性参数) */
    int iErrorCode = calculateUvMOSVODPeriod (_iServiceId, &stVODInfo, &stResult);
    if (SUCCESS != iErrorCode)
    {
        SVError (@"calculate UvMOS fail. iErrorCode:%d", iErrorCode);
        return;
    }

    /* U-vMOS结果输出 */
    printf ("U-vMOS VOD Period calculate result :\n");
    printf ("UvMOSResult.sQualityPeriod => %f \n", stResult.sQualityPeriod);
    printf ("UvMOSResult.sInteractionPeriod => %f \n", stResult.sInteractionPeriod);
    printf ("UvMOSResult.sViewPeriod => %f \n", stResult.sViewPeriod);
    printf ("UvMOSResult.sViewPeriod => %f \n", stResult.uvmosPeriod);
    printf ("\n");
    printf ("UvMOSResult.sQualitySession => %f \n", stResult.sQualitySession);
    printf ("UvMOSResult.sInteractionSession => %f \n", stResult.sInteractionSession);
    printf ("UvMOSResult.sViewSession => %f \n", stResult.sViewSession);
    printf ("UvMOSResult.sViewSession => %f \n", stResult.uvmosSession);
    printf ("\n");
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

    /* U-vMOS结果输出 */
    [testSample setSQualitySession:stResult.sQualitySession];
    [testSample setSInteractionSession:stResult.sInteractionSession];
    [testSample setSViewSession:stResult.sViewSession];
    [testSample setUvMOSSession:stResult.uvmosSession];
    SVDebug (
    @"sQualitySession: %.2f  sInteractionSession:%.2f sViewSession:%.2f  uvmosSession:%.2f",
    stResult.sQualitySession, stResult.sInteractionSession, stResult.sViewSession, stResult.uvmosSession);
}

- (void)unRegisteService
{

    /* 第三步：去注册服务 */
    int iResult = unregisterUvMOSService (_iServiceId);
    SVInfo (@"unregiste UvMOS calculate service. iResult:%d", iResult);
}


@end
