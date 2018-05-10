//
//  SearchViewController.m
//  Food
//
//  Created by Timothy Desir on 3/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "SearchViewController.h"

// view controllers
#import "PlaceViewController.h"

// views
#import "TableHeader.h"
#import "BubbleScrollerNode.h"
#import "PlaceNode.h"

// frameworks
#import "FAKit.h"
#import <CoreLocation/CoreLocation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <GooglePlaces/GooglePlaces.h>

// helpers
#import "AppDelegate.h"
#import "FAHelpers.h"


@interface SearchViewController () <FASearchBarDelegate, ASTableDelegate, ASTableDataSource, ASCommonTableViewDelegate, BubbleScrollerNodeDelegate, CLLocationManagerDelegate>

@end

@implementation SearchViewController {
    FASearchBar *searchBar;
    ASTableNode *searchNode;
    
    FALocationManager *locationManager;
    GMSPlacesClient *placesClient;
    NSArray *nearbyPlaces;
    NSArray *nearbyBusinesses;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init search bar
        searchBar = [[FASearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 58)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Find places around you";
        
        // init search table node
        searchNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        searchNode.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        searchNode.delegate = self;
        searchNode.dataSource = self;
        searchNode.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        searchNode.contentInset = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP-0.5 , 0, FATOOLBAR_HEIGHT, 0);
        searchNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP, 0, FATOOLBAR_HEIGHT, 0);
        [self.view addSubnode:searchNode];
        
        // init location manager
        locationManager = [[FALocationManager alloc] init];
        locationManager.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }
    
    return self;
}

- (UIView *)statusBarAccessoryView {
    return searchBar;
}

- (FABarItem *)tabBarItem {
    FABarItem *root = [[FABarItem alloc] init];
    root.title = @"Find Places";
    root.icon = [UIImage imageNamed:@"search_con2"];
    root.backgroundColor = PLACEHOLDER_LIGHT_BLUE;//@"#91e467"];
    
    FABarItem *mapButton = [[FABarItem alloc] init];
    mapButton.title = @"Toggle Map View";
    mapButton.icon = [UIImage imageNamed:@"map_con3"];
    mapButton.backgroundColor = [UIColor darkGrayColor];
    root.rightItem = mapButton;
    
    return root;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"Find";
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // enable location services
    [locationManager enableLocationServices:FALocationAuthorizationWhenInUse callback:^(FALocationTypes type, CLAuthorizationStatus status, NSError *error) {
        if (type == (FALocationAuthorizationAlways || FALocationAuthorizationWhenInUse)) {
            
            // moniter location. the block will be fired until instructed to stop monitering
            [self->locationManager locationRequest:FALocationMoniterLocation withDistanceFilter:28 callback:^(FALocationTypes rtype, CLLocation *location, NSError *error) {
                if (rtype == FALocationRequestSuccess) {
                    NSLog(@"%s - Monitering: Retrieved Location: %@", __PRETTY_FUNCTION__, location.description);
                    [self getNearbyPlaces];
                } else if (rtype == FALocationRequestFailed) {
                    NSLog(@"%s - Monitering: Failed Retrieved Location: %@", __PRETTY_FUNCTION__, location.description);
                }
            }];
            
        } else if (type == FALocationAuthorizationBlocked) {
            NSLog(@"%s - Location Services Blocked", __PRETTY_FUNCTION__);
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [locationManager stopMoniteringUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface

- (void)getNearbyPlaces {
    
    [[AppDelegate yelpClient] searchWithCoordinate:[[YLPCoordinate alloc] initWithLatitude:locationManager.currentLocation.coordinate.latitude longitude:locationManager.currentLocation.coordinate.longitude] term:nil limit:20 offset:0 sort:YLPSortTypeDistance completionHandler:^(YLPSearch * _Nullable search, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                self->nearbyBusinesses = search.businesses;
                [self->searchNode performBatchUpdates:^{
                    [self->searchNode reloadData];
                } completion:nil];
            } else {
                
            }
        });
    }];
    
    /*
    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
        if (!error) {
            if (likelihoodList) {
                self->nearbyPlaces = likelihoodList.likelihoods;
            }
        } else {
            NSLog(@"%s - %@", __PRETTY_FUNCTION__, error.description);
        }
        
        [self->searchNode performBatchUpdates:^{
            [self->searchNode reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        } completion:nil];
    }];*/
}

- (void)searchForPlaces:(NSString *)place {
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterEstablishment;
    [[GMSPlacesClient sharedClient] autocompleteQuery:place bounds:nil boundsMode:kGMSAutocompleteBoundsModeBias filter:filter callback:^(NSArray<GMSAutocompletePrediction *> * _Nullable results, NSError * _Nullable error) {
        //
    }];
}

#pragma mark - FASearchBarDelegate

- (void)searchBarDidBeginEditing:(FASearchBar *)searchBar {
    
}

- (void)searchBarDidEndEditing:(FASearchBar *)searchBar {
    
}


- (void)searchBarDidChangeCharacters:(FASearchBar *)searchBar {
    
}


- (void)searchBarDidReturn:(FASearchBar *)searchBar {
    
}

#pragma mark - ASTableNodeDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 2;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    /// 0: Suggestions
    if (section == 0) {
        return 1;
        
    /// 1: Places
    } else if (section == 1) {
        return (nearbyBusinesses) ? nearbyBusinesses.count : 0;
    } else {
        return 0;
    }
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    /// 0: Suggestions
    if (indexPath.section == 0) {
        ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
            BubbleScrollerNode *cell = [[BubbleScrollerNode alloc] init];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setItems:@[[BubbleItem itemWithTitle:@"Breakfast" andIcon:[UIImage imageNamed:@"breakfast2_placecon"] andColor:PLACEHOLDER_GOLD],
                             [BubbleItem itemWithTitle:@"Cafe" andIcon:[UIImage imageNamed:@"cafe_placecon"] andColor:PLACEHOLDER_LIGHT_GREEN],
                             [BubbleItem itemWithTitle:@"Bus Stops" andIcon:[UIImage imageNamed:@"transit_placecon"] andColor:PLACEHOLDER_BLUE_FADE],
                             [BubbleItem itemWithTitle:@"Hotels" andIcon:[UIImage imageNamed:@"hotel_placecon"] andColor:PLACEHOLDER_LIGHT_GREEN],
                             [BubbleItem itemWithTitle:@"Breakfast" andIcon:[UIImage imageNamed:@"breakfast2_placecon"] andColor:PLACEHOLDER_ORANGE],
                             [BubbleItem itemWithTitle:@"Parking" andIcon:[UIImage imageNamed:@"parking_placecon"] andColor:PLACEHOLDER_BLUE_FADE],
                             [BubbleItem itemWithTitle:@"Breakfast" andIcon:[UIImage imageNamed:@"breakfast2_placecon"] andColor:PLACEHOLDER_LIGHT_GREEN],
                             [BubbleItem itemWithTitle:@"Cafe" andIcon:[UIImage imageNamed:@"cafe2_placecon"] andColor:PLACEHOLDER_ORANGE],
                             [BubbleItem itemWithTitle:@"Add New" andIcon:[UIImage imageNamed:@"add_con"] andColor:[UIColor darkGrayColor]]]];
            return cell;
        };
        return cellNodeBlock;
    }
    
    /// 1: Places
    if (indexPath.section == 1) {
        /*
        if (nearbyPlaces) {
            GMSPlaceLikelihood *pl = [nearbyPlaces objectAtIndex:indexPath.row];
            NSString *type = [[(NSString *)[pl.place.types firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
            CLLocation *to = [[CLLocation alloc] initWithLatitude:pl.place.coordinate.latitude longitude:pl.place.coordinate.longitude];
            CLLocationDistance distance = [to distanceFromLocation:locationManager.currentLocation];
            NSString *address = [pl.place.formattedAddress componentsSeparatedByString:@","][0];
            NSLog(@"%s - %@", __PRETTY_FUNCTION__, pl.place.attributions);
            
            ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                PlaceNode *cell = [[PlaceNode alloc] init];
                [cell setTitle:pl.place.name];
                [cell setSubtitle:[NSString stringWithFormat:@"%@ • %dft", type, @((distance/0.3048)).intValue]];
                [cell setFooter:address];
                return cell;
            };
            return cellNodeBlock;
        }
         */
        if (nearbyBusinesses) {
            YLPBusiness *busi = [nearbyBusinesses objectAtIndex:indexPath.row];
            YLPCategory *cat = busi.categories.firstObject;
            //GMSPlaceLikelihood *pl = [nearbyPlaces objectAtIndex:indexPath.row];
            //NSString *type = [[(NSString *)[pl.place.types firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
            CLLocation *to = [[CLLocation alloc] initWithLatitude:busi.location.coordinate.latitude longitude:busi.location.coordinate.longitude];
            CLLocationDistance distance = [to distanceFromLocation:locationManager.currentLocation];
            //NSString *address = [pl.place.formattedAddress componentsSeparatedByString:@","][0];
            //NSLog(@"%s - %@", __PRETTY_FUNCTION__, pl.place.attributions);
            
            ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                PlaceNode *cell = [[PlaceNode alloc] init];
                [cell setTitle:busi.name];
                [cell setSubtitle:[NSString stringWithFormat:@"%@ • %dft", cat.name, @((distance/0.3048)).intValue]];
                [cell setFooter:busi.location.address.firstObject];
                return cell;
            };
            return cellNodeBlock;
        }
    }
    
    
    /// default
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        ASCellNode *cell = [[ASCellNode alloc] init];
        cell.style.preferredSize = CGSizeMake(0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    };
    return cellNodeBlock;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    /// 0: Suggestions
    if (section == 0) {
        return 0;
    }
    
    /// 1: Places
    if (section == 1) {
        return 30;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /// 0: Suggestions
    if (section == 0) {
        return nil;
        
    /// 1: Places
    } else if (section == 1) {
        return [TableHeader headerWithText:@"PLACES AROUND YOU" andHeight:30];
        
    } else {
        return nil;
    }
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:true];
    
    /// 0: Suggestions
    if (indexPath.section == 0) {
        
    }
    
    /// 1: Places
    if (indexPath.section == 1) {
        [locationManager stopMoniteringUpdates];
        
        // show place detail
        YLPBusiness *busi = [nearbyBusinesses objectAtIndex:indexPath.row];
        PlaceViewController *place = [[PlaceViewController alloc] initWithGooglePlaceInfo:@{@"name": busi.name,
                                                                                            @"latitude": [NSNumber numberWithDouble:busi.location.coordinate.latitude],
                                                                                            @"longitude": [NSNumber numberWithDouble:busi.location.coordinate.longitude]}];
        [self.navigationController pushViewController:place animated:true];
    }
}

/// UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

/// BubbleScrollerNodeDelegate

- (void)bubbleScrollerDidSelectItem:(BubbleItem *)item atIndexPath:(NSIndexPath *)indexPath {
    [searchBar setText:item.title];
    [searchBar resignFirstResponder];
}

@end
