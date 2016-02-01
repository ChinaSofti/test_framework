//
//  TSYoukuSIDAndTokenAndEqGetter.m
//  TaskService
//
//  Created by Rain on 1/31/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSDecode64.h"
#import "TSLog.h"
#import "TSRc4.h"
#import "TSYoukuSIDAndTokenAndEqGetter.h"

@implementation TSYoukuSIDAndTokenAndEqGetter


- (id)initWithEncrpytString:(NSString *)encryptString vid:(NSString *)vid
{
    TSDebug (@"vid = %@   encryptString = %@", vid, encryptString);
    // 计算 sid 和 token
    NSString *keyA = @"becaf9be";
    NSMutableArray *array = [TSDecode64 decode64:encryptString];
    NSString *temp = [TSRc4 Rc4:keyA byteArray:array isToBase64:false];
    NSArray *sidAndToken = [temp componentsSeparatedByString:@"_"];
    _sid = sidAndToken[0];
    _token = sidAndToken[1];

    // 计算 eq 的值
    NSString *keyB = @"bf7e5f01";
    NSString *whole = [NSString stringWithFormat:@"%@_%@_%@", _sid, vid, _token];
    TSDebug (@"sid_vid_token = %@", whole);

    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    for (int j = 0; j < whole.length; j++)
    {
        NSNumber *myB0 = [NSNumber numberWithUnsignedChar:([whole characterAtIndex:j] & 0xff)];
        [array2 addObject:myB0];
    }
    NSString *eq = [TSRc4 Rc4:keyB byteArray:array2 isToBase64:true];
    _ep = [eq stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    TSDebug (@"eq = %@", _ep);

    return self;
}

- (NSString *)getSID
{
    return _sid;
}

- (NSString *)getToken
{
    return _token;
}

- (NSString *)getEq
{
    return _ep;
}

@end
