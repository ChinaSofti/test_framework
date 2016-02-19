//
//  CTLog.m
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "CocoaLumberjack.h"
#import "SVLog.h"

@implementation SVLog

static const NSUInteger ddLogLevel = DDLogLevelAll;


/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    static SVLog *log;
    @synchronized (self)
    {
        if (log == nil)
        {
            log = [[super allocWithZone:NULL] init];
            // 初始化DDLog日志输出，在这里，我们仅仅希望在xCode控制台输出
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
            // 启用颜色区分
            [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
            [DDLog addLogger:[DDTTYLogger sharedInstance]];

            DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] init];
            DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
            fileLogger.maximumFileSize = 10 * 1024 * 1024; // 10 MB
            fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
            [DDLog addLogger:fileLogger];
            // 2.2打印日志文件目录
            NSLog (@"dir is %@", fileLogger.logFileManager.logsDirectory);
        }
    }

    return log;
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
    return [SVLog sharedInstance];
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
    return [SVLog sharedInstance];
}


/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)error:(const char *)function line:(unsigned int)line message:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        SVLog *log = [SVLog sharedInstance];
        [log record:3 functionName:functionName line:line message:message];
        va_end (args);
    }
}

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)warn:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        //        [SVLog _log:functionName line:line message:message];
        SVLog *log = [SVLog sharedInstance];
        [log record:2 functionName:functionName line:line message:message];
        va_end (args);
    }
}

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)info:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{

    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        SVLog *log = [SVLog sharedInstance];
        [log record:1 functionName:functionName line:line message:message];
        va_end (args);
    }
}
/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)debug:(const char *)function line:(unsigned int)line format:(NSString *)format, ...
{
    va_list args;

    if (format)
    {
        va_start (args, format);

        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        NSString *functionName =
        [[NSString alloc] initWithCString:function encoding:NSUTF8StringEncoding];
        SVLog *log = [SVLog sharedInstance];
        [log record:0 functionName:functionName line:line message:message];
        va_end (args);
    }
}


/**
 *  日志记录，将日志打印到控制台或输出到文件中
 *
 *  @param level 日志级别
 *  @param functionName 函数名
 *  @param line         行号
 *  @param message      消息
 */
- (void)record:(int)level
  functionName:(NSString *)functionName
          line:(unsigned int)line
       message:(NSString *)message
{
    switch (level)
    {
    case 0:
        DDLogVerbose (@"DEBUG  %@  %d  %@", functionName, line, message); // 默认是黑色
        break;
    case 1:
        DDLogInfo (@"INFO  %@  %d  %@", functionName, line, message); // 默认是黑色
        break;
    case 2:
        DDLogWarn (@"WARN  %@  %d  %@", functionName, line, message); // 橙色
        break;
    case 3:
        DDLogError (@"ERROR  %@  %d  %@", functionName, line, message); // 红色
        break;
    default:
        DDLogInfo (@"INFO  %@  %d  %@", functionName, line, message);
        break;
    }
}


@end
