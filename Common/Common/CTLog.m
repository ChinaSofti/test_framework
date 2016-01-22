//
//  CTLog.m
//  Common
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "CTLog.h"

@implementation CTLog

+ (void)log:(unsigned int)level
       file:(const char*)file
   function:(const char*)function
       line:(unsigned int)line
     format:(NSString*)format, ... NS_FORMAT_FUNCTION(5, 6)
{
    //NSLog(@"--------------------------------------------");
    NSLog(@"%d %s  %d %@", level, function, line, format);
    // NSLog(@"--------------------------------------------");

    if (level == LOG_LEVEL_ERROR) {
    }
    else if (level == LOG_LEVEL_WARN) {
    }
    else if (level == LOG_LEVEL_WARN) {
    }
    else {
    }

    NSString* tmpDir = NSTemporaryDirectory();
    NSLog(@"%@", tmpDir);

    NSString* str = @"asdasdads";
    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //    NSData* data = [str dataUsingEncoding:enc];
    //    NSString* filepath = [tmpDir stringByAppendingPathComponent:@"log.txt"];
    //    [data writeToFile:filepath atomically:NO];

    //    NSFileHandle* logFile = [[NSFileHandlefileHandleForWritingAtPath:filepath] retain];
    //    [logFile seekToEndOfFile];
    //    [logFilewriteData:yourData];
    //    [logFilesynchronizeFile];
    NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:@"tarena/desktop/key"];
    [fh seekToEndOfFile];
    [fh writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

/**
 *  ERROR级别日志记录
 *
 *  @param exception NSException|NSError 异常或错误对象
 *  @param format    消息
 */
+ (void)CTError:(id)exception message:(NSString*)format, ...
{
}

/**
 *  ERROR级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTError:(NSString*)format, ...
{
    NSLog(@"error test FOUNDATION_EXPORT: %@", format);
}

/**
 *  WARN级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTWarn:(NSString*)format, ...
{
}

/**
 *  INFO级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTInfo:(NSString*)format, ...
{
}

/**
 *  DEBUG级别日志记录
 *
 *  @param format 消息
 */
+ (void)CTDebug:(NSString*)format, ...
{
    //    void* callstack[128];
    //    int frames = backtrace(callstack, 128);
    //    char** strs = backtrace_symbols(callstack, frames);
    //    NSString* methodName = [NSString stringWithUTF8String:strs[1]];
    //    free(strs);

    NSLog(@"INFO %@", format);
}

@end
