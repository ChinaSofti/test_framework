//
//  SVProbeInfo.m
//  SPUIView
//
//  Created by Rain on 2/11/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVProbeInfo.h"

@implementation SVProbeInfo

@synthesize signedBandwidth, singnal, isp, ip, networkType, location;


/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    static SVProbeInfo *probeInfo;
    @synchronized (self)
    {

        if (probeInfo == nil)
        {
            probeInfo = [[super allocWithZone:NULL] init];
        }
    }

    return probeInfo;
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
    return [SVProbeInfo sharedInstance];
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
    return [SVProbeInfo sharedInstance];
}

@end
