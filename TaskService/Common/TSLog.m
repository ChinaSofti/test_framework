//
//  CTLog.m
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSLog.h"

@implementation TSLog


/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)TSError:(const char *)function line:(unsigned int)line message:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        [TSLog _log:functionName line:line message:message];
        va_end (args);
    }
}

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)TSWarn:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        [TSLog _log:functionName line:line message:message];
        va_end (args);
    }
}

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)TSInfo:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{

    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        [TSLog _log:functionName line:line message:message];
        va_end (args);
    }
}
/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)TSDebug:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        [TSLog _log:functionName line:line message:message];
        va_end (args);
    }
}

/**
 *  日志记录，将日志打印到控制台或输出到文件中
 *
 *  @param functionName <#functionName description#>
 *  @param line         <#line description#>
 *  @param message      <#message description#>
 */
+ (void)_log:(NSString *)functionName line:(unsigned int)line message:(NSString *)message
{
    NSLog (@"%@", message);
}


@end
