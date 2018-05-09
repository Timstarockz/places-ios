//
//  UINavigationBarInteractivePopGesture.m
//  Places
//
//  Created by Timothy Desir on 4/29/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "UINavigationBarInteractivePopGesture.h"

@implementation UINavigationBarInteractivePopGesture

- (instancetype)initWithNavigationController:(UINavigationController *)controller {
    self = [super init];
    if (self) {
        _navigationController = controller;
    }
    
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return _navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

@end
