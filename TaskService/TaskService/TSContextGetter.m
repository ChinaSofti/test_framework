//
//  TSContextGetter.m
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSContextGetter.h"
#import "TSHttpsGetter.h"
#import "TSLog.h"

/**
 *  从指定服务器获取测试相关的配置信息。
 *  默认服务器地址为 https://58.60.106.188:12210/speedpro/configapi
 */

@implementation TSContextGetter
{
    TSVideoContext *videoContext;

    TSWebContext *webContext;

    TSBandwidthContext *bandwidthContext;
}

static NSString *defaultServerURL = @"https://58.60.106.188:12210/speedpro/configapi?lang=%@";


static NSString *serverURL = @"https://58.60.106.188:12210/speedpro/configapi?lang=CN";


/**
 *  根据IP运营商信息进行初始化对象
 *
 *  @param ipAndISP IP运营商信息
 *
 *  @return 获取测试配置信息的对象
 */
- (id)initWithIPAndISP:(TSIPAndISP *)ipAndISP
{
    if (ipAndISP)
    {
        NSString *countryCode = ipAndISP.countryCode;
        if (countryCode)
        {
            // 修改URL参数
            serverURL = [NSString stringWithFormat:defaultServerURL, countryCode];
        }
    }

    return self;
}

/**
 *  从缺省的指定服务器请求数据
 */
- (void)requestForData
{
    TSHttpsGetter *getter = [[TSHttpsGetter alloc] initWithURLNSString:serverURL];
    self.data = [getter getResponseData];
}

/**
 *  解析从服务器获取的数据，并将数据解析为对应测试的Context对象
 */
- (void)parseData
{
    if (!self.data)
    {
        TSError (@"request data is null");
        return;
    }

    NSError *error = nil;
    NSDictionary *dictionay =
    [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    if (error)
    {
        TSError (@"convert NSData to json fail. Error:%@", error);
        return;
    }

    if (dictionay)
    {
        NSString *videoURLS = [dictionay valueForKey:@"ottUrls"];
        //        NSString *webURLs = [dictionay valueForKey:@"webUrls"];
        //        NSString *versionCode = [dictionay valueForKey:@"versionCode"];
        //        NSString *downloadUrl = [dictionay valueForKey:@"downloadUrl"];
        videoContext = [[TSVideoContext alloc] initWithVideoURLs:videoURLS];
        // webContext = [[TSWebContext alloc] initWithWebURLs:webURLs];
    }
}

/**
 *  获取视频Context对象
 *
 *  @return 视频Context对象
 */
- (TSVideoContext *)getVideoContext
{
    return videoContext;
}

/**
 *  获取网页Context对象
 *
 *  @return 网页Context对象
 */
- (TSWebContext *)getWebContext
{
    return webContext;
}

/**
 *  获取带宽Context对象
 *
 *  @return 带宽Context对象
 */
- (TSBandwidthContext *)getBandwidthContext
{
    return bandwidthContext;
}


@end
