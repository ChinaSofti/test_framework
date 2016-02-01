//
//  TSLog.h
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#ifndef TSLog_h
#define TSLog_h


#define LOG_OBJC_MAYBE_ERROR(frmt, ...) \
    [TSLog TSWarn:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]

#define LOG_OBJC_MAYBE_WARN(frmt, ...) \
    [TSLog TSWarn:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define LOG_OBJC_MAYBE_INFO(frmt, ...) \
    [TSLog TSInfo:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define LOG_OBJC_MAYBE_DEBUG(frmt, ...) \
    [TSLog TSDebug:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define TSError(frmt, ...) LOG_OBJC_MAYBE_ERROR (frmt, ##__VA_ARGS__)
#define TSWarn(frmt, ...) LOG_OBJC_MAYBE_WARN (frmt, ##__VA_ARGS__)
#define TSInfo(frmt, ...) LOG_OBJC_MAYBE_INFO (frmt, ##__VA_ARGS__)
#define TSDebug(frmt, ...) LOG_OBJC_MAYBE_DEBUG (frmt, ##__VA_ARGS__)

#endif


#import <Foundation/Foundation.h>
/**
 *  日志记录器。
 *  支持ERROR，WARN，INFO，DEBUG四种级别日志
 */
@interface TSLog : NSObject


/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)TSError:(const char *)function line:(unsigned int)line message:(NSString *)format, ...;

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)TSWarn:(const char *)function
          line:(unsigned int)line
        format:(NSString *)format, ... NS_FORMAT_FUNCTION (3, 4);

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)TSInfo:(const char *)function
          line:(unsigned int)line
        format:(NSString *)format, ... NS_FORMAT_FUNCTION (3, 4);
/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)TSDebug:(const char *)function
           line:(unsigned int)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION (3, 4);

@end
