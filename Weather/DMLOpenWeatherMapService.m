//
//  DMLOpenWeatherMapService.m
//  Weather
//
//  Created by DongMeiliang on 07/11/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLOpenWeatherMapService.h"

NSString *const DMLOpenWeatherMapServiceV2_5 = @"DMLOpenWeatherMapServiceV2_5";

@implementation DMLOpenWeatherMapService

#pragma mark - CTServiceProtocal
- (BOOL)isOnline
{
    return YES;
}

- (NSString *)offlineApiBaseUrl
{
    return @"http://api.openweathermap.org/data";
}

- (NSString *)onlineApiBaseUrl
{
    return @"http://api.openweathermap.org/data";
}

- (NSString *)offlineApiVersion
{
    return @"2.5";
}

- (NSString *)onlineApiVersion
{
    return @"2.5";
}

- (NSString *)onlinePublicKey
{
    return @"1ad2a245f4c37736b35e227c5b4e83f1";
}

- (NSString *)offlinePublicKey
{
    return @"1ad2a245f4c37736b35e227c5b4e83f1";
}

- (NSString *)onlinePrivateKey
{
    return @"";
}

- (NSString *)offlinePrivateKey
{
    return @"";
}

@end
