//
//  TSVideoAnalyser_YouKu.m
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSHttpGetter.h"
#import "TSLog.h"
#import "TSTimeUtil.h"
#import "TSVideoAnalyser_youku.h"
#import "TSWebBrowser.h"
#import "TSYouKu__ysuid.h"
#import "TSYoukuSIDAndTokenAndEqGetter.h"

@implementation TSVideoAnalyser_youku

// 获取密文 ip等信息
static NSString *_toGetSourceCode = @"http://play.youku.com/play/get.json?vid=%@&ct=12";

// 正则用于提取vid
static NSString *_VID_REG = @"^http://v.youku.com/v_show/id_([0-9a-zA-Z=]+)([_a-z0-9]+)?\\.html";

// 获取视频分片信息
static NSString *_getVideoFragmentInfoURL =
@"http://k.youku.com/player/getFlvPath/sid/%@_00/st/"
@"flv/fileid/"
@"%@?K=%@&ctype=12&ev=1&ts=%d&oip=%@&token=%@&ep=%@&yxon=1&special=true&hd=0&myp=0&ymovie=1&ypp=2";


/**
 *  根据视频URL查询和分析视频信息
 *  视频URL（_videoURL）的格式例如：http://v.youku.com/v_show/id_XODMxMzYyMjgw.html
 */
- (TSVideoInfo *)analyse
{
    // 请求视频播放页面，获取服务器返回Cookie中ykss的值
    TSWebBrowser *browser = [[TSWebBrowser alloc] init];
    [browser addHeader:@"Referer" value:@"http://www.youku.com"];
    [browser browser:_videoURL requestType:GET];
    NSString *ykss = [browser getReturnCookie:@"ykss"];
    NSLog (@"ykss = %@", ykss);

    // 请求/play/get.json?vid={vid}&ct=12 并在请求头中添加Referer, ykss, __ysuid。
    // Referer 头即为视频播放页面访问的URL
    // ykss 亦访问视频播放页面服务器返回的Cookie
    // __ysuid 需要根据算法进行计算获取
    NSString *vid = [self getParamsByReg];
    NSString *videoSourceCodeURL = [NSString stringWithFormat:_toGetSourceCode, vid];
    TSWebBrowser *browser2 = [[TSWebBrowser alloc] init];
    [browser2 addHeader:@"Referer" value:_videoURL];
    [browser2 addCookies:@"ykss" value:ykss];
    [browser2 addCookies:@"__ysuid" value:[TSYouKu__ysuid getYsuid:1]];
    [browser2 browser:videoSourceCodeURL requestType:GET];
    NSData *jsonData = [browser2 getResponseData];
    NSError *error;
    id videoSourceCodeJson =
    [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error)
    {
        TSError (@"%@", error);
        return _videoInfo;
    }

    NSDictionary *dataOfVideoSourceCodeJson = [videoSourceCodeJson valueForKey:@"data"];

    // 检测服务器返回的JSON信息是否存在error节点，如果存在，说明服务器存在异常。当前无法查询该视频信息
    NSArray *errorInfo = [dataOfVideoSourceCodeJson valueForKey:@"error"];
    if (errorInfo)
    {
        // 视频服务器存在异常。当前无法查询该视频信息。
        TSError (@"video website return error. return json:%@", dataOfVideoSourceCodeJson);
        return _videoInfo;
    }

    NSString *oip = [[dataOfVideoSourceCodeJson valueForKey:@"security"] valueForKey:@"ip"];
    NSString *encryptString =
    [[dataOfVideoSourceCodeJson valueForKey:@"security"] valueForKey:@"encrypt_string"];

    NSString *segUrl = nil;
    NSArray *streamArray = [dataOfVideoSourceCodeJson valueForKey:@"stream"];
    for (NSDictionary *streamObj in streamArray)
    {
        //
        NSString *streamType = [streamObj valueForKey:@"stream_type"];
        // 4K 目前手机APP只测试hd3的视频源
        if ([streamType isEqualToString:@"mp4hd3"])
        {
            NSString *streamFileid = [streamObj valueForKey:@"stream_fileid"];


            TSYoukuSIDAndTokenAndEqGetter *sidAndTokenAndEqGetter =
            [[TSYoukuSIDAndTokenAndEqGetter alloc] initWithEncrpytString:encryptString
                                                            streamFileid:streamFileid];
            NSString *sid = [sidAndTokenAndEqGetter getSID];
            NSString *token = [sidAndTokenAndEqGetter getToken];
            NSString *ep = [sidAndTokenAndEqGetter getEq];
            //            NSString *ts = [TSTimeUtil getCurTimeStamp];


            NSArray *segsArray = [streamObj valueForKey:@"segs"];
            NSString *segsKey = [segsArray[0] valueForKey:@"key"];
            long millisecondVideo = [[segsArray[0] valueForKey:@"total_milliseconds_video"] longLongValue];
            //            int size = [[segsArray[0] valueForKey:@"size"] intValue];
            // player/getFlvPath/sid/%s_00/st/flv/fileid/%s?K=%s&ctype=12&ev=1&ts=%s&oip=%s&token=%s&ep=%s"
            segUrl = [NSString stringWithFormat:_getVideoFragmentInfoURL, sid, streamFileid,
                                                segsKey, (millisecondVideo / 1000), oip, token, ep];
        }
    }

    if (!segUrl)
    {
        return nil;
    }

    NSLog (@"segURL %@", segUrl);
    TSWebBrowser *browser3 = [[TSWebBrowser alloc] init];
    [browser3 addHeader:@"Referer" value:_videoURL];
    [browser3 browser:segUrl requestType:GET];
    NSData *jsonData3 = [browser3 getResponseData];
    NSLog (@"data : %@", [[NSString alloc] initWithData:jsonData3 encoding:NSUTF8StringEncoding]);

    NSError *error3;
    id videoRealURLJson =
    [NSJSONSerialization JSONObjectWithData:jsonData3 options:0 error:&error3];
    if (error)
    {
        TSError (@"%@", error);
        return _videoInfo;
    }

    NSString *videoRealURL = [videoRealURLJson[0] valueForKey:@"server"];
    NSLog (@"videoRealURL: %@", videoRealURL);

    NSString *videoTitle = [[dataOfVideoSourceCodeJson valueForKey:@"video"] valueForKey:@"title"];
    _videoInfo._vid = vid;
    _videoInfo._title = videoTitle;
    _videoInfo._videoRealURL = videoRealURL;
    return _videoInfo;
}


/**
 *  解析视频URL，获取其中“id_”和“.html”之间的值
 *
 *  @return 视频ID
 */
- (NSString *)getParamsByReg
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:_VID_REG
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:_videoURL
                                      options:NSMatchingReportCompletion
                                        range:NSMakeRange (0, [_videoURL length])];
    if (matches && matches.count > 0)
    {
        NSTextCheckingResult *checkingResult = [matches objectAtIndex:0];
        NSRange halfRange = [checkingResult rangeAtIndex:1];
        return [_videoURL substringWithRange:halfRange];
    }

    return nil;
}

@end
