//
//  FAStatusBarTray.h
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FASTATUSBAR_ANIMATION_DURATION 0.2

@interface FAStatusBarTray : UIVisualEffectView

- (void)showTrayWithView:(UIView *)view;
- (void)dismissTray;

@end
