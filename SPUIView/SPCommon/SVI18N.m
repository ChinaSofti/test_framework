//
//  CTInternationalControl.m
//  Localizable
//
//  Created by 许彦彬 on 16/1/22.
//  Copyright © 2016年 HuaWei. All rights reserved.
//

#import "SVI18N.h"

#define ENGLISH @"en"
#define CHINESE @"zh-Hans"
#define SYSTEM @"system"

@implementation SVI18N
{
    NSBundle *_bundle;
}

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (id)sharedInstance
{
    static SVI18N *i18n;
    @synchronized (self)
    {
        if (i18n == nil)
        {
            i18n = [[super allocWithZone:NULL] init];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *language = [defaults objectForKey:@"language"];
            if (!language)
            {
                language = [SVI18N getSystemLanguage];
                [defaults setObject:language forKey:@"language"];
                [defaults synchronize];

                //获取文件路径
                NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
                //生成bundle
                [i18n setBundle:[NSBundle bundleWithPath:path]];
            }
        }
    }

    return i18n;
}

/**
 *  覆写allocWithZone方法
 *
 *  @param zone _NSZone
 *
 *  @return 单例对象
 */
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [SVI18N sharedInstance];
}

/**
 *  覆写copyWithZone方法
 *
 *  @param zone _NSZone
 *
 *  @return 单例对象
 */

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [SVI18N sharedInstance];
}


/**
 *  设置当前语言
 *
 *  @param langugae 设置当前语言
 */
- (void)setLanguage:(NSString *)language
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults valueForKey:@"language"] isEqualToString:language])
    {
        return;
    };

    [defaults setObject:language forKey:@"language"];
    [defaults synchronize];

    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    //生成bundle
    _bundle = [NSBundle bundleWithPath:path];
}

/**
 *  查询当前语言
 *
 *  @return 当前语言
 */
- (NSString *)getLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaults valueForKey:@"language"];
    return language;
}

/**
 *  根据当前系统语言获得的NSBundle
 *
 *  @return NSBundle
 */
- (NSBundle *)getBundle
{
    return _bundle;
}

/**
 *  设置当前NSBundle
 *
 *  @param bundle NSBundle
 */
- (void)setBundle:(NSBundle *)bundle
{
    _bundle = bundle;
}

/**
 *  查询当前系统语言
 *
 *  @return 当前系统语言
 */
+ (NSString *)getSystemLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    return [languages objectAtIndex:0];
}

/**
 *  根据key查询国际化value
 *
 *  @param key key
 *
 *  @return 国际化value
 */
+ (NSString *)valueForKey:(NSString *)key
{
    SVI18N *i18n = [SVI18N sharedInstance];
    NSBundle *bundle = [i18n getBundle];
    if (!bundle)
    {
        //获取文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:[i18n getLanguage] ofType:@"lproj"];
        //生成bundle
        bundle = [NSBundle bundleWithPath:path];
        [i18n setBundle:bundle];
    }

    NSString *value = [bundle localizedStringForKey:key value:nil table:@"i18n"];
    if (value && value.length > 0)
    {
        return value;
    }
    else
    {
        return key;
    }
}

@end
