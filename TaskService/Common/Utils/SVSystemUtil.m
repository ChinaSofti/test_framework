//
//  SVSystemUtil.m
//  SPUIView
//
//  Created by Rain on 2/10/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVSystemUtil.h"

@implementation SVSystemUtil

+ (NSString *)currentSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

@end
