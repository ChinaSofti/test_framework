//
//  TSVideoContext.h
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSContext.h"

/**
 * 视频Context
 *
 - returns: 视频Context
 */
@interface TSVideoContext : TSContext


/**
 *  根据服务器返回视频URL集合初始化对象
 *
 *  @param videoURLs 服务器返回视频URL集合
 *
 *  @return 初始化对象
 */
- (id)initWithVideoURLs:(NSString *)videoURLs;

/**
 *  获取视频URL集合中的随记一个视频URL，用于进行视频播放和测试
 *
 *  @return 视频URL
 */
- (NSString *)getOneOfURLs;

/**
 *  获取所有视频URL
 *
 *  @return 所有视频URL
 */
- (NSArray *)getAllURLArray;

@end
