//
//  TSVideoInfo.h
//  TaskService
//
//  Created by Rain on 1/30/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoFragment.h"
#import <Foundation/Foundation.h>

/**
 *  视频信息
 */
@interface TSVideoInfo : NSObject

// 视频URL
@property NSString *_videoURL;

// vid
@property NSString *_vid;

// 视频title
@property NSString *_title;


// 视频分片信息
//@property NSArray *_fragments;

// 视频分片真实地址
@property NSString *_videoRealURL;

/**
 *  使用视频URL进行初始化
 *
 *  @param videoURL 视频URL
 *
 *  @return 视频信息对象
 */
- (id)initWithURL:(NSString *)videoURL;

@end
