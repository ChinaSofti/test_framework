//
//  TSIPAndISPGetter.m
//  TaskService
//
//  Created by Rain on 1/27/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "TSHttpGetter.h"
#import "TSIPAndISPGetter.h"
#import "TSLog.h"

@implementation TSIPAndISPGetter

NSString *defaultURL = @"http://ip-api.com/json";

TSIPAndISP *ipAndISP;

+ (TSIPAndISP *)getIPAndISP
{
    NSData *data = [TSHttpGetter requestDataWithoutParameter:defaultURL];
    if (!data)
    {
        return nil;
    }

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error)
    {
        TSError (@"parse json fail. Error:%@", error);
        return nil;
    }

    ipAndISP = [[TSIPAndISP alloc] init];
    [ipAndISP setAs:[json valueForKey:@"as"]];
    [ipAndISP setZip:[json valueForKey:@"zip"]];
    [ipAndISP setQuery:[json valueForKey:@"query"]];
    [ipAndISP setLat:[json valueForKey:@"lon"]];
    [ipAndISP setLon:[json valueForKey:@"lon"]];
    [ipAndISP setCountry:[json valueForKey:@"country"]];
    [ipAndISP setCountryCode:[json valueForKey:@"countryCode"]];
    [ipAndISP setIsp:[json valueForKey:@"isp"]];
    [ipAndISP setCity:[json valueForKey:@"city"]];
    [ipAndISP setRegion:[json valueForKey:@"region"]];
    [ipAndISP setTimezone:[json valueForKey:@"timezone"]];
    [ipAndISP setOrg:[json valueForKey:@"org"]];
    [ipAndISP setRegionName:[json valueForKey:@"regionName"]];
    [ipAndISP setStatus:[json valueForKey:@"status"]];

    TSDebug (@"return ipAndISP [as:%@  zip:%@  query:%@  lat:%@  lon:%@  country:%@  "
             @"countryCode:%@  "
             @"isp:%@  city:%@  region:%@   timezone:%@  org:%@   regionName:%@   status:%@]",
             ipAndISP.as, ipAndISP.zip, ipAndISP.query, ipAndISP.lat, ipAndISP.lon,
             ipAndISP.country, ipAndISP.countryCode, ipAndISP.isp, ipAndISP.city, ipAndISP.region,
             ipAndISP.timezone, ipAndISP.org, ipAndISP.regionName, ipAndISP.status);
    return ipAndISP;
}

@end
