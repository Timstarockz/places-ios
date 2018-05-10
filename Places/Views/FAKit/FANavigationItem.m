//
//  FANavigationItem.m
//  Places
//
//  Created by Timothy Desir on 5/9/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FANavigationItem.h"

@implementation FANavigationItem

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        _hidesBackButton = false;
    }
    
    return self;
}

#pragma mark - Public Interface

#pragma mark - Private Interface

@end
