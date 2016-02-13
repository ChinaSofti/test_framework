//
//  TSVideoAnalyser_YouKu.h
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoAnalyser.h"

@interface TSVideoAnalyser_youku : TSVideoAnalyser

/**
 *  根据视频URL查询和分析视频信息
 */
- (TSVideoInfo *)analyse;

@end
