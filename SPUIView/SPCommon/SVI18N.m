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


//创建静态变量bundle，以及获取方法bundle
static NSBundle *bundle = nil;

// 语言设置
static NSString *_language;

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
            _language = [defaults objectForKey:@"language"];
            if (!_language)
            {
                NSArray *languages = [NSLocale preferredLanguages];
                _language = [languages objectAtIndex:0];
                if ([_language containsString:@"zh"])
                {
                    _language = @"zh";
                }
                else
                {
                    _language = @"en";
                }
                [defaults setObject:_language forKey:@"language"];
                [defaults synchronize];
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
- (void)setLanguage:(NSString *)langugae
{
    if ([langugae containsString:@"zh"])
    {
        langugae = @"zh";
    }
    else
    {
        langugae = @"en";
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _language = langugae;
    [defaults setObject:_language forKey:@"langugae"];
    [defaults synchronize];
}

/**
 *  查询当前语言
 *
 *  @return 当前语言
 */
- (NSString *)getLanguage
{
    return _language;
}


//初始化语言文件
+ (void)initUserLanguage
{

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

    NSString *string = [def valueForKey:@"userLanguage"];
    if (string.length == 0)
    {
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray *languages = [def objectForKey:@"AppleLanguages"];

        NSString *current = [languages objectAtIndex:0];

        string = current;

        [def setValue:current forKey:@"userLanguage"];
        //持久化，不加的话不会保存
        [def synchronize];
    }
    //    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    //生成bundle
    bundle = [NSBundle bundleWithPath:path];
}

//获取系统当前语言
+ (NSString *)systemLanguage;
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    return currentLanguage;
}

//获取用户当前所设置的语言
+ (NSString *)userLanguage
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user valueForKey:@"userLanguage"];
}

//获取当前语言
+ (NSString *)currentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];

    return currentLanguage;
}

//设置当前语言
+ (void)setUserlanguage:(Language)language
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *lan;
    switch (language)
    {
    case English:
        lan = ENGLISH;
        break;
    case Chinese:
        lan = CHINESE;
        break;
    case System:
        lan = SYSTEM;
        break;

    default:
        break;
    }
    // 1.第一步改变bundle的值

    NSString *path = [[NSBundle mainBundle] pathForResource:lan ofType:@"lproj"];

    if (language != System)
    {
        bundle = [NSBundle bundleWithPath:path];
    }

    // 2.持久化
    [user setValue:lan forKey:@"userLanguage"];

    [user synchronize];
}

+ (NSString *)valueForKey:(NSString *)key
{
    if (bundle == nil)
    {
        [self initUserLanguage];
    }
    //    NSLog(@"用户设置语言%@",[self userLanguage] );
    //    NSLog(@"当前系统语言%@",[self systemLanguage] );

    NSString *path;
    if (![[self userLanguage] isEqualToString:ENGLISH] && ![[self userLanguage] isEqualToString:CHINESE])
    {

        if ([[self systemLanguage] isEqualToString:@"zh-Hans-US"])
        {
            path = [[NSBundle mainBundle] pathForResource:CHINESE ofType:@"lproj"];
        }
        else
        {
            path = [[NSBundle mainBundle] pathForResource:ENGLISH ofType:@"lproj"];
        }
        bundle = [NSBundle bundleWithPath:path];
    }
    return [bundle localizedStringForKey:key value:nil table:@"i18n"];
}

@end
