//
//  OKAnimation.h
//  Places
//
//  Created by Timothy Desir on 5/21/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OKAnimation : NSObject

@property (nonatomic) NSUInteger step;
@property (nonatomic, copy) NSString *key;
@property (nonatomic) NSArray<NSString *> *properties;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval preDelay;
@property (nonatomic) NSTimeInterval postDelay;

+ (OKAnimation *)delay:(NSTimeInterval)time;

+ (OKAnimation *)fadeIn:(NSArray<NSString *> *)properties duration:(NSTimeInterval)time delay:(NSTimeInterval)delay postDelay:(NSTimeInterval)pelay;

+ (OKAnimation *)fadeOut:(NSArray<NSString *> *)properties duration:(NSTimeInterval)time delay:(NSTimeInterval)delay postDelay:(NSTimeInterval)pelay;

@end
