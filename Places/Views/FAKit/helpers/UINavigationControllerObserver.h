//
//  UINavigationControllerObserver.h
//  Places
//
//  Created by Timothy Desir on 5/10/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UINavigationControllerObserverDelegate;

@interface UINavigationControllerObserver : NSObject

- (instancetype)initWithNavigationController:(UINavigationController *)controller;
+ (UINavigationControllerObserver *)observerWithController:(UINavigationController *)controller;

- (void)startObserving;
- (void)stopObserving;

@property (nonatomic) id<UINavigationControllerObserverDelegate> delegate;

@end

@protocol UINavigationControllerObserverDelegate <NSObject>
@optional

- (void)navigationController:(UINavigationController *)navigationController willPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)navigationController didPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)navigationController:(UINavigationController *)navigationController willPopViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(UINavigationController *)navigationController didPopViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
