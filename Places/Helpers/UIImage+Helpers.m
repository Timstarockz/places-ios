//
//  UIImage+Helpers.m
//  Places
//
//  Created by Timothy Desir on 5/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

- (UIImage *)imageWithSize:(CGSize)newSize {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize];
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext*_Nonnull myContext) {
        [self drawInRect:(CGRect) {.origin = CGPointZero, .size = newSize}];
    }];
    return image;
}

@end
