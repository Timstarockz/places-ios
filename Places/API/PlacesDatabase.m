//
//  PlacesDatabase.m
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PlacesDatabase.h"

// models
#import "Place.h"
#import "List.h"
#import "Note.h"
#import "Link.h"

// frameworks
#import "YelpAPI.h"
#import <GooglePlaces/GooglePlaces.h>

@implementation PlacesDatabase

#pragma mark - Initialization

+ (PlacesDatabase *)shared {
    static PlacesDatabase *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PlacesDatabase alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        // init realm
        _realm = [RLMRealm defaultRealm];
    }
    
    return self;
}

#pragma mark - Model2Model

+ (Place *)placeFromYelpModel:(YLPBusiness *)business {
    Place *place = [[Place alloc] init];
    if (business) {
        place.pid = [[NSUUID UUID] UUIDString];
        place.saved = [NSNumber numberWithBool:false];
        place.refCreated = [NSDate new];
        place.source = @"yelp";
        place.yelpBusinessID = business.identifier;
        
        place.name = business.name;
        place.phone = business.phone;
        place.rating = [NSNumber numberWithDouble:business.rating];
        place.priceLevel = [NSNumber numberWithInteger:business.price.length];
        
        Link *yelpURL = [[Link alloc] init];
        yelpURL.lid = [[NSUUID UUID] UUIDString];
        yelpURL.string = business.URL.absoluteString;
        place.yelpURL = yelpURL;
        
        NSMutableArray *cats = [NSMutableArray new];
        for (YLPCategory *cat in business.categories) {
            [cats addObject:cat.name];
        }
        place.y_categories = [cats componentsJoinedByString:@","];
        
        place.latitude = [NSNumber numberWithFloat:business.location.coordinate.latitude];
        place.longitude = [NSNumber numberWithFloat:business.location.coordinate.longitude];
        if (business.location.address.count > 0) {
            place.address1 = business.location.address[0];
        }
        if (business.location.address.count > 1) {
            place.address2 = business.location.address[1];
        }
        if (business.location.address.count > 2) {
            place.address3 = business.location.address[2];
        }
        
        place.countryCode = business.location.countryCode;
        place.city = business.location.city;
        place.stateCode = business.location.stateCode;
    }
    
    return place;
}

+ (Place *)placeFromGooglePlaceModel:(GMSPlace *)gplace {
    Place *place = [[Place alloc] init];
    if (gplace) {
        place.pid = [[NSUUID UUID] UUIDString];
        place.saved = [NSNumber numberWithBool:false];
        place.refCreated = [NSDate new];
        place.source = @"google";
        place.yelpBusinessID = gplace.placeID;
        
        place.name = gplace.name;
        place.phone = gplace.phoneNumber;
        place.rating = [NSNumber numberWithFloat:gplace.rating];
        place.priceLevel = [NSNumber numberWithInteger:gplace.priceLevel];
        
        Link *url = [[Link alloc] init];
        url.lid = [[NSUUID UUID] UUIDString];
        url.string = gplace.website.absoluteString;
        place.url = url;
        
        place.g_categories = [gplace.types componentsJoinedByString:@","];
        
        place.latitude = [NSNumber numberWithFloat:gplace.coordinate.latitude];
        place.longitude = [NSNumber numberWithFloat:gplace.coordinate.longitude];
        place.fullAddress = gplace.formattedAddress;
        for (GMSAddressComponent *adcomp in gplace.addressComponents) {
            if ([adcomp.type isEqualToString:@"neighborhood"]) {
                place.neighborhood = adcomp.name;
            } else if ([adcomp.type isEqualToString:@"country"]) {
                place.country = adcomp.name;
            } else if ([adcomp.type isEqualToString:@"floor"]) {
                place.floor = adcomp.name;
            } else if ([adcomp.type isEqualToString:@"street_address"]) {
                place.address1 = adcomp.name;
            } else if ([adcomp.type isEqualToString:@"floor"]) {
                place.floor = adcomp.name;
            }
        }
    }
    
    return place;
}

#pragma mark - Interface

- (void)savePlace:(Place *)model {
    [_realm beginWriteTransaction];
    model.savedAt = [NSDate new];
    model.saved = [NSNumber numberWithBool:true];
    [_realm addObject:model];
    [_realm commitWriteTransaction];
}

- (void)unsavePlace:(Place *)model {
    [_realm beginWriteTransaction];
    RLMResults *saved = [Place objectsWhere:[NSString stringWithFormat:@"name == '%@'", model.name]];
    [_realm deleteObjects:saved];
    [_realm commitWriteTransaction];
}

- (RLMResults<Place *> *)savedPlaces {
    RLMResults *saved = [Place allObjects];
    return [saved objectsWhere:@"saved = 1"];
}

@end
