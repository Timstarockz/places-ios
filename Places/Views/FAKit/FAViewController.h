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

typedef NS_ENUM(NSUInteger, FAViewControllerPresentationOrigin) {
    FAViewControllerPresentationOriginPushed = 1,
    FAViewControllerPresentationOriginPresented = 2,
};

@interface FAViewController : UIViewController

@property (nonatomic, readonly) FAViewControllerPresentationOrigin presentationOrigin;

@property (nullable, nonatomic, readonly, strong) FAMapContainerViewController *container; // If this view controller has been pushed onto a container controller, return it.

- (UIView *)statusBarAccessoryView;
- (FABarItem *)tabBarItem;

- (void)viewDidPresent:(BOOL)animated;

@end
