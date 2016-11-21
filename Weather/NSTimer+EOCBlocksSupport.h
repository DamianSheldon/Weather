//
//  NSTimer+EOCBlocksSupport.h
//  EffectiveObjectiveC
//
//  Created by DongMeiliang on 10/13/16.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EOCTimerTickHandler)();

@interface NSTimer (EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(EOCTimerTickHandler)block repeats:(BOOL)repeats;

@end
