//
//  List.h
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "PSModel.h"

@class Place;

RLM_ARRAY_TYPE(Place) // define RLMArray<Place>

@interface List : PSModel

@property NSString *lid;

@property NSString *name;
@property RLMArray<Place> *places;

@end
