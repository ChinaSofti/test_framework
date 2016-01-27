//
//  CTLog.m
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "CTLog.h"

@implementation CTLog


/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)CTError:(const char *)function line:(unsigned int)line message:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        NSLog (@"[ERROR] %@  %d  %@", functionName, line, message);
        va_end (args);
    }
}

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTWarn:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        NSLog (@"[WARN] %@  %d  %@", functionName, line, message);
        va_end (args);
    }
}

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTInfo:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{

    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        NSLog (@"[INFO] %@  %d  %@", functionName, line, message);
        va_end (args);
    }
}
/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTDebug:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        NSLog (@"[DEBUG] %@  %d  %@", functionName, line, message);
        va_end (args);
    }
}


@end
