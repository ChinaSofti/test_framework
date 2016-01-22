//
//  CTInternationalControl.h
//  Localizable
//
//  Created by 许彦彬 on 16/1/22.
//  Copyright © 2016年 HuaWei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTI18N : NSObject

//设置当前语言
+ (void)setUserlanguage:(NSString*)language;

//根据 key 获取 值
+ (NSString*)valueForKey:(NSString*)key;

@end
