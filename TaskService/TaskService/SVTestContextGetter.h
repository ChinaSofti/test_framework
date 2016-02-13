//
//  TSContextGetter.h
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVBandwidthTestContext.h"
#import "SVIPAndISP.h"
#import "SVVideoTestContext.h"
#import "SVWebTestContext.h"
#import <Foundation/Foundation.h>

/**
 *  从指定服务器获取测试相关的配置信息。
 *  默认服务器地址为 https://58.60.106.188:12210/speedpro/configapi
 */
@interface SVContextGetter : NSObject


@property NSData *data;

/**
 *  根据IP运营商信息进行初始化对象
 *
 *  @param ipAndISP IP运营商信息
 *
 *  @return 获取测试配置信息的对象
 */
- (id)initWithIPAndISP:(SVIPAndISP *)ipAndISP;

/**
 *  从缺省的指定服务器请求数据
 */
- (void)requestForData;

/**
 *  解析从服务器获取的数据，并将数据解析为对应测试的Context对象
 */
- (void)parseData;

/**
 *  获取视频Context对象
 *
 *  @return 视频Context对象
 */
- (SVVideoTestContext *)getVideoContext;

/**
 *  获取网页Context对象
 *
 *  @return 网页Context对象
 */
- (SVWebTestContext *)getWebContext;

/**
 *  获取带宽Context对象
 *
 *  @return 带宽Context对象
 */
- (SVBandwidthTestContext *)getBandwidthContext;

@end
