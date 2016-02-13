//
//  TSHttpsGetter.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVHttpsGetter.h"
#import "SVLog.h"


@implementation SVHttpsGetter
{
    NSData *_data;

    NSString *_urlString;

    BOOL finished;
}


/**
 *  使用指定URL字符串进行对象初始化
 *
 *  @param urlString Https协议URL的字符串
 *
 *  @return Https请求对象
 */
- (id)initWithURLNSString:(NSString *)urlString
{
    _urlString = urlString;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    return [self initWithURL:url];
}


/**
 *  使用指定URL进行对象初始化
 *
 *  @param urlString Https协议URL
 *
 *  @return Https请求对象
 */
- (id)initWithURL:(NSURL *)url
{
    SVInfo (@"request URL:%@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60];
    // NSURLRequest *request = [NSURLRequest requestWithURL:url];    NSURLConnection *conn =
    NSURLConnection *conn =
    [[NSURLConnection alloc] initWithRequest:request delegate:(id)self startImmediately:NO];
    [conn scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [conn start];
    // NSURLConnection connectionWithRequest:request delegate:self];
    while (!finished)
    {
        // spend 1 second processing events on each loop
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }

    return self;
}

/**
 *  获取服务器返回数据NSData
 *
 *  @return 服务器返回NSData
 */
- (NSData *)getResponseData
{
    return _data;
}

/**
 *  获取服务器返回数据NSString
 *
 *  @return 服务器返回NSString
 */
- (NSString *)getResponseDataString
{
    NSString *dataString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    return dataString;
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        SVError (@"request URL:%@ fail.  Error:%@", _urlString, error);
        finished = true;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data)
    {
        _data = data;
        SVInfo (@"request URL:%@ success", _urlString);
        NSString *dataString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
        SVInfo (@"request URL:%@  reponse data length:%lu", _urlString, dataString.length);
        //        TSDebug (@"response data:%@", dataString);
        finished = true;
    }
}


- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
         forAuthenticationChallenge:challenge];
}

- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


@end
