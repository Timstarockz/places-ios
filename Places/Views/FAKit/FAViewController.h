//
//  FAViewController.h
//  Food
//
//  Created by Timothy Desir on 3/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FATabbedToolbar.h"

#import "FAMapContainerViewController.h"
#import "FANavigationController.h"

@interface FAViewController : UIViewController

@property(nullable, nonatomic, strong) FAMapContainerViewController *container; // If this view controller has been pushed onto a container controller, return it.
@property(nullable, nonatomic, strong) FANavigationController *navController; // If this view controller has been pushed onto a navigation controller, return it.

- (UIView *)statusBarAccessoryView;
- (FATabBarItem *)tabBarItem;

@end
