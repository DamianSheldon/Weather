//
//  DMLCurrentWeatherAPIManager.m
//  Weather
//
//  Created by DongMeiliang on 07/11/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLCurrentWeatherAPIManager.h"
#import "DMLOpenWeatherMapService.h"

@interface DMLCurrentWeatherAPIManager ()<CTAPIManagerValidator>

@end

@implementation DMLCurrentWeatherAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.validator = self;
    }
    return self;
}

#pragma mark - CTAPIManager

- (NSString *)methodName
{
    return @"weather";
}

- (NSString *)serviceType
{
    return DMLOpenWeatherMapServiceV2_5;
}

- (CTAPIManagerRequestType)requestType
{
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)shouldCache
{
    return YES;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary *resultParams = params.mutableCopy;
    resultParams[@"APPID"] = [[CTServiceFactory sharedInstance] serviceWithIdentifier:DMLOpenWeatherMapServiceV2_5].publicKey;
    return resultParams;
}

#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    return YES;
}

@end
