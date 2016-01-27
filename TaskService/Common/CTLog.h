//
//  CTLog.h
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#ifndef CTLog_h
#define CTLog_h


#define LOG_OBJC_MAYBE_ERROR(frmt, ...) \
    [CTLog CTError:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define LOG_OBJC_MAYBE_WARN(frmt, ...) \
    [CTLog CTWarn:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define LOG_OBJC_MAYBE_INFO(frmt, ...) \
    [CTLog CTInfo:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define LOG_OBJC_MAYBE_DEBUG(frmt, ...) \
    [CTLog CTDebug:__PRETTY_FUNCTION__ line:__LINE__ format:(frmt), ##__VA_ARGS__]


#define CTError(frmt, ...) LOG_OBJC_MAYBE_ERROR (frmt, ##__VA_ARGS__)
#define CTWarn(frmt, ...) LOG_OBJC_MAYBE_WARN (frmt, ##__VA_ARGS__)
#define CTInfo(frmt, ...) LOG_OBJC_MAYBE_INFO (frmt, ##__VA_ARGS__)
#define CTDebug(frmt, ...) LOG_OBJC_MAYBE_DEBUG (frmt, ##__VA_ARGS__)

#endif


#import <Foundation/Foundation.h>
/**
 *  日志记录器。
 *  支持ERROR，WARN，INFO，DEBUG四种级别日志
 */
@interface CTLog : NSObject


/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)CTError:(const char *)function line:(unsigned int)line message:(NSString *)format, ...;

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTWarn:(const char *)function
          line:(unsigned int)line
        format:(NSString *)format, ... NS_FORMAT_FUNCTION (3, 4);

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTInfo:(const char *)function
          line:(unsigned int)line
        format:(NSString *)format, ... NS_FORMAT_FUNCTION (3, 4);
/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTDebug:(const char *)function
           line:(unsigned int)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION (3, 4);

@end
