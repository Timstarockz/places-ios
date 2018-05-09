//
//  AppDelegate.h
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlacesDatabase.h"
#import "YelpAPI.h"

#define OPEN_URL_SFSAFARIVIEWCONTROLLER @"open_url_sfsafariviewcontroller"

@class FAMapContainerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FAMapContainerViewController *controller;

+ (PlacesDatabase *)database;
+ (YLPClient *)yelpClient;

@end

