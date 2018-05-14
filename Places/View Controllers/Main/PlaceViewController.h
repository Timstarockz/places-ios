//
//  PlaceViewController.h
//  Places
//
//  Created by Timothy Desir on 3/31/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FAViewController.h"

@class Place;

@interface PlaceViewController : FAViewController

- (instancetype)initWithPlace:(Place *)place;
- (instancetype)initWithGooglePlaceInfo:(NSDictionary *)placeInfo;

@property (strong) Place *place;

@end
