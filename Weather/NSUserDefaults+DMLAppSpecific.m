//
//  NSUserDefaults+DMLAppSpecific.m
//  Weather
//
//  Created by DongMeiliang on 08/11/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "NSUserDefaults+DMLAppSpecific.h"

static NSString *const sLastWeatherUpdateTimeKey = @"lastWeatherUpdateTime";

@implementation NSUserDefaults (DMLAppSpecific)

- (NSDate *)lastWeatherUpdateTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:sLastWeatherUpdateTimeKey];
}

- (void)setLastWeatherUpdateTime:(NSDate *)lastWeatherUpdateTime
{
    if (lastWeatherUpdateTime) {
        [[NSUserDefaults standardUserDefaults] setObject:lastWeatherUpdateTime forKey:sLastWeatherUpdateTimeKey];
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:sLastWeatherUpdateTimeKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
