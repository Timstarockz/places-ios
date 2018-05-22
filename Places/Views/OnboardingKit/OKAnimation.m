//
//  OKAnimation.m
//  Places
//
//  Created by Timothy Desir on 5/21/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "OKAnimation.h"

@implementation OKAnimation

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Public Interface

+ (OKAnimation *)delay:(NSTimeInterval)time {
    OKAnimation *ani = [[OKAnimation alloc] init];
    ani.key = @"delay";
    ani.duration = 0.0;
    ani.preDelay = time;
    ani.postDelay = 0.0;
    ani.properties = @[];
    return ani;
}

+ (OKAnimation *)fadeIn:(NSArray<NSString *> *)properties duration:(NSTimeInterval)time delay:(NSTimeInterval)delay postDelay:(NSTimeInterval)pelay {
    OKAnimation *ani = [[OKAnimation alloc] init];
    ani.key = @"fadeIn";
    ani.duration = time;
    ani.preDelay = delay;
    ani.postDelay = pelay;
    ani.properties = properties;
    return ani;
}

+ (OKAnimation *)fadeOut:(NSArray<NSString *> *)properties duration:(NSTimeInterval)time delay:(NSTimeInterval)delay postDelay:(NSTimeInterval)pelay {
    OKAnimation *ani = [[OKAnimation alloc] init];
    ani.key = @"fadeOut";
    ani.duration = time;
    ani.preDelay = delay;
    ani.postDelay = pelay;
    ani.properties = properties;
    return ani;
}

@end
