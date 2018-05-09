//
//  UIColor+Helpers.m
//  Food
//
//  Created by Timothy Desir on 3/17/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

// takes @"#123456"
+ (UIColor *)colorWithHexString:(NSString *)str {
    return [self colorWithHexString:str alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)str alpha:(CGFloat)a {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:(UInt32)x alpha:a];
}

// takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)col {
    return [self colorWithHex:col alpha:1.0];
}

+ (UIColor *)colorWithHex:(UInt32)col alpha:(CGFloat)a {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a];
}

@end
