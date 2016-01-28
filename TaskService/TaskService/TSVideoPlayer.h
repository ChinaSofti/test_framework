//
//  VideoPlayer.h
//  TaskService
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "Vitamio.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *
 * 视频播放器对象
 *
 */
@interface TSVideoPlayer : NSObject <VMediaPlayerDelegate>
{

    // 视频显示依赖的UIView
    UIView *_showOnView;

    // 视频地址
    NSURL *_videoPath;

    // 视频是否准备好，可以进行播放
    BOOL _didPrepared;

    // 第三方视频播放对象
    VMediaPlayer *_VMpalyer;
}

/**
 *  初始化视频播放器对象
 *
 *  @param showOnView 视频在指定的UIView上进行展示并进行播放
 *  @param videoPath   视频地址，包括远程或本地地址
 *
 *  @return 视频播放器对象
 */
- (id)initWithURL:(UIView *)showOnView videoPath:(NSURL *)videoPath;

/**
 *  播放视频
 */
- (void)play;

/**
 *  停止视频播放
 */
- (void)stop;

@end
