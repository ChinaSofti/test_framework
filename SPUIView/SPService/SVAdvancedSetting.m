//
//  SVAdvancedSetting.m
//  SPUIView
//
//  Created by Rain on 2/17/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVAdvancedSetting.h"
#import "SVLog.h"

#define default_screenSize 42;
#define VIDEO_PLAY_TIME_KEY @"videoPlayTime"
#define LANGUAGE_INDEX_KEY @"languageIndex"

@implementation SVAdvancedSetting

// 屏幕尺寸
static NSString *_screenSize;


/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    static SVAdvancedSetting *advancedSetting;
    @synchronized (self)
    {
        if (advancedSetting == nil)
        {
            advancedSetting = [[super allocWithZone:NULL] init];

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _screenSize = [defaults objectForKey:@"screenSize"];
            if (!_screenSize)
            {
                _screenSize = @"42.00";
                [defaults setObject:_screenSize forKey:@"screenSize"];
                [defaults synchronize];
            }

            NSString *videoPlayTime = [defaults objectForKey:VIDEO_PLAY_TIME_KEY];
            if (!videoPlayTime)
            {
                [defaults setObject:[NSString stringWithFormat:@"%d", 20]
                             forKey:VIDEO_PLAY_TIME_KEY];
                [defaults synchronize];
            }
        }
    }

    return advancedSetting;
}

/**
 *  覆写allocWithZone方法
 *
 *  @param zone _NSZone
 *
 *  @return 单例对象
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [SVAdvancedSetting sharedInstance];
}

/**
 *  覆写copyWithZone方法
 *
 *  @param zone _NSZone
 *
 *  @return 单例对象
 */

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [SVAdvancedSetting sharedInstance];
}


/**
 *  设置屏幕尺寸
 *
 *  @param screenSize 屏幕尺寸
 */
- (void)setScreenSize:(float)screenSize
{
    SVInfo (@"Advanced Setting[screenSize=%.2f]", screenSize);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _screenSize = [NSString stringWithFormat:@"%.2f", screenSize];
    [defaults setObject:_screenSize forKey:@"screenSize"];
    [defaults synchronize];
}

/**
 *  查询屏幕尺寸
 *
 *  @return 屏幕尺寸
 */
- (NSString *)getScreenSize
{
    return _screenSize;
}

/**
 *  带宽类型
 *
 *  @param type 带宽类型
 */
- (void)setBandwidthType:(NSString *)type
{
    SVInfo (@"Advanced Setting[bandwidth type=%@]", type);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:type forKey:@"bandwidthType"];
    [defaults synchronize];
}

/**
 *  获取带宽类型
 *
 *  @return 带宽类型
 */
- (NSString *)getBandwidthType
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"bandwidthType"];
}

/**
 *  设置带宽
 *
 *  @param bandwidth 带宽
 */
- (void)setBandwidth:(NSString *)bandwidth
{
    SVInfo (@"Advanced Setting[bandwidth=%@]", bandwidth);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:bandwidth forKey:@"bandwidth"];
    [defaults synchronize];
}

/**
 *  获取带宽
 *
 *  @return 带宽
 */
- (NSString *)getBandwidth
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"bandwidth"];
}


/**
 *  语言设置的索引
 *
 *  @param languageIndex 语言设置的索引
 */
- (void)setLanguageIndex:(int)languageIndex
{
    SVInfo (@"Advanced Setting[languageIndex=%d]", languageIndex);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", languageIndex] forKey:LANGUAGE_INDEX_KEY];
    [defaults synchronize];
}

/**
 *  获取语言设置的索引
 *
 *  @return 语言设置的索引
 */
- (int)getLanguageIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *languageIndex = [defaults valueForKey:LANGUAGE_INDEX_KEY];
    if (languageIndex)
    {
        return [languageIndex intValue];
    }
    else
    {
        return 0;
    }
}

/**
 *  设置视频播放时长, 时间单位全部转换为秒
 *  包含：20s,3min,5min,10min,30min
 *
 *  @param languageIndex 视频播放时长
 */
- (void)setVideoPlayTime:(int)videoPlayTime
{
    SVInfo (@"Advanced Setting[videoPlayTime=%d]", videoPlayTime);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", videoPlayTime]
                 forKey:VIDEO_PLAY_TIME_KEY];
    [defaults synchronize];
}

/**
 *  获取视频播放时长, 时间单位全部转换为秒
 *
 *  @return 视频播放时长
 */
- (int)getVideoPlayTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *videoPlayTime = [defaults valueForKey:VIDEO_PLAY_TIME_KEY];
    if (videoPlayTime)
    {
        return [videoPlayTime intValue];
    }
    else
    {
        return 20;
    }
}

@end
