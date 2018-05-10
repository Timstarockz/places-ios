//
//  UINavigationBarInteractivePopGesture.h
//  Places
//
//  Created by Timothy Desir on 4/29/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBarInteractivePopGesture : NSObject <UIGestureRecognizerDelegate>

- (instancetype)initWithNavigationController:(UINavigationController *)controller;

@property (nonatomic, readonly) UINavigationController *navigationController;

@end
