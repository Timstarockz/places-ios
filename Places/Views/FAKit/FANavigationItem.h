//
//  FANavigationItem.h
//  Places
//
//  Created by Timothy Desir on 5/9/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FANavigationItem : NSObject

- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;

@property(nullable, nonatomic, copy)   NSString        *title; // Title when topmost on the stack. default is nil
@property(nullable, nonatomic, strong) UIView          *titleView; // Custom view to use in lieu of a title. May be sized horizontally. Only used when item is topmost on the stack.

@property(nullable, nonatomic, copy)   NSString *prompt __TVOS_PROHIBITED; // Explanatory text to display above the navigation bar buttons.
@property(nullable, nonatomic, strong) UIBarButtonItem *backBarButtonItem __TVOS_PROHIBITED; // Bar button item to use for the back button in the child navigation item.

@property(nonatomic, assign) BOOL hidesBackButton __TVOS_PROHIBITED; // If YES, this navigation item will hide the back button when it's on top of the stack.
- (void)setHidesBackButton:(BOOL)hidesBackButton animated:(BOOL)animated __TVOS_PROHIBITED;

@end
