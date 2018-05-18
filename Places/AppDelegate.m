//
//  AppDelegate.m
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "AppDelegate.h"

// frameworks
#import "OKOnboardingKit.h"
#import "FAKit.h"
#import <SafariServices/SafariServices.h>

// view controllers
#import "FindViewController.h"
#import "FavoritesViewController.h"
#import "ListsViewController.h"
#import "PlaceViewController.h"

@import InstagramKit;
@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()
@property (strong, nonatomic) PlacesDatabase *database;
@property (strong, nonatomic) YLPClient *client;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // init services
    [self runRealmMigration];
    _database = [[PlacesDatabase alloc] init];
    [GMSServices provideAPIKey:@"AIzaSyCjbSGLQPKwHa4ZBjxGCrhsbODDqWrDB_Q"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyChY9n4m0Zem_Ux5QA89GXvv87Dl2F5VtM"]; // AIzaSyAmok44wmyNWXxUbttaMc_2dELhN5ZoEj4
    [InstagramEngine sharedEngine].accessToken = @"180117265.1677ed0.7b1bc8469442415f918dd574ea3231eb";
    _client = [[YLPClient alloc] initWithAPIKey:@"rEHGZiKnzX45CIMloYggKGOm5O0hdN9QsjulLXLhNYuM4va1uIEocoPOLW3BPc5s3IDDggQ5oP00osgcqQrtWmANnTdjIbo2oGS_2iwkMw6OgEUC4GgTloaCJMDXWnYx"];
    
    // init map view poi notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openURLInSFVC:) name:OPEN_URL_SFSAFARIVIEWCONTROLLER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointOfInterestTapped:) name:FAMAP_POI_TAPPED_NOTIFICATION object:nil];
    
    // init window and controller
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.clipsToBounds = true;
    self.window.layer.cornerRadius = 12;
    self.controller = [[FAMapContainerViewController alloc] initWithNibName:nil bundle:nil];
    [self setupViewControllers];
    //
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.controller;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    self.window.layer.cornerRadius = 12;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    //NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    self.window.layer.cornerRadius = 12;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Interface

- (void)setupViewControllers {
    FindViewController *search = [[FindViewController alloc] initWithNibName:nil bundle:nil];
    FavoritesViewController *favorites = [[FavoritesViewController alloc] initWithNibName:nil bundle:nil];
    ListsViewController *lists = [[ListsViewController alloc] initWithNibName:nil bundle:nil];
    //
    [self.controller setViewControllers:@[search, favorites, lists]];
}

- (void)openURLInSFVC:(NSNotification *)noti {
    NSDictionary *urlInfo = noti.object;
    if (urlInfo[@"url"]) {
        SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlInfo[@"url"]]];
        [self.controller presentViewController:safari animated:true completion:nil];
    }
}

- (void)pointOfInterestTapped:(NSNotification *)noti {
    NSDictionary *poiDesc = noti.object;
    NSLog(@"%@", poiDesc);
    PlaceViewController *place = [[PlaceViewController alloc] initWithGooglePlaceInfo:poiDesc];
    [self.controller showViewControllerAtIndex:0];
    [self.controller.topViewController.navigationController pushViewController:place animated:false];
}

+ (PlacesDatabase *)database {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.database;
}

+ (YLPClient *)yelpClient {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.client;
}

- (void)runRealmMigration {
    //RLMSchema *schema = [RLMRealm defaultRealm].schema;
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        if (oldSchemaVersion < 1) {
            // The enumerateObjects:block: method iterates
            // over every 'Place' object stored in the Realm file
            [migration enumerateObjects:Place.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                // combine name fields into a single field
                newObject[@"pid"] = oldObject[@"pid"];
            }];
            [migration enumerateObjects:Link.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                // combine name fields into a single field
                newObject[@"lid"] = oldObject[@"lid"];
            }];
            [migration enumerateObjects:List.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                // combine name fields into a single field
                newObject[@"lid"] = oldObject[@"lid"];
            }];
            [migration enumerateObjects:Note.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                // combine name fields into a single field
                newObject[@"nid"] = oldObject[@"nid"];
            }];
            [migration enumerateObjects:Place.className block:^(RLMObject *oldObject, RLMObject *newObject) {
                // combine name fields into a single field
                newObject[@"phone"] = oldObject[@"phone"];
            }];
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

@end
