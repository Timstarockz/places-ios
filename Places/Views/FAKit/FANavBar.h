//
//  FANavBar.h
//  Places
//
//  Created by Timothy Desir on 4/11/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FANavigationItem.h"

#define FANAVBAR_ITEM_SIZE 35

@class FABarItem;

@interface FANavBar : UIView

- (void)setTitle:(NSString *)title;
- (void)setCustomView:(UIView *)view;

- (void)setLeftItem:(FABarItem *)item;
- (void)setRightItem:(FABarItem *)item;
- (void)setShowBackButton:(BOOL)flag;

@property (nonatomic, nullable) UIButton *backButton;

@property (nullable, nonatomic, strong) FANavigationItem *item;

@end
