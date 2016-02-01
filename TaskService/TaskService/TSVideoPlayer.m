//
//  VideoPlayer.m
//  TaskService
//
//  Created by Rain on 1/21/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoPlayer.h"

@implementation TSVideoPlayer
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
- (id)initWithURL:(UIView *)showOnView videoPath:(NSURL *)videoPath
{
    _showOnView = showOnView;
    _videoPath = videoPath;
    NSLog (@"init player videopath:%@ view:%@", _videoPath, _showOnView);
    [self initPlayer];
    return self;
}

/**
 *  播放视频
 */
- (void)play
{

    if (_videoPath)
    {
        BOOL isPlaying = [_VMpalyer isPlaying];
        if (isPlaying)
        {
            // 如果视频正在播放，不做任何处理
            NSLog (@"have been playing");
            return;
        }
        else
        {
            if (_didPrepared)
            {
                // 开始播放视频
                NSLog (@"start play");
                [_VMpalyer start];
            }
            else
            {
                NSLog (@"paly prepareVideo");
                [self prepareVideo];
            }
        }
    }
}

/**
 *  停止视频播放
 */
- (void)stop
{
    BOOL isPlaying = [_VMpalyer isPlaying];
    // 视频正在播放，则停止视频
    if (_VMpalyer && isPlaying)
    {
        NSLog (@"have been pause");
        [_VMpalyer pause];
        [_VMpalyer reset];
        //        [_VMpalyer unSetupPlayer];
    }
}

- (void)initPlayer
{
    if (!_VMpalyer)
    {
        _VMpalyer = [VMediaPlayer sharedInstance];
        [_VMpalyer setupPlayerWithCarrierView:_showOnView withDelegate:self];
    }
}

- (void)prepareVideo
{
    if (_videoPath)
    {
        NSLog (@"prepareVideo");
        //播放时不要锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        [_VMpalyer setDataSource:_videoPath];
        [_VMpalyer prepareAsync];
    }
}

/**
 * Called when the player prepared.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    _didPrepared = YES;
    [player start];
    NSLog (@"palying");
}

/**
 * Called when the player playback completed.
 *
 * @param player The shared media player instance.
 * @param arg Not use.
 */
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [player reset];
    _didPrepared = NO;
}

/**
 * Called when the player have error occur.
 *
 * @param player The shared media player instance.
 * @param arg Contain the detail error information.
 */
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    NSLog (@"VMediaPlayer Error: %@", arg);
    if (_VMpalyer)
    {
        [_VMpalyer reset];
    }
}

@end
