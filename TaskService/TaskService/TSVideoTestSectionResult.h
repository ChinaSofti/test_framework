//
//  TSVideoTestSectionResult.h
//  TaskService
//
//  Created by Rain on 2/1/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSVideoTestSectionResult : NSObject

@property (nonatomic) float UvMos;

@property (nonatomic) float firstBufferTime;

@property (nonatomic) int cuttonTimes;

@property (nonatomic) float birate;

@property (nonatomic) NSString *screenResolution;

- (id)init;

@end
