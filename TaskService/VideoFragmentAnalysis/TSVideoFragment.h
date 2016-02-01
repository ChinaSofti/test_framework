//
//  TSVideoFragment.h
//  TaskService
//
//  Created by Rain on 1/29/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSVideoFragment : NSObject

// 视频URL
@property NSString *_videoURL;

- (id)initWithURL:(NSString *)videoURL;

@end
