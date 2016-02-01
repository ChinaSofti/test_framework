//
//  TSVideoInfo.m
//  TaskService
//
//  Created by Rain on 1/30/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoInfo.h"

@implementation TSVideoInfo


/**
 *  使用视频URL进行初始化
 *
 *  @param videoURL 视频URL
 *
 *  @return 视频信息对象
 */
- (id)initWithURL:(NSString *)videoURL
{
    self._videoURL = videoURL;
    return self;
}


@end
