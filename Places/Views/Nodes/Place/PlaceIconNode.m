//
//  PlaceIconNode.m
//  Places
//
//  Created by Timothy Desir on 4/10/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "PlaceIconNode.h"

@implementation PlaceIconNode

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [[ASLayoutSpec alloc] init];
}

#pragma mark - Actions

#pragma mark - Helpers

@end
