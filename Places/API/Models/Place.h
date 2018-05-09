//
//  Place.h
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "PSModel.h"

@class Note;
@class Link;

RLM_ARRAY_TYPE(Note) // define RLMArray<Note>

@interface Place : PSModel

@property NSString *pid;
@property NSString *googlePlaceID;
@property NSString *yelpBusinessID;
@property NSString *source; // "yelp" or "google"

@property NSString *name;
@property NSString *category;
@property NSString *g_categories; // google cats
@property NSString *y_categories; // yelp cats
@property Link *url;
@property Link *yelpURL;
@property NSString *phone;
@property NSNumber<RLMDouble> *rating; // out of 5
@property NSString *hours; // stored as "mo/00:00(A/P)M-00:00(A/P)M,tu/00:00(A/P)M-00:00(A/P)M, ..."
@property RLMArray<Note> *notes;
@property NSNumber<RLMInt> *priceLevel;

@property NSString *fullAddress;
@property NSString *address1;
@property NSString *address2;
@property NSString *address3;
@property NSNumber<RLMFloat> *latitude;
@property NSNumber<RLMFloat> *longitude;
@property NSNumber<RLMInt> *postalCode;
@property NSString *country;
@property NSString *countryCode;
@property NSString *city;
@property NSString *state;
@property NSString *stateCode;
@property NSString *neighborhood;
@property NSString *floor;

@end
