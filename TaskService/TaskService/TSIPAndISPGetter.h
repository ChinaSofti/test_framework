//
//  TSIPAndISPGetter.h
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSIPAndISP.h"
#import <Foundation/Foundation.h>

@interface TSIPAndISPGetter : NSObject

/**
 *  获取本机IP，归属地，运营商等信息
 *
 *  @return TSIPAndISP 本机IP，归属地，运营商等信息
 */
+ (TSIPAndISP *)getIPAndISP;

@end
