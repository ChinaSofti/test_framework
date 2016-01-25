//
//  CTLog.h
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "CTLegacyMacros.h"
#import <Foundation/Foundation.h>
/**
 *  日志记录器。
 *  支持ERROR，WARN，INFO，DEBUG四种级别日志
 */
@interface CTLog : NSObject

/**
 *  <#Description#>
 *
 *  @param level    <#level description#>
 *  @param file     <#file description#>
 *  @param function <#function description#>
 *  @param line     <#line description#>
 *  @param format   <#format description#>
 */
+ (void)log:(unsigned int)level
       file:(const char*)file
   function:(const char*)function
       line:(unsigned int)line
     format:(NSString*)format, ... NS_FORMAT_FUNCTION(5, 6);

/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)CTError:(id)exception message:(NSString*)format, ...;

/**
 *  ERROR级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTError:(NSString*)format, ...;

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTWarn:(NSString*)format, ...;

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTInfo:(NSString*)format, ...;

/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTDebug:(NSString*)format, ...;

@end
