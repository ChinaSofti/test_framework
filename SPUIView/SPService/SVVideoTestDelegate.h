//
//  SVVideoTestDelegate.h
//  SPUIView
//
//  Created by Rain on 2/11/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVVideoTestContext.h"
#import "SVVideoTestResult.h"
#import <Foundation/Foundation.h>

@protocol SVVideoTestDelegate <NSObject>

@required
- (void)updateTestResultDelegate:(SVVideoTestContext *)testContext
                      testResult:(SVVideoTestResult *)testResult;

@end