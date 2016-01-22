//
//  CTInternationalControl.m
//  Localizable
//
//  Created by 许彦彬 on 16/1/22.
//  Copyright © 2016年 HuaWei. All rights reserved.
//

#import "CTI18N.h"

@implementation CTI18N

//创建静态变量bundle，以及获取方法bundle
static NSBundle* bundle = nil;

//初始化语言文件
+ (void)initUserLanguage
{
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];

    NSString* string = [def valueForKey:@"userLanguage"];
    if (string.length == 0) {
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray* languages = [def objectForKey:@"AppleLanguages"];

        NSString* current = [languages objectAtIndex:0];

        string = current;

        [def setValue:current forKey:@"userLanguage"];
        //持久化，不加的话不会保存
        [def synchronize];
    }
    //    //获取文件路径
    NSString* path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    //生成bundle
    bundle = [NSBundle bundleWithPath:path];
}

//获取系统当前语言
+ (NSString*)systemLanguage;
{
    NSArray* languages = [NSLocale preferredLanguages];
    NSString* currentLanguage = [languages objectAtIndex:0];

    return currentLanguage;
}

//获取用户当前所设置的语言
+ (NSString*)userLanguage
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    return [user valueForKey:@"userLanguage"];
}

//设置当前语言
+ (void)setUserlanguage:(NSString*)language
{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];

    //1.第一步改变bundle的值
    NSString* path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];

    if (![language isEqualToString:@"system"]) {
        bundle = [NSBundle bundleWithPath:path];
    }

    //2.持久化
    [user setValue:language forKey:@"userLanguage"];

    [user synchronize];
}

+ (NSString*)valueForKey:(NSString*)key
{
    if (bundle == nil) {
        [self initUserLanguage];
    }
    //    NSLog(@"用户设置语言%@",[self userLanguage] );
    //    NSLog(@"当前系统语言%@",[self systemLanguage] );
    if ([[self userLanguage] isEqualToString:@"system"]) {
        NSString* path;
        if ([[self systemLanguage] isEqualToString:@"zh-Hans-US"]) {
            path = [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        }
        else {
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        }

        bundle = [NSBundle bundleWithPath:path];
    }

    NSString* value = [bundle localizedStringForKey:key value:nil table:@"i18n"];
    if (value) {
        return value;
    }
    else {
        return key;
    }

    //  return [bundle localizedStringForKey:key value:nil table:@"i18n"];
}

@end
