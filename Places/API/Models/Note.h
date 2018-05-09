//
//  Note.h
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "PSModel.h"

@class Place;

@interface Note : PSModel

@property NSString *nid;

@property NSString *text;
@property Place *place;

@end
