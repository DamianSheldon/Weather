//
//  DMLPerThreeHourForecastAPIManager.m
//  Weather
//
//  Created by DongMeiliang on 18/11/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLPerThreeHourForecastAPIManager.h"
#import "DMLOpenWeatherMapService.h"

@interface DMLPerThreeHourForecastAPIManager ()<CTAPIManagerValidator>

@end

@implementation DMLPerThreeHourForecastAPIManager

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
    return @"forecast";
}

- (NSString *)serviceType
{
    return DMLOpenWeatherMapServiceV2_5;
}

- (Class)serviceClass
{
    return [DMLOpenWeatherMapService class];
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
    resultParams[@"APPID"] = [DMLOpenWeatherMapService new].publicKey;
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
