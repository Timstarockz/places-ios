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
        
        //
        // possibly have fade in animations for FANavController?
        //_navigationController.view.userInteractionEnabled = false;
        //_navigationController.view.alpha = 0.0;
        //
        
        _navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [_navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        _navigationController.navigationBar.shadowImage = [UIImage new];
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
        _navBar.item = rootViewController.navItem;
        [_navBar setShowBackButton:!_navBar.item.hidesBackButton];
        [_navBar.backButton addTarget:self action:@selector(_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
        
        //
        [_statusBarTray showTrayWithView:_navBar];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    [super loadView];
    //NSLog(@"%s - %lu", __PRETTY_FUNCTION__, (unsigned long)self.presentationOrigin);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@"%s - %lu", __PRETTY_FUNCTION__, (unsigned long)self.presentationOrigin);
    // Do any additional setup after loading the view.
}

- (void)viewDidPresent:(BOOL)animated {
    [super viewDidPresent:animated];
    NSLog(@"%s - %lu", __PRETTY_FUNCTION__, (unsigned long)self.presentationOrigin);
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

#pragma mark - Private Interface

- (void)_dismissViewController {
    if (self.presentationOrigin == FAViewControllerPresentationOriginPresented) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else if (self.presentationOrigin == FAViewControllerPresentationOriginPushed) {
        [_navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // update the viewControllers array
    __weak NSArray *_vcs = _navigationController.viewControllers;
    _viewControllers = _vcs;
    
    // since the incoming view controller is being pushed, private set the presentation origin
    SEL selector = NSSelectorFromString(@"_setPresentationOrigin:");
    if ([(FAViewController *)viewController respondsToSelector:selector]) {
        if (_navigationController.viewControllers.count < 2) {
            if (self.presentationOrigin == FAViewControllerPresentationOriginPresented) {
                ((void (*)(id, SEL, FAViewControllerPresentationOrigin))[(FAViewController *)viewController methodForSelector:selector])((FAViewController *)viewController, selector, FAViewControllerPresentationOriginPresented);
            } else {
                ((void (*)(id, SEL, FAViewControllerPresentationOrigin))[(FAViewController *)viewController methodForSelector:selector])((FAViewController *)viewController, selector, FAViewControllerPresentationOriginPushed);
            }
        } else {
            ((void (*)(id, SEL, FAViewControllerPresentationOrigin))[(FAViewController *)viewController methodForSelector:selector])((FAViewController *)viewController, selector, FAViewControllerPresentationOriginPushed);
        }
    }
    
    // private set nav controller for incoming view
    __weak FANavigationController *wself = self;
    SEL selectorSetContianer = NSSelectorFromString(@"_setNavigationController:");
    if ([(FAViewController *)viewController respondsToSelector:selectorSetContianer]) {
        ((void (*)(id, SEL, FANavigationController *))[(FAViewController *)viewController methodForSelector:selectorSetContianer])((FAViewController *)viewController, selectorSetContianer, wself);
    }
    
    // if the navigation item wants to show the back button (which it does by default), then private set the appropriate back button image
    if (!_navBar.item.hidesBackButton) {
        SEL selector = NSSelectorFromString(@"_setBackButtonIcon:");
        if (self.presentationOrigin == FAViewControllerPresentationOriginPresented) {
            ((void (*)(id, SEL, UIImage *))[_navBar methodForSelector:selector])(_navBar, selector, [UIImage imageNamed:@"cancel_con"]);
        } else {
            ((void (*)(id, SEL, UIImage *))[_navBar methodForSelector:selector])(_navBar, selector, [UIImage imageNamed:@"back_arrow_con"]);
        }
    }
    
    // if FIRST table view in the stack has the same dimesions as the nav controller view then set the appropriate content inset
    for (UITableView *scrollView in viewController.view.subviews) {
        if (scrollView.frame.size.width == self.view.frame.size.width && scrollView.frame.size.height == self.view.frame.size.height) {
            scrollView.contentInset = UIEdgeInsetsMake(_statusBarTray.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height-DIV_HEIGHT, 0, 0, 0);
            scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_statusBarTray.frame.size.height-[UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
        }
        break;
    }
    
    // let the view controller know that it is about to be presented
    [(FAViewController *)viewController viewWillPresent:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // let the view controller know that it has been fully presented on the screen
    [(FAViewController *)viewController viewDidPresent:animated];
}

@end
