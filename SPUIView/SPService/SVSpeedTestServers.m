//
//  SVSpeedTestServers.m
//  SpeedPro
//
//  Created by Rain on 3/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//
#import "SVHttpsGetter.h"
#import "SVSpeedTestServers.h"
#import "SVSpeedTestServersParser.h"
#import <SPCommon/SVLog.h>

@implementation SVSpeedTestServers
{
    NSMutableArray *_serverArray;
    SVSpeedTestServer *_server;
}

static NSString *SPEEDTEST_SERVER_QUERY_URL = @"https://www.speedtest.net/api/android/config.php";

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    static SVSpeedTestServers *servers;
    @synchronized (self)
    {
        if (servers == nil)
        {
            servers = [[super allocWithZone:NULL] init];
            dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              [servers initSpeedTestServer];
            });
        }
    }

    return servers;
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
    return [SVSpeedTestServers sharedInstance];
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
    return [SVSpeedTestServers sharedInstance];
}

- (void)initSpeedTestServer
{
    SVInfo (@"start request speed test server list.");
    SVHttpsGetter *getter = [[SVHttpsGetter alloc] initWithURLNSString:SPEEDTEST_SERVER_QUERY_URL];
    NSData *reponseData = [getter getResponseData];
    if (!reponseData)
    {
        SVError (@"request speed test server list fail.");
        return;
    }

    SVSpeedTestServersParser *parser = [[SVSpeedTestServersParser alloc] initWithData:reponseData];
    NSArray *array = [parser parse];

    _serverArray = [[NSMutableArray alloc] init];
    _serverArray = [[NSMutableArray alloc] initWithArray:array];
    SVSpeedTestServer *server = [_serverArray objectAtIndex:0];
    _server = server;
}


/**
 *  设置缺省SpeedTestServer
 *
 *  @param serverURL SpeedTestServer
 */
- (void)setDefaultServerURL:(SVSpeedTestServer *)server
{
    _server = server;
}

/**
 *  设置缺省SpeedTestServer
 *
 *  @return 缺省SpeedTestServer
 */
- (SVSpeedTestServer *)getDefaultServer
{
    return _server;
}

/**
 *  获取所有SpeedTest Server
 *
 *  @return 所有SpeedTest Server
 */
- (NSArray *)getAllServer
{
    return _serverArray;
}

@end
