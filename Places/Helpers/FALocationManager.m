//
//  FALocationManager.m
//  Places
//
//  Created by Timothy Desir on 4/2/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FALocationManager.h"

#define DEFAULT_FALOCATION_DISTANCE_FILTER 28

@implementation FALocationManager {
    FALocationTypes _currentAction;
    FALocationTypes _locationType;
    FALocationRequestBlock _requestBlock;
    FALocationAuthBlock _authorizationBlock;
    CLAuthorizationStatus _authStatus;
    
    double _distanceFilter;
    NSError *_error;
    
    NSSet *validActions;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _active = false;
        _authorized = false;
        validActions = [NSSet setWithObjects:@(FALocationRetrieveLocation), @(FALocationMoniterLocation), nil];

        // init location manager
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    
    return self;
}

#pragma mark - Public Interface

- (void)enableLocationServices:(FALocationTypes)type callback:(FALocationAuthBlock)block; {
    if ([CLLocationManager locationServicesEnabled]) {
        _active = true;
        _authorizationBlock = block;
        
        if (_authStatus == kCLAuthorizationStatusNotDetermined) {
            if (type == FALocationAuthorizationAlways) {
                [_manager requestAlwaysAuthorization];
            } else if (type == FALocationAuthorizationWhenInUse) {
                [_manager requestWhenInUseAuthorization];
            } else {
                [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
            }
        } else {
            if (_authStatus == kCLAuthorizationStatusAuthorizedAlways) {
                [self _fireAuthorizationBlock:FALocationAuthorizationAlways];
            } else if (_authStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
                [self _fireAuthorizationBlock:FALocationAuthorizationWhenInUse];
            } else {
                [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
            }
        }
    } else {
        [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
    }
}

- (void)locationRequest:(FALocationTypes)type callback:(FALocationRequestBlock)block {
    [self locationRequest:type withDistanceFilter:DEFAULT_FALOCATION_DISTANCE_FILTER callback:block];
}

- (void)locationRequest:(FALocationTypes)type withDistanceFilter:(double)distance callback:(FALocationRequestBlock)block {
    if (_authorized) {
        _active = true;
        if ([validActions containsObject:@(type)]) {
            _currentAction = type;
        }
        _requestBlock = block;
        _manager.distanceFilter = distance;
        [_manager startUpdatingLocation];
    } else {
        // handle location services disabled
        [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
    }
}

- (void)stopMoniteringUpdates {
    if (_active && _currentLocation) {
        [_manager stopUpdatingLocation];
        [self _fireLocationRequestBlock:FALocationRequestStopped location:_currentLocation deactivate:true];
    }
}

#pragma mark - Private Interface

- (void)_fireAuthorizationBlock:(FALocationTypes)type {
    _active = false;
    if (_authStatus == kCLAuthorizationStatusDenied ||
        _authStatus == kCLAuthorizationStatusRestricted ||
        _authStatus == kCLAuthorizationStatusNotDetermined) {
        _currentLocation = nil;
    } else {
        _authorized = true;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_authorizationBlock) {
            self->_authorizationBlock(type, self->_authStatus, self->_error);
        }
    });
}

- (void)_fireLocationRequestBlock:(FALocationTypes)type location:(CLLocation *)loc deactivate:(BOOL)flag {
    _active = !flag;
    if (_authStatus == kCLAuthorizationStatusDenied ||
        _authStatus == kCLAuthorizationStatusRestricted ||
        _authStatus == kCLAuthorizationStatusNotDetermined) {
        _currentLocation = nil;
    } else {
        _authorized = true;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_requestBlock) {
            self->_requestBlock(type, loc, self->_error);
        }
    });
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    _authStatus = status;
    if (_active) {
        if (status == kCLAuthorizationStatusDenied) {
            [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
        } else if (status == kCLAuthorizationStatusRestricted) {
            [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
        } else if (status == kCLAuthorizationStatusNotDetermined) {
            [self _fireAuthorizationBlock:FALocationAuthorizationBlocked];
        } else if (status == kCLAuthorizationStatusAuthorizedAlways) {
            if (!_authorized) {
                [self _fireAuthorizationBlock:FALocationAuthorizationAlways];
            }
        } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            if (!_authorized) {
                [self _fireAuthorizationBlock:FALocationAuthorizationWhenInUse];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (_active && _authorized) {
        _currentLocation = locations.lastObject;
        if (_currentLocation && _currentAction) {
            if (_currentAction == FALocationRetrieveLocation) {
                [self _fireLocationRequestBlock:FALocationRequestSuccess location:_currentLocation deactivate:true];
                [_manager stopUpdatingLocation];
            } else if (_currentAction == FALocationMoniterLocation) {
                [self _fireLocationRequestBlock:FALocationRequestSuccess location:_currentLocation deactivate:false];
            }
        }
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    _active = false;
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    _active = true;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [_manager stopUpdatingLocation];
    _error = error;
    _active = false;
}

@end
