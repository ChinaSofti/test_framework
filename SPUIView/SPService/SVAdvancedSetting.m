//
//  SVAdvancedSetting.m
//  SPUIView
//
//  Created by Rain on 2/17/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVAdvancedSetting.h"

#define default_screenSize 42;

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", languageIndex] forKey:@"languageIndex"];
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
    NSString *languageIndex = [defaults valueForKey:@"languageIndex"];
    if (languageIndex)
    {
        return [languageIndex intValue];
    }
    else
    {
        return 0;
    }
}

@end
