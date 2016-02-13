//
//  SVVideoTestResult.h
//  SPUIView
//
//  Created by Rain on 2/6/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVTestResult.h"
#import "SVVideoTestSample.h"

/**
 *  视频测试结果
 */
@interface SVVideoTestResult : SVTestResult

// 测试时间
@property long testTime;

// sQuality周期得分：当前采样周期内，视频质量得分
@property float sQualityPeriod;
// sInteraction周期得分：当前采样周期内，交互体验得分
@property float sInteractionPeriod;
// sView周期得分：当前采样周期内[h3] ，观看体验得分
@property float sViewPeriod;
// U-vMOS周期得分：当前采样周期内，U-vMOS综合得分
@property float UvMOSPeriod;

// 首次缓冲时间
@property long firstBufferTime;

// 开始视频播放
@property long videoStartPlayTime;
// 结束视频播放
@property long videoEndPlayTime;
// 视频卡顿次数
@property int videoCuttonTimes;
// 视频卡顿总时长
@property int videoCuttonTotalTime;

// 下载速率
@property double downloadSpeed;

// 下载大小
@property int downloadSize;

// 视频宽度
@property int videoWidth;

// 视频高度
@property int videoHeight;

// 视频帧率
@property float frameRate;

// 视频码率
@property float bitrate;

// 屏幕尺寸
@property float screenSize;

// 视频分辨率 1920 * 1080 即：videoWidth * videoHeight
@property NSString *videoResolution;

// 测试样本结果信息
@property NSMutableArray *videoTestSamples;


@end
