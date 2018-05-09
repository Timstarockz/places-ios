//
//  FANavigationController.m
//  Places
//
//  Created by Timothy Desir on 5/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FANavigationController.h"
#import "FAViewController.h"
#import "FAStatusBarTray.h"
#import "FANavBar.h"

// helpers
#import "FAHelpers.h"

@interface FANavigationController () <UINavigationControllerDelegate>

@end

@implementation FANavigationController {
    FAStatusBarTray *_statusBarTray;
    UINavigationController *_navigationController;
    UINavigationBarInteractivePopGesture *_navigationGesture;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (instancetype)initWithRootViewController:(FAViewController *)rootViewController {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        // init nav controller
        _navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        _navigationController.delegate = self;
        _navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        // possibly have fade in animations for FANavController?
        //_navigationController.view.userInteractionEnabled = false;
        //_navigationController.view.alpha = 0.0;
        //
        _navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [_navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        _navigationController.navigationBar.shadowImage = [UIImage new];
        //navController.navigationBar.alpha = 0.0;
        [_navigationController setNavigationBarHidden:true];
        [self.view addSubview:_navigationController.view];
        
        // init navigation gesture
        _navigationGesture = [[UINavigationBarInteractivePopGesture alloc] initWithNavigationController:_navigationController];
        _navigationController.interactivePopGestureRecognizer.delegate = _navigationGesture;
        
        // init status bar tray
        _statusBarTray = [[FAStatusBarTray alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
        _statusBarTray.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
        [self.view addSubview:_statusBarTray];
        
        // init nav bar
        _navBar = [[FANavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
        //[_navBar setShowBackButton:true];
        [_navBar setTitle:rootViewController.title];
        //[_navBar.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        //
        [_statusBarTray showTrayWithView:_navBar];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Interface

- (void)pushViewController:(FAViewController *)viewController animated:(BOOL)animated {
    [_navigationController pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<FAViewController *> *)viewControllers animated:(BOOL)animated {
    [_navigationController setViewControllers:viewControllers animated:animated];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    for (UITableView *scrollView in viewController.view.subviews) {
        if (scrollView.frame.size.width == self.view.frame.size.width && scrollView.frame.size.height == self.view.frame.size.height) {
            scrollView.contentInset = UIEdgeInsetsMake(_statusBarTray.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-DIV_HEIGHT, 0, 0, 0);
            scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_statusBarTray.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
        }
        break;
    }
}

@end
