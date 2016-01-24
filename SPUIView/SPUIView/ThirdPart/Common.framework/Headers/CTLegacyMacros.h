//
//  CTLegacyMacros.h
//  Common
//
//  Created by Rain on 1/22/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#ifndef CTLegacyMacros_h
#define CTLegacyMacros_h

#define LOG_LEVEL_ERROR 3
#define LOG_LEVEL_WARN 2
#define LOG_LEVEL_INFO 1
#define LOG_LEVEL_DEBUG 0

#define LOG_MACRO(lvl, frmt, ...)    \
    [CTLog log:lvl                   \
            file:__FILE__            \
        function:__PRETTY_FUNCTION__ \
            line:__LINE__            \
          format:(frmt), ##__VA_ARGS__]

#define LOG_OBJC_MAYBE(lvl, frmt, ...) \
    LOG_MACRO(lvl, frmt, ##__VA_ARGS__)

#define CTError(frmt, ...) LOG_OBJC_MAYBE(LOG_LEVEL_ERROR, frmt, ##__VA_ARGS__)
#define CTWarn(frmt, ...) LOG_OBJC_MAYBE(LOG_LEVEL_WARN, frmt, ##__VA_ARGS__)
#define CTInfo(frmt, ...) LOG_OBJC_MAYBE(LOG_LEVEL_INFO, frmt, ##__VA_ARGS__)
#define CTDebug(frmt, ...) LOG_OBJC_MAYBE(LOG_LEVEL_DEBUG, frmt, ##__VA_ARGS__)

#endif