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
    [browser addHeader:@"aaaaa" value:@"bbbb"];
    [browser browser:@"http://www.cocoachina.com" requestType:GET];
    NSString *returnHeader = [browser getReturnHeader:@"Server"];
    NSLog (@"%@", returnHeader);
    NSLog (@"%@",
           [[NSString alloc] initWithData:[browser getResponseData] encoding:NSUTF8StringEncoding]);
}

@end
