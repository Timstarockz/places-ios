//
//  FANavBar.h
//  Places
//
//  Created by Timothy Desir on 4/11/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FANAVBAR_ITEM_SIZE 35

@class FATabBarItem;

@interface FANavBar : UIView

- (void)setTitle:(NSString *)title;
- (void)setCustomView:(UIView *)view;

- (void)setLeftItem:(FATabBarItem *)item;
- (void)setRightItem:(FATabBarItem *)item;
- (void)setShowBackButton:(BOOL)flag;

@property (nonatomic, nullable) UIButton *backButton;

@end
