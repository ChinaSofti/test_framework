//
//  SVUvMOSVideoResolutionGetter.m
//  SPUIView
//
//  Created by Rain on 2/6/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVUvMOSVideoResolutionGetter.h"
/**
 *  根据视频宽度和高度获取对应的视频分辨率
 */
@implementation SVUvMOSVideoResolutionGetter

/**
 *  根据视频宽度和高度获取对应的视频分辨率
 *
 *  @param height 视频高度
 *  @param width  视频宽带
 *
 *  @return 视频分辨率
 */
+ (UvMOSVideoResolution)getUvMOSVideoResolution:(int)width height:(int)height
{
    if (width == 480 && height == 360)
    {
        // 视频分辨率360P, 480*360
        return RESOLUTION_360P;
    }
    else if (width == 640 && height == 480)
    {
        // 视频分辨率480P, 640*480
        return RESOLUTION_360P;
    }
    else if (width == 1280 && height == 720)
    {
        // 视频分辨率720P, 1280*720
        return RESOLUTION_720P;
    }
    else if (width == 1920 && height == 1080)
    {
        // 视频分辨率720P, 1920*1080
        return RESOLUTION_1080P;
    }
    else if (width == 2560 && height == 1440)
    {
        // 视频分辨率2K, 2560×1440
        return RESOLUTION_2K;
    }
    else if (width == 3840 && height == 2160)
    {
        // 视频分辨率4K, 3840×2160
        return RESOLUTION_4K;
    }
    else
    {
        return RESOLUTION_UNKNOW;
    }
}

@end
