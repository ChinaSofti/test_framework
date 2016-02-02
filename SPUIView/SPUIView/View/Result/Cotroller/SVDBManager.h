//
//  SVDBManager.h
//  SPUIView
//
//  Created by XYB on 16/1/30.
//  Copyright © 2016年 chinasofti. All rights reserved.
//


#import <Foundation/Foundation.h>

//@class SVTestModel;
//@class SVVideoTestModel;
//@class SVWebTestModel;
//@class SVBandWidthModel;
@class SVSummaryResultModel;

@interface SVDBManager : NSObject

+ (id)defaultDBManager;


// SVTest
- (void)addSVSummaryResultModel:(SVSummaryResultModel *)test;

- (void)deleteSVSummaryResultModel:(SVSummaryResultModel *)test;

- (NSArray *)searchAllSVSummaryResultModels;


@end
