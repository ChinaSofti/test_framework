//
//  CTUtils.m
//  SPUIView
//
//  Created by Rain on 2/6/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVVideoUtil.h"

@implementation SVVideoUtil

/**
 *  获取屏幕尺寸
 *
 *  @return 屏幕尺寸
 */
+ (CGSize)getScreenSize
{
    //屏幕尺寸
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    return size;
}

/**
 *  获取屏幕分辨率
 *
 *  @return 屏幕分辨率
 */
+ (CGFloat)getScreenScale
{
    //分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    return scale_screen;
}

@end
