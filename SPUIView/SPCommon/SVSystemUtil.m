//
//  SVSystemUtil.m
//  SPUIView
//
//  Created by Rain on 2/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVSystemUtil.h"

@implementation SVSystemUtil

/**
 *  获取当前系统语言
 *
 *  @return 当前系统语言
 */
+ (NSString *)currentSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+ (NetworkStatus)currentNetworkType
{
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    return [hostReach currentReachabilityStatus];
}

/**
 *  网络连接是否正常
 *
 *  @return true 正常
 */
+ (BOOL)isConnectionAvailable
{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero (&zeroAddress, sizeof (zeroAddress));
    zeroAddress.sin_len = sizeof (zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // SCNetworkReachabilityCreateWithAddress：根据传入的IP地址测试连接状态，当为0.0.0.0时则可以查询本机的网络连接状态。
    // 使用SCNetworkReachabilityCreateWithAddress：可以根据传入的网址地址测试连接状态

    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress (NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;

    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags (defaultRouteReachability, &flags);
    CFRelease (defaultRouteReachability);

    if (!didRetrieveFlags)
    {
        printf ("Error. Could not recover network reachability flags\n");
        return NO;
    }

    // kSCNetworkReachabilityFlagsReachable：能够连接网络
    // kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
    // kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
