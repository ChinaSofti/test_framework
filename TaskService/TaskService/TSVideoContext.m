//
//  TSVideoContext.m
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoContext.h"

/**
 * 视频Context
 *
 - returns: 视频Context
 */

@implementation TSVideoContext
{
    NSArray *urlArray;
    NSString *videoURL;
    NSString *videoIP;
    NSString *location;
}

/**
 *  根据服务器返回视频URL集合初始化对象
 *
 *  @param videoURLs 服务器返回视频URL集合
 *
 *  @return 初始化对象
 */
- (id)initWithVideoURLs:(NSString *)videoURLs
{
    urlArray = [videoURLs componentsSeparatedByString:@"\r\n"];
    return self;
}

/**
 *  获取视频URL集合中的随记一个视频URL，用于进行视频播放和测试
 *
 *  @return 视频URL
 */
- (NSString *)getOneOfURLs
{
    if (urlArray)
    {
        int index = arc4random () % urlArray.count;
        return [urlArray objectAtIndex:index];
    }
    return nil;
}


/**
 *  获取所有视频URL
 *
 *  @return 所有视频URL
 */
- (NSArray *)getAllURLArray
{
    return urlArray;
}

@end
