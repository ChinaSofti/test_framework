//
//  SVUvMOSCalculater.h
//  SPUIView
//
//  Created by Rain on 2/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVVideoTestContext.h"
#import "SVVideoTestResult.h"
#import "SVVideoTestSample.h"
#import <Foundation/Foundation.h>

@interface SVUvMOSCalculator : NSObject

/**
 *  初始化UvMOS值计算器
 *
 *  @param testContext Test Context
 *  @param testResult Test Result
 *
 *  @return UvMOS值计算器
 */
- (id)initWithTestContextAndResult:(SVVideoTestContext *)testContext
                        testResult:(SVVideoTestResult *)testResult;

- (void)registeService;

/**
 *  计算UvMOS
 *
 *  @param periodLength
 * 采样周期时长，单位秒(s)，建议按照观看时间反馈，近似可以按照内容的实际时间反馈
 *  @param initBufferLatency 初始缓冲时长，单位毫秒(ms)，采样周期内没有初始缓冲事件时，输入0
 *  @param initBufferLatencyavgVideoBitrate
 * 支持VBR特性时，采样周期内视频文件平均码率，单位kbps，无法获得时输入0
 *  @param avgKeyFrameSize 支持VBR特性时，采样周期内I帧平均大小，单位字节，无法获得时输入0
 *  @param stallingFrequency 采样周期内，卡顿次数
 *  @param stallingDuration  采样周期内，平均卡顿时长，单位毫秒(ms)
 */
- (void)calculate:(int)periodLength
initBufferLatency:(int)initBufferLatency
  avgVideoBitrate:(int)initBufferLatencyavgVideoBitrate
  avgKeyFrameSize:(int)avgKeyFrameSize
stallingFrequency:(int)stallingFrequency
 stallingDuration:(int)stallingDuration;

/**
 *  计算样本的UvMOS
 *
 *  @param testSample SVVideoTestSample
 */
- (void)calculateTestSample:(SVVideoTestSample *)testSample;

- (void)unRegisteService;
@end
