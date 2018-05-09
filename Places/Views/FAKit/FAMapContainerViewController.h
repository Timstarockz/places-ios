//
//  FAMapContainerViewController.h
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FAMAP_POI_TAPPED_NOTIFICATION @"fa_mapview_didTapPOI"

@class FAViewController;

@interface FAMapContainerViewController : UIViewController

- (void)setViewControllers:(NSArray <FAViewController *> *)viewControllers;

@property (nonatomic, readonly) NSArray <FAViewController *> *viewControllers;

@property (nonatomic, readonly, weak) FAViewController *topViewController;

- (void)showViewControllerAtIndex:(NSInteger)index;
- (void)dismissViewController;

@end
