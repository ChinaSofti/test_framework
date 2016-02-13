//
//  TSContext.h
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 测试执行状态
 */
typedef enum _TestStatus {
    // 未知状态
    UNKNOWN = 0,
    // 测试中
    TESTING = 1,
    // 测试成功
    SUCCESS = 2,
    // 测试中止
    INTERUPT = 3,
    // 测试失败
    ERROR = 4,
} TestStatus;


@interface SVContext : NSObject
{
    NSData *_data;
}

// 测试状态
@property TestStatus testStatus;

/**
 *  初始化
 *
 *  @param data
 *
 *  @return 对象
 */
- (id)initWithData:(NSData *)data;

/**
 *  初始化后做一下操作。用于子类进行重写
 */
- (void)handleAfterInit;


@end
