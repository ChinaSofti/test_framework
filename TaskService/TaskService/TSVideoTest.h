//
//  TSVideoTest.h
//  TaskService
//
//  Created by Rain on 2/1/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSVideoTestSectionResult.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSVideoTest : NSObject


- (id)initWithView:(UIView *)showVideoView;

- (void)startTest:(void (^) (TSVideoTestSectionResult *sectionResult, bool status, NSError *error))completionHandler;

- (void)stopTest;

@end
