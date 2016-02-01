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
NSString *_toGetSourceCode = @"http://play.youku.com/play/get.json?vid=%@&ct=12";

// 正则用于提取vid
NSString *_VID_REG = @"^http://v.youku.com/v_show/id_([0-9a-zA-Z=]+)([_a-z0-9]+)?\\.html";

// 获取视频分片信息
NSString *_getVideoFragmentInfoURL = @"http://pl.youku.com/playlist/"
                                     @"m3u8?vid=%@&type=%@&ts=%@&keyframe=1&ep=%@&sid=%@&token=%@&"
                                     @"ctype=12&ev=1&oip=%@";
NSString *_getVideoFragmentInfoURL2 =
@"http://pl.youku.com/playlist/m3u8?ts=%@&keyframe=0&vid=%@&type=hd2&r=/"
@"3sLngL0Q6CXymAIiF9JUQQtnOFNJPUClO8A56KJJcT8UB+NRAMQ09zE6rNj4EKMxAvRByWf6hitgv75Fv0ffXvXr3V+"
@"TeFeXXXY4Voq8uwTjgKzsLu076QkQCDwPh82K1TunJTp1Jl0U01kjXVQJwMR2HImfwF/"
@"fOFUE3edVbc=&ypremium=1&oip=%@&token=%@&sid=%@&did=%@&ev=1&ctype=20&ep=%@";

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
    [browser2 addHeader:@"ykss" value:ykss];
    [browser2 addHeader:@"__ysuid" value:[TSYouKu__ysuid getYsuid:1]];
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
    //    NSLog (@"\r\n%@", videoSourceCodeJson);
    NSDictionary *dataOfVideoSourceCodeJson = [videoSourceCodeJson valueForKey:@"data"];

    // 检测服务器返回的JSON信息是否存在error节点，如果存在，说明服务器存在异常。当前无法查询该视频信息
    NSArray *errorInfo = [dataOfVideoSourceCodeJson valueForKey:@"error"];
    if (errorInfo)
    {
        // 视频服务器存在异常。当前无法查询该视频信息。
        TSError (@"video website return error. return json:%@", dataOfVideoSourceCodeJson);
        return _videoInfo;
    }

    NSString *videoTitle = [[dataOfVideoSourceCodeJson valueForKey:@"video"] valueForKey:@"title"];
    NSString *oip = [[dataOfVideoSourceCodeJson valueForKey:@"security"] valueForKey:@"ip"];
    NSString *encryptString =
    [[dataOfVideoSourceCodeJson valueForKey:@"security"] valueForKey:@"encrypt_string"];
    TSYoukuSIDAndTokenAndEqGetter *sidAndTokenAndEqGetter =
    [[TSYoukuSIDAndTokenAndEqGetter alloc] initWithEncrpytString:encryptString vid:vid];
    NSString *sid = [sidAndTokenAndEqGetter getSID];
    NSString *token = [sidAndTokenAndEqGetter getToken];
    NSString *ep = [sidAndTokenAndEqGetter getEq];
    NSString *ts = [TSTimeUtil getCurTimeStamp];

    ep = @"NRWtypxq9Eby5or4cLYCegGac1C5klSA621Z6v4KwBmLWJ2zsGljt79CuJjr0HAa";
    _getVideoFragmentInfoURL2 =
    @"http://pl.youku.com/playlist/m3u8?ts=1454296362&keyframe=0&vid=XODMxMzYyMjgw&type=hd2&r=/"
    @"3sLngL0Q6CXymAIiF9JUQQtnOFNJPUClO8A56KJJcT8UB+NRAMQ09zE6rNj4EKMxAvRByWf6hitgv75Fv0ffXvXr3V+"
    @"TeFeXXXY4Voq8uwTjgKzsLu076QkQCDwPh82K1TunJTp1Jl0U01kjXVQJwMR2HImfwF/"
    @"fOFUE3edVbc=&ypremium=1&oip=1931268481&token=2619&sid=145429636233920689da4&did=1454296362&"
    @"ev=1&ctype=20&ep=NRWtypxq9Eby5or4cLYCegGac1C5klSA621Z6v4KwBmLWJ2zsGljt79CuJjr0HAa";
    NSString *framgentDetailQueryURL =
    [NSString stringWithFormat:_getVideoFragmentInfoURL2, ts, vid, oip, token, sid, ts, ep];

    //    NSString *framgentDetailQueryURL =
    //    [NSString stringWithFormat:_getVideoFragmentInfoURL2, vid, @"mp4", ts, eq, sid, token,
    //    oip];
    //    NSString *reponseResult = [TSHttpGetter requestWithoutParameter:framgentDetailQueryURL];
    TSWebBrowser *browser3 = [[TSWebBrowser alloc] init];
    [browser3 addHeader:@"Referer" value:_videoURL];
    [browser3 addHeader:@"r" value:@"rasdadsasdasdadsad"];
    [browser3 browser:framgentDetailQueryURL requestType:GET];
    NSString *reponseReuslt =
    [[NSString alloc] initWithData:[browser3 getResponseData] encoding:NSUTF8StringEncoding];
    NSLog (@"%@", reponseReuslt);
    return nil;
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
