//
//  UIColor+Helpers.h
//  Food
//
//  Created by Timothy Desir on 3/17/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helpers)

+ (UIColor *)colorWithHexString:(NSString *)str;
+ (UIColor *)colorWithHex:(UInt32)col;

+ (UIColor *)colorWithHexString:(NSString *)str alpha:(CGFloat)a;
+ (UIColor *)colorWithHex:(UInt32)col alpha:(CGFloat)a;

@end
