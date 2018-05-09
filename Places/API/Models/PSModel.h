//
//  PSModel.h
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <Realm/Realm.h>

@interface PSModel : RLMObject

@property NSNumber<RLMInt> *views;
@property NSDate *lastViewed;
@property NSDate *savedAt;

@property NSNumber<RLMBool> *saved;

@property NSDate *refCreated;

@end

RLM_ARRAY_TYPE(PSModel) // define RLMArray<PSModel>
