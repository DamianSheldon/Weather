//
//  NSTimer+EOCBlocksSupport.m
//  EffectiveObjectiveC
//
//  Created by DongMeiliang on 10/13/16.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "NSTimer+EOCBlocksSupport.h"

@implementation NSTimer (EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(EOCTimerTickHandler)block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(eoc_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)eoc_blockInvoke:(NSTimer *)timer
{
    EOCTimerTickHandler block = timer.userInfo;
    
    if (block) {
        block();
    }
}

@end
