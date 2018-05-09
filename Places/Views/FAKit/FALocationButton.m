//
//  FALocationButton.m
//  Places
//
//  Created by Timothy Desir on 4/10/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FALocationButton.h"

// helpers
#import "FAHelpers.h"

@implementation FALocationButton {
    UIActivityIndicatorView *_spinny;
    UIImageView *_iconView;
    UILabel *_name;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 12;
        self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
        self.layer.borderWidth = DIV_HEIGHT;
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Interface

- (void)showActivityIndicator:(BOOL)flag {
    
}

- (void)setTitle:(NSString *)title animated:(BOOL)flag {
    
}

@end
