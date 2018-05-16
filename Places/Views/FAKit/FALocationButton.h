//
//  FALocationButton.h
//  Places
//
//  Created by Timothy Desir on 4/10/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>

// views
#import "FAVisualEffectButton.h"

#define TEST_LOCATIONBUTTON_WIDTH 100
#define TEST_LOCATIONBUTTON_HEIGHT 30
#define TEST_LOCATIONBUTTON_PADDING 12

@interface FALocationButton : FAVisualEffectButton

- (void)showActivityIndicator:(BOOL)flag;
- (void)setTitle:(NSString *)title animated:(BOOL)flag;

@end
