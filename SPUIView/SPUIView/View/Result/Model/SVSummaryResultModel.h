//
//  SVSummaryResultModel.h
//  SPUIView
//
//  Created by XYB on 16/2/1.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVSummaryResultModel : NSObject

@property (nonatomic,copy)NSString * testId;

@property (nonatomic,copy)NSString * type;
@property (nonatomic,copy)NSString * date;
@property (nonatomic,copy)NSString * time;

@property (nonatomic,copy)NSString * testTime;
@property (nonatomic,copy)NSString * UvMOS;
@property (nonatomic,copy)NSString * loadTime;
@property (nonatomic,copy)NSString * bandwidth;


//- (id)initWithParameters:(long)testTime;

@end
