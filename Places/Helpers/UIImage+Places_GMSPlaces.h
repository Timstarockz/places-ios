//
//  UIImage+Places_GMSPlaces.h
//  Places
//
//  Created by Timothy Desir on 4/5/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Places_GMSPlaces)

+ (UIImage *)possibleIconFromPlaceTypes:(NSArray *)types;
+ (UIImage *)iconFromPlaceType:(NSString *)type;

@end
