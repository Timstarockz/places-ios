//
//  FAViewController.m
//  Food
//
//  Created by Timothy Desir on 3/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FAViewController.h"
#import "FANavigationController.h"
#import "FANavigationItem.h"

@interface FAViewController (Internal)
- (void)_setContainer:(FAMapContainerViewController *)container;
- (void)_setNavigationController:(FANavigationController *)controller;
- (void)_setPresentationOrigin:(FAViewControllerPresentationOrigin)origin;
@end

@implementation FAViewController

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        // init nav item
        _navItem = [[FANavigationItem alloc] initWithTitle:self.title];
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (UIView *)statusBarAccessoryView {
    return nil;
}

- (FABarItem *)tabBarItem {
    return nil;
}

- (void)viewWillPresent:(BOOL)animated {
    
}

- (void)viewDidPresent:(BOOL)animated {
    
}

#pragma mark - Private

- (void)_setContainer:(FAMapContainerViewController *)container {
    _container = container;
}

- (void)_setNavigationController:(FANavigationController *)controller {
    _navController = controller;
}

- (void)_setPresentationOrigin:(FAViewControllerPresentationOrigin)origin {
    _presentationOrigin = origin;
}

@end
