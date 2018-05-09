//
//  FAMapContainerViewController.m
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//


// frameworks
@import GoogleMaps;
@import MapKit;
@import CoreLocation;

// main
#import "FAMapContainerViewController.h"

// views
#import "FAStatusBarTray.h"
#import "FATabbedToolbar.h"
#import "FALocationButton.h"
#import "FAViewController.h"

// helpers
#import "FAHelpers.h"


@interface FAMapContainerViewController () <FATabBarDelegate, MKMapViewDelegate, GMSMapViewDelegate, UINavigationControllerDelegate>
@end

@implementation FAMapContainerViewController {
    FALocationManager *locationManager;
    GMSMapView *mapView;
    UINavigationBarInteractivePopGesture *navigationGesture;
    UINavigationController *navController;
    FAStatusBarTray *tray;
    FATabbedToolbar *toolbar;
    FALocationButton *locationButton;
    NSMutableArray *tabItems;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init google map
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                                longitude:0
                                                                     zoom:1];
        mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        mapView.delegate = self;
        //mapView.settings.myLocationButton = true;
        mapView.myLocationEnabled = true;
        mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:mapView];
        
        // init mapkit map
        //mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        //mapView.delegate = self;
        //mapView.showsPointsOfInterest = false;
        //[self.view addSubview:mapView];
        
        // init nav controller
        navController = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
        navController.delegate = self;
        navController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        navController.view.userInteractionEnabled = false;
        navController.view.alpha = 0.0;
        //
        navController.navigationBar.backgroundColor = [UIColor clearColor];
        [navController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        navController.navigationBar.shadowImage = [UIImage new];
        //navController.navigationBar.alpha = 0.0;
        [navController setNavigationBarHidden:true];
        [self.view addSubview:navController.view];
        
        // init navigation gesture
        navigationGesture = [[UINavigationBarInteractivePopGesture alloc] initWithNavigationController:navController];
        navController.interactivePopGestureRecognizer.delegate = navigationGesture;
        
        // init status bar tray
        tray = [[FAStatusBarTray alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
        tray.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
        [self.view addSubview:tray];
        
        // init toolbar
        toolbar = [[FATabbedToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-FATABBAR_SIZE, self.view.frame.size.width, FATABBAR_SIZE)];
        toolbar.tabBarDelegate = self;
        toolbar.frame = CGRectMake(0, self.view.frame.size.height-FATABBAR_SIZE, self.view.frame.size.width, FATABBAR_SIZE);
        [self.view addSubview:toolbar];
        
        // init location button
        locationButton = [[FALocationButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(TEST_LOCATIONBUTTON_WIDTH/2), toolbar.frame.origin.y-(TEST_LOCATIONBUTTON_HEIGHT+TEST_LOCATIONBUTTON_PADDING), TEST_LOCATIONBUTTON_WIDTH, TEST_LOCATIONBUTTON_HEIGHT)];
        [locationButton addTarget:self action:@selector(mapToCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:locationButton];
        
        // init location manager
        locationManager = [[FALocationManager alloc] init];
        locationManager.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        
        // set map padding
        mapView.padding = UIEdgeInsetsMake(tray.frame.size.height, 0, toolbar.frame.size.height, 0);
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecylce

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tray.frame = CGRectMake(0, 0, self.view.frame.size.width, tray.frame.size.height);
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-toolbar.frame.size.height, self.view.frame.size.width, toolbar.frame.size.height);
    [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->locationButton.frame = CGRectMake((self.view.frame.size.width/2)-(TEST_LOCATIONBUTTON_WIDTH/2), self->toolbar.frame.origin.y-(TEST_LOCATIONBUTTON_HEIGHT+TEST_LOCATIONBUTTON_PADDING), TEST_LOCATIONBUTTON_WIDTH, TEST_LOCATIONBUTTON_HEIGHT);
    } completion:nil];
}

#pragma mark - Public Interface

- (void)setViewControllers:(NSArray <FAViewController *> *)viewControllers {
    _viewControllers = viewControllers;
    
    // Extract the tab bar items from their ViewControllers
    __weak FAMapContainerViewController *wself = self;
    NSMutableArray *tabItems = [NSMutableArray new];
    for (FAViewController *controller in viewControllers) {
        [tabItems insertObject:[controller tabBarItem] atIndex:tabItems.count];
        
        // private set controller
        SEL selector = NSSelectorFromString(@"_setContainer:");
        if ([controller respondsToSelector:selector]) {
            ((void (*)(id, SEL, FAMapContainerViewController *))[controller methodForSelector:selector])(controller, selector, wself);
        }
    }
    // Populate the tab bar
    [toolbar setTabBarItems:tabItems];
}

- (void)showViewControllerAtIndex:(NSInteger)index {
    _topViewController = _viewControllers[index];
    [navController setViewControllers:@[_topViewController] animated:false];
    navController.view.userInteractionEnabled = true;
    
    // animate show view controller and hide location button
    [UIView animateWithDuration:FATT_ANIMATION_DURATION animations:^{
        self->navController.view.alpha = 1.0;
        self->locationButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        self->mapView.padding = UIEdgeInsetsMake(self->tray.frame.size.height, 0, self->toolbar.frame.size.height, 0);
        [self->mapView setHidden:true];
    }];
}

- (void)dismissViewController {
    [tray dismissTray];
    navController.view.userInteractionEnabled = false;
    mapView.padding = UIEdgeInsetsMake(tray.frame.size.height, 0, toolbar.frame.size.height, 0);
    
    [mapView setHidden:false];
    [UIView animateWithDuration:FATT_ANIMATION_DURATION animations:^{
        self->navController.view.alpha = 0.0;
        self->locationButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self->navController popViewControllerAnimated:false];
        [self->navController setViewControllers:@[] animated:false];
        self->_topViewController = nil;
    }];
}

#pragma mark - Methods

- (void)mapToCurrentLocation {
    [self->mapView animateToLocation:CLLocationCoordinate2DMake(mapView.myLocation.coordinate.latitude, mapView.myLocation.coordinate.longitude)];
    [self->mapView animateToZoom:18.5];
    [self->mapView animateToViewingAngle:55];
}

#pragma mark - FATabBarDelegate

- (void)tabBarItem:(FATabBarItem *)item selectedAtIndex:(NSInteger)index {
    [self showViewControllerAtIndex:index];
}

- (void)tabBarDidDeselectItem:(FATabBarItem *)item atIndex:(NSInteger)index {
    [self dismissViewController];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[FAViewController class]]) {
        NSLog(@"%s - Loaded New View Controller", __PRETTY_FUNCTION__);
        FAViewController *vc = (FAViewController *)viewController;
        if (vc == _topViewController) {
            if (_topViewController) {
                [tray showTrayWithView:[_topViewController statusBarAccessoryView]];
                [toolbar setSelectedIndex:[_viewControllers indexOfObject:_topViewController] animated:true];
                [toolbar setRightBarItem:[_topViewController tabBarItem] animated:true];
            }
        } else {
            [tray showTrayWithView:[vc statusBarAccessoryView]];
            [toolbar setSelectedIndex:0 animated:true]; // hardcoded to select the first tab bar item
            if ([vc tabBarItem].rightItem) {
                [toolbar setRightBarItem:[vc tabBarItem] animated:true];
            }
        }
    }
}

#pragma mark - MapKit::MKMapView Delegate

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"%s - Started Loading Map", __PRETTY_FUNCTION__);
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"%s - Finished Loading Map", __PRETTY_FUNCTION__);
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"%s - Failed Loading Map", __PRETTY_FUNCTION__);
}


- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
    NSLog(@"%s - Started Rendering Map", __PRETTY_FUNCTION__);
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    NSLog(@"%s - Finished Rendering Map", __PRETTY_FUNCTION__);
}

#pragma mark - Google Maps Delegate

- (void)mapViewDidStartTileRendering:(GMSMapView *)mapView {
    NSLog(@"%s - Started Rendering Map", __PRETTY_FUNCTION__);
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
    NSLog(@"%s - Finished Rendering Map", __PRETTY_FUNCTION__);
    
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self mapToCurrentLocation];
    });
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"%s - didTapAtCoordinate: (%f, %f)", __PRETTY_FUNCTION__, coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"%s - didLongPress: (%f, %f)", __PRETTY_FUNCTION__, coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(GMSMapView *)mapView didTapPOIWithPlaceID:(NSString *)placeID name:(NSString *)name location:(CLLocationCoordinate2D)location {
    NSLog(@"%s - place_id: %@  |  name: %@  |  location(%f, %f)", __PRETTY_FUNCTION__, placeID, name, location.latitude, location.longitude);
    [[NSNotificationCenter defaultCenter] postNotificationName:FAMAP_POI_TAPPED_NOTIFICATION object:@{@"place_id": placeID, @"name": name, @"latitude": @(location.latitude), @"longitude": @(location.longitude)}];
}

#pragma mark - Core Location Delegate

@end

