//
//  UINavigationControllerObserver.m
//  Places
//
//  Created by Timothy Desir on 5/10/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "UINavigationControllerObserver.h"


static void *UINavigationControllerViewControllers = &UINavigationControllerViewControllers;


@interface UINavigationControllerObserver ()
@property (nullable, nonatomic, strong) UINavigationController *navController;
@end

@implementation UINavigationControllerObserver

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithNavigationController:(UINavigationController *)controller {
    self = [self init];
    if (self) {
        [controller addObserver:self
                     forKeyPath:@"viewControllers"
                        options:(NSKeyValueObservingOptionNew |
                                 NSKeyValueObservingOptionOld)
                        context:UINavigationControllerViewControllers];
    }
    
    return self;
}

+ (UINavigationControllerObserver *)observerWithController:(UINavigationController *)controller {
    UINavigationControllerObserver *observer = [[UINavigationControllerObserver alloc] init];
    observer.navController = controller;
    return observer;
}

#pragma mark - Public Interface

- (void)startObserving {
    if (_navController) {
        
    }
}

- (void)stopObserving {
    
}

#pragma mark - Private Interface

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (context == UINavigationControllerViewControllers) {
        // Do something
        NSLog(@"%s - obj: %@, change: %@, keyPath: %@", __PRETTY_FUNCTION__, object, change, keyPath);
    } else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

@end
