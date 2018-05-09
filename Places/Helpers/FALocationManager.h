//
//  FALocationManager.h
//  Places
//
//  Created by Timothy Desir on 4/2/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSUInteger, FALocationTypes) {
    // Authorization States
    FALocationAuthorizationAlways,
    FALocationAuthorizationWhenInUse,
    FALocationAuthorizationBlocked,
    
    // Request States
    FALocationRequestSuccess,
    FALocationRequestStopped,
    FALocationRequestFailed,
    
    // Actions
    FALocationRetrieveLocation,
    FALocationMoniterLocation,
};


typedef void(^FALocationAuthBlock)(FALocationTypes atype, CLAuthorizationStatus status, NSError *error);
typedef void(^FALocationRequestBlock)(FALocationTypes rtype, CLLocation *location, NSError *error);


@interface FALocationManager : NSObject <CLLocationManagerDelegate>

- (void)enableLocationServices:(FALocationTypes)type callback:(FALocationAuthBlock)block; // calls back on main thread

- (void)locationRequest:(FALocationTypes)type callback:(FALocationRequestBlock)block; // calls back on main thread -v
- (void)locationRequest:(FALocationTypes)type withDistanceFilter:(double)distance callback:(FALocationRequestBlock)block;

- (void)stopMoniteringUpdates;

@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic) CLLocationManager *manager;

@property (nonatomic, readonly) BOOL active; // if the manager is currently updating / or trying to update location data
@property (nonatomic, readonly) BOOL authorized; // if the manager is already authorized to receive some kind of location updates

@end
