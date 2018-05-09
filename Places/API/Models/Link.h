//
//  Link.h
//  Places
//
//  Created by Timothy Desir on 5/4/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "PSModel.h"

@interface Link : PSModel

@property NSString *lid;

@property NSString *string;

@end

RLM_ARRAY_TYPE(Link) // define RLMArray<Link>
