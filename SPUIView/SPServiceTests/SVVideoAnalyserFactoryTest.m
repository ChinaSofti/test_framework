//
//  SVVideoAnalyserFactory.m
//  SpeedPro
//
//  Created by Rain on 3/8/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVVideoAnalyserFactory.h"
#import "SVVideoAnalyser_youtube.h"
#import <XCTest/XCTest.h>

@interface SVVideoAnalyserFactoryTest : XCTestCase

@end

@implementation SVVideoAnalyserFactoryTest


- (void)testExample
{
    SVVideoAnalyser *analyser =
    [SVVideoAnalyserFactory createAnalyser:@"https://www.youtube.com/watch?v=TmDKbUrSYxQ"];
    SVVideoInfo *videoInfo = [analyser analyse];
}

- (void)testParseReg
{
    NSString *_SIGNATURE_REG = @".*signature=([0-9a-zA-Z.]+)&.*";
    NSString *videoURLString =
    @"url=https://r3---sn-ntq7yn7z.googlevideo.com/"
    @"videoplayback?itag=266&mm=31&expire=1457544590&ms=au&mt=1457522834&pl=24&mv=m&upn=L7y5n5ND-"
    @"zo&source=youtube&signature=32647910416F5E1842EB9818DAF198526385111C."
    @"6ECAABA852AF34EAEAEE881007A61E68456D4971&nh=IgpwcjAxLnN5ZDEwKgkxMjcuMC4wLjE&requiressl=yes&"
    @"ip=45.32.241.177&mime=video%2Fmp4&initcwndbps=3623750&ipbits=0&fexp=9405969%2C9406821%"
    @"2C9412914%2C9416126%2C9418642%2C9420452%2C9422596%2C9423661%2C9423662%2C9423850%2C9424581%"
    @"2C9426471%2C9426602%2C9427676%2C9427706%2C9428247%2C9429388&dur=281.014&mn=sn-ntq7yn7z&lmt="
    @"1447293369552178&key=yt6&clen=751660159&sparams=clen%2Cdur%2Cgir%2Cid%2Cinitcwndbps%2Cip%"
    @"2Cipbits%2Citag%2Ckeepalive%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cnh%2Cpl%2Crequiressl%"
    @"2Csource%2Cupn%2Cexpire&gir=yes&sver=3&id=o-ANKVUsIK0f1i1DrANuE5C6HOVE9HlEAE7uGAyIswmGN4&"
    @"keepalive=yes";

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:_SIGNATURE_REG
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:videoURLString
                                      options:NSMatchingReportCompletion
                                        range:NSMakeRange (0, [videoURLString length])];
    if (matches && matches.count > 0)
    {
        NSTextCheckingResult *checkingResult = [matches objectAtIndex:0];
        NSRange halfRange = [checkingResult rangeAtIndex:1];
        NSLog (@"%@", [videoURLString substringWithRange:halfRange]);
    }
}

- (void)testModifySignarture
{
    SVVideoAnalyser_youtube *youtube = [[SVVideoAnalyser_youtube alloc] init];
    NSString *newSignarture =
    [youtube modifySignarture:@"32647910416F5E1842EB9818DAF198526385111C."
                              @"6ECAABA852AF34EAEAEE881007A61E68456D4971"];
    NSLog (@"new signartue:%@", newSignarture);
}

@end
