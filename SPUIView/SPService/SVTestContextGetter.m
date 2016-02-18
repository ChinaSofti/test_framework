//
//  TSContextGetter.m
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVHttpsGetter.h"
#import "SVLog.h"
#import "SVProbeInfo.h"
#import "SVProbeInfo.h"
#import "SVTestContextGetter.h"
#import "SVVideoAnalyser.h"
#import "SVVideoAnalyserFactory.h"

/**
 *  从指定服务器获取测试相关的配置信息。
 *  默认服务器地址为 https://58.60.106.188:12210/speedpro/configapi
 */

@implementation SVTestContextGetter
{
    SVVideoTestContext *videoContext;

    NSString *videoURLS;

    SVWebTestContext *webContext;

    NSString *webURLs;

    SVBandwidthTestContext *bandwidthContext;
}

static NSString *defaultServerURL = @"https://58.60.106.188:12210/speedpro/configapi?lang=%@";

static NSString *serverURL = @"https://58.60.106.188:12210/speedpro/configapi?lang=CN";

static SVTestContextGetter *contextGetter = nil;

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    @synchronized (self)
    {

        if (contextGetter == nil)
        {
            contextGetter = [[super allocWithZone:NULL] init];
        }
    }

    return contextGetter;
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
    return [SVTestContextGetter sharedInstance];
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
    return [SVTestContextGetter sharedInstance];
}

/**
 *  根据IP运营商信息进行初始化对象
 */
- (void)initIPAndISP
{
    SVIPAndISP *ipAndISP = [SVIPAndISPGetter getIPAndISP];
    if (ipAndISP)
    {
        SVProbeInfo *probeInfo = [SVProbeInfo sharedInstance];
        [probeInfo setIp:ipAndISP.query];
        [probeInfo setIsp:ipAndISP.isp];
        NSString *countryCode = ipAndISP.countryCode;
        if (countryCode)
        {
            // 修改URL参数
            serverURL = [NSString stringWithFormat:defaultServerURL, countryCode];
        }
    }
}

/**
 *  从缺省的指定服务器请求数据
 */
- (void)requestContextDataFromServer
{
    @try
    {
        SVHttpsGetter *getter = [[SVHttpsGetter alloc] initWithURLNSString:serverURL];
        self.data = [getter getResponseData];
    }
    @catch (NSException *exception)
    {
        SVError (@"request test context information fail. exception:%@", exception);
    }
}

/**
 *  解析从服务器获取的数据，并将数据解析为对应测试的Context对象
 */
- (void)parseContextData
{
    if (!self.data)
    {
        SVError (@"request data is null");
        return;
    }

    NSError *error = nil;
    NSDictionary *dictionay =
    [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    if (error)
    {
        SVError (@"convert NSData to json fail. Error:%@", error);
        return;
    }

    if (dictionay)
    {
        videoURLS = [dictionay valueForKey:@"ottUrls"];
        webURLs = [dictionay valueForKey:@"webUrls"];
        //        NSString *versionCode = [dictionay valueForKey:@"versionCode"];
        //        NSString *downloadUrl = [dictionay valueForKey:@"downloadUrl"];
    }
}

/**
 *  获取视频Context对象
 *
 *  @return 视频Context对象
 */
- (SVVideoTestContext *)getVideoContext
{
    // 初始化VideoTestContext
    videoContext = [[SVVideoTestContext alloc] initWithData:self.data];
    [videoContext setVideoURLsString:videoURLS];
    SVVideoAnalyser *analyser = [SVVideoAnalyserFactory createAnalyser:videoContext.videoURLString];
    SVVideoInfo *videoInfo = [analyser analyse];
    if (!videoInfo)
    {
        SVError (@"analyse video fail. ");
        return nil;
    }
    int randomIndex = arc4random () % [[videoInfo getAllSegement] count];
    SVVideoSegement *segement = [videoInfo getAllSegement][randomIndex];
    [videoContext setVideoSegementURLString:segement.videoSegementURL];
    NSURL *url = [NSURL URLWithString:segement.videoSegementURL];
    [videoContext setVideoSegementURL:url];
    [videoContext setVideoSegementSize:segement.size];
    [videoContext setVideoSegementDuration:segement.duration];
    [videoContext setVideoSegementBitrate:segement.bitrate];
    [videoContext setVideoSegementIP:url.host];
    @try
    {
        SVIPAndISP *ipAndISP = [SVIPAndISPGetter queryIPDetail:url.host];
        [videoContext setVideoSegemnetLocation:ipAndISP.regionName];
        [videoContext setVideoSegemnetISP:ipAndISP.isp];
    }
    @catch (NSException *exception)
    {
        SVError (@"query ip[%@] location fail %@", url.host, exception);
    }

    return videoContext;
}

/**
 *  获取网页Context对象
 *
 *  @return 网页Context对象
 */
- (SVWebTestContext *)getWebContext
{
    webContext = [[SVWebTestContext alloc] initWithData:self.data];

    return webContext;
}

/**
 *  获取带宽Context对象
 *
 *  @return 带宽Context对象
 */
- (SVBandwidthTestContext *)getBandwidthContext
{
    bandwidthContext = [[SVBandwidthTestContext alloc] initWithData:self.data];
    return bandwidthContext;
}


@end
