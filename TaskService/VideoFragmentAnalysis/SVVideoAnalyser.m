//
//  TSVideoAnalyser.m
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//


#import "TSVideoAnalyser.h"


/**
 *  视频信息分析器
 */
@implementation TSVideoAnalyser


/**
 *  根据视频URL初始化视频信息分析器
 *
 *  @param videoURL 视频URL
 *
 *  @return 视频分片分析器
 */
- (id)initWithURL:(NSString *)videoURL
{
    _videoURL = videoURL;
    _videoInfo = [[TSVideoInfo alloc] initWithURL:videoURL];
    return self;
}

/**
 *  根据视频URL查询和分析视频信息
 */
- (TSVideoInfo *)analyse
{
    if (_videoURL)
    {
        //
    }
    return _videoInfo;
}


@end
