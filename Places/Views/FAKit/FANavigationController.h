//
//  FANavigationController.h
//  Places
//
//  Created by Timothy Desir on 5/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAViewController, FANavBar;

@interface FANavigationController : UIViewController

- (instancetype)initWithRootViewController:(FAViewController *)rootViewController; // Convenience method pushes the root view controller without animation.

- (void)pushViewController:(FAViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

@property(nullable, nonatomic, readonly, strong) FAViewController *topViewController; // The top view controller on the stack.
@property(nullable, nonatomic, readonly, strong) FAViewController *visibleViewController; // Return modal view controller if it exists. Otherwise the top view controller.

@property(nonatomic, copy) NSArray<__kindof FAViewController *> *viewControllers; // The current view controller stack.

- (void)setViewControllers:(NSArray<FAViewController *> *)viewControllers animated:(BOOL)animated NS_AVAILABLE_IOS(3_0); // If animated is YES, then simulate a push or pop depending on whether the new top view controller was previously in the stack.

@property(nonatomic, getter=isNavigationBarHidden) BOOL navigationBarHidden;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated; // Hide or show the navigation bar. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
@property(nonatomic, readonly) FANavBar *navBar; // The navigation bar managed by the controller. Pushing, popping or setting navigation items on a managed navigation bar is not supported.

@end
