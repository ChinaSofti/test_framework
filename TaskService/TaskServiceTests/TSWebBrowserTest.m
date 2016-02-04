//
//  TSWebBrowserTest.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSWebBrowser.h"
#import <XCTest/XCTest.h>

@interface TSWebBrowserTest : XCTestCase

@end

@implementation TSWebBrowserTest

- (void)testExample
{
    TSWebBrowser *browser = [[TSWebBrowser alloc] init];
    [browser addCookies:@"__ali" value:@"1454559233402DWv"];
    [browser addCookies:@"__aliCount" value:@"0"];
    [browser addCookies:@"__ysuid" value:@"1454559233402r80"];
    [browser browser:@"http://pl.youku.com/playlist/m3u8?ts=1454559260&keyframe=1&vid=XMTQwODUyMDc0NA==&type=hd2&r=s0KfeG/MpJGxT8zBRdWN/PR5MDecwxp/gSVk/o8apWISugfSIWAqf7v+Wx62N8+6tWW9+npHq0za6RVOLn5n+kTOfHTwUhkqWmA0BG+SELNqKnuf54vSFqvB0ycAbzh/QaS6XmebSz7XVDDvAIiX+T" requestType:GET];
    NSString *returnHeader = [browser getReturnHeader:@"Server"];
    NSLog (@"%@", returnHeader);
    NSLog (@"%@",
           [[NSString alloc] initWithData:[browser getResponseData] encoding:NSUTF8StringEncoding]);
}

@end
