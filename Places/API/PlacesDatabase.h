//
//  PlacesDatabase.h
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "Place.h"
#import "List.h"
#import "Note.h"
#import "Link.h"

@class YLPBusiness;
@class GMSPlace;

@interface PlacesDatabase : NSObject

@property (strong, readonly) RLMRealm *realm;

+ (PlacesDatabase *)shared;

+ (Place *)placeFromYelpModel:(YLPBusiness *)business;
+ (Place *)placeFromGooglePlaceModel:(GMSPlace *)gplace;

- (void)savePlace:(Place *)model;
- (void)unsavePlace:(Place *)model;

- (RLMResults<Place *> *)savedPlaces;

@end
