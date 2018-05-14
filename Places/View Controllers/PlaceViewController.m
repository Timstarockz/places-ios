//
//  PlaceViewController.m
//  Places
//
//  Created by Timothy Desir on 3/31/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PlaceViewController.h"

// views
#import "PSBlankNode.h"
#import "PlaceInfoTitleNode.h"
#import "PlaceMapKitNode.h"
#import "PlaceGoogleMapNode.h"
#import "PSSegmentedControl.h"
#import "PlaceDetailNode.h"
#import "PlaceHoursNode.h"
#import "PSInstagramViewer.h"

// frameworks
#import "FAKit.h"
#import <CoreLocation/CoreLocation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <GooglePlaces/GooglePlaces.h>

// helpers
#import "AppDelegate.h"
#import "FAHelpers.h"

@interface PlaceViewController () <ASTableDelegate, ASTableDataSource, UITableViewDelegate>

@end

@implementation PlaceViewController {
    NSDictionary *_placeInfo;
    FANavBar *navBar;
    ASTableNode *placeTable;
    PSBlankNode *blankNode;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init nav bar
        navBar = [[FANavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
        [navBar setShowBackButton:true];
        //
        FABarItem *share = [[FABarItem alloc] init];
        share.title = @"Share Place";
        share.icon = [UIImage imageNamed:@"share_con"];
        share.backgroundColor = [UIColor darkGrayColor];
        [share addTarget:self withAction:@selector(sharePlace)];
        [navBar setRightItem:share];
        [navBar.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        // init place table
        placeTable = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        placeTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        placeTable.delegate = self;
        placeTable.dataSource = self;
        placeTable.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        placeTable.contentInset = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP , 0, FATOOLBAR_HEIGHT+60, 0);
        placeTable.view.scrollIndicatorInsets = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP, 0, FATOOLBAR_HEIGHT, 0);
        placeTable.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubnode:placeTable];
        
        // init blank node
        blankNode = [[PSBlankNode alloc] init];
        blankNode.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        blankNode.layoutOrder = @[blankNode.image,
                                  blankNode.message];
        [blankNode setMessageText:@"didn't load!"];
        [self.view addSubnode:blankNode];
        [blankNode showLoadingState:true];
    }
    
    return self;
}

- (instancetype)initWithPlace:(Place *)place {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _place = place;
    }
    
    return self;
}

- (instancetype)initWithGooglePlaceInfo:(NSDictionary *)placeInfo {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _placeInfo = placeInfo;
        
        // init info title node
        PlaceInfoTitleNode *titleView = [[PlaceInfoTitleNode alloc] init];
        [titleView setTitle:_placeInfo[@"name"]];
        [navBar setCustomView:titleView.view];
        
        [self getPlaceIDInfo];
    }
    
    return self;
}

- (UIView *)statusBarAccessoryView {
    return navBar;
}

- (FABarItem *)tabBarItem {
    FABarItem *root = [[FABarItem alloc] init];
    root.title = @"Find Places";
    root.icon = [UIImage imageNamed:@"search_con2"];
    root.backgroundColor = [UIColor colorWithHexString:@"#20c3e1"];
    
    FABarItem *favorite = [[FABarItem alloc] init];
    favorite.title = @"Toggle Favorite Place";
    favorite.icon = [UIImage imageNamed:@"favs_con"];
    favorite.backgroundColor = [UIColor darkGrayColor];
    [favorite addTarget:self withAction:@selector(toggleFavorite)];
    root.rightItem = favorite;
    
    return root;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"PlaceViewController alive - %s - %@", __PRETTY_FUNCTION__, self.debugDescription);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"PlaceViewController released - %s - %@", __PRETTY_FUNCTION__, self.debugDescription);
    //[super dealloc];
}

#pragma mark - Methods

- (void)getPlaceIDInfo {
    NSString *term = nil;
    NSNumber *lat = @0.0;
    NSNumber *lon = @0.0;
    
    if (_place) {
        term = _place.name;
        lat = _place.latitude;
        lon = _place.longitude;
    } else {
        term = _placeInfo[@"name"];
        lat = [NSNumber numberWithDouble:[_placeInfo[@"latitude"] doubleValue]];
        lon = [NSNumber numberWithDouble:[_placeInfo[@"longitude"] doubleValue]];
    }
    
    [[AppDelegate yelpClient] searchWithCoordinate:[[YLPCoordinate alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue] term:term limit:1 offset:0 sort:YLPSortTypeBestMatched completionHandler:^(YLPSearch * _Nullable search, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                self->_place = [PlacesDatabase placeFromYelpModel:search.businesses.firstObject];
                
                //
                [[AppDelegate yelpClient] retrieveBusinessURLFromLink:self->_place.yelpURL.string completion:^(NSString * _Nullable url, NSError * _Nullable error) {
                    
                }];
                //
                
                // tweaking this line of code literally saves me money lol
                CGFloat nameMatchPerc = [self->_place.name scoreAgainst:self->_placeInfo[@"name"] fuzziness:@0.5 options:NSStringScoreOptionFavorSmallerWords];
                if (nameMatchPerc > 0.50) {
                    [self->placeTable performBatchUpdates:^{
                        [self->placeTable reloadData];
                    } completion:^(BOOL finished) {
                        [self->blankNode hideNodeAnimated:true];
                    }];
                    
                    NSLog(@"\n %s - Found business (%fp):(y: %@ || g: %@)", __PRETTY_FUNCTION__, nameMatchPerc, self->_place.name, self->_placeInfo[@"name"]);
                } else {
                    // names did not match
                    if (self->_placeInfo[@"place_id"]) {
                        [self getGooglePlace:self->_placeInfo[@"place_id"]];
                    }
                    
                    NSLog(@"\n%s - Could not match business (%fp):(y: %@ || g: %@)", __PRETTY_FUNCTION__, nameMatchPerc, self->_place.name, self->_placeInfo[@"name"]);
                }
            } else {
                self->_place = nil;
                if (self->_placeInfo[@"place_id"]) {
                    [self getGooglePlace:self->_placeInfo[@"place_id"]];
                }
                NSLog(@"\n%s - Could not find business\n", __PRETTY_FUNCTION__);
            }
        });
    }];
}

- (void)getGooglePlace:(NSString *)pid {
    [[GMSPlacesClient sharedClient] lookUpPlaceID:pid callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        if (!error) {
            self->_place = [PlacesDatabase placeFromGooglePlaceModel:result];
            [self->placeTable performBatchUpdates:^{
                [self->placeTable reloadData];
            } completion:^(BOOL finished) {
                [self->blankNode hideNodeAnimated:true];
            }];
        } else {
            [self->blankNode showLoadingState:false];
        }
    }];
}

- (void)sharePlace {
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"helllooo"] applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypePrint,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    activityVC.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        if (completed) {
            NSLog(@"%s", __PRETTY_FUNCTION__);
        }
    };
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)getDirections {
    UIAlertAction *appleMaps = [UIAlertAction actionWithTitle:@"Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@", @"2008%20Chestnut%20Street%20Oakland"]] options:@{} completionHandler:nil];
    }];
    UIAlertAction *googleMaps = [UIAlertAction actionWithTitle:@"Google Maps" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    //
    UIAlertController *alco = [UIAlertController alertControllerWithTitle:@"Get Directions using..." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alco addAction:appleMaps];
    [alco addAction:googleMaps];
    [alco addAction:cancel];
    [self.navigationController presentViewController:alco animated:true completion:nil];
}

- (void)dialPhoneNumber {
    if (_place.phone) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [_place.phone phoneNumber]]] options:@{} completionHandler:nil];
    }
}

- (void)openWebsite {
    if (_place.url.string && _place.yelpURL.string) {
        OPEN_SFURL(_place.url.string);
    } else if (_place.url.string && !_place.yelpURL.string) {
        OPEN_SFURL(_place.url.string);
    } else if (!_place.url.string && _place.yelpURL.string) {
        OPEN_SFURL(_place.yelpURL.string);
    }
}

- (void)rideShareDetails {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)toggleFavorite {
    Place *__place = _place;
    if ([__place.saved isEqual:@(false)]) {
        [[PlacesDatabase shared] savePlace:__place];
    } else {
        [[PlacesDatabase shared] unsavePlace:__place];
    }
}

#pragma mark - ASTableNodeDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    // 0: place header
    // 1: details
    return 2;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    // 0: place header
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        // 1: details
        //     0: directions
        //     1: phone
        //     2: website
        //     3: hours
        //     4: instagram
        return 5;
    } else {
        return 0;
    }
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_place) {
        // 0: place header
        if (indexPath.section == 0) {
            
            // 0: map view
            if (indexPath.row == 0) {
                ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                    PlaceMapKitNode *cell = [[PlaceMapKitNode alloc] init];
                    [cell setLatitude:self->_place.latitude.doubleValue andLongitude:self->_place.longitude.doubleValue];
                    return cell;
                };
                return cellNodeBlock;
            }
            
            // 1: place quick options
            if (indexPath.row == 1) {
                ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                    NSArray *segments = @[[PSSegment segmentWithTitle:@"call" andIcon:[UIImage imageNamed:@"phone_con"] withTarget:self andSelector:@selector(dialPhoneNumber)],
                                          [PSSegment segmentWithTitle:@"website" andIcon:[UIImage imageNamed:@"hyperlink_con"] withTarget:self andSelector:@selector(openWebsite)],
                                          [PSSegment segmentWithTitle:@"$$$" andIcon:[UIImage imageNamed:@"rideshare_con"] withTarget:self andSelector:@selector(rideShareDetails)]];
                    PSSegmentedControl *seg = [[PSSegmentedControl alloc] init];
                    [seg setSegments:segments];
                    
                    return seg;
                };
                return cellNodeBlock;
            }
        }
        
        // 1: details
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                if (_place.fullAddress != nil) {
                    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                        PlaceDetailNode *cell = [[PlaceDetailNode alloc] init];
                        [cell setSeparatorInset:UIEdgeInsetsMake(0, TABLE_HORI_PADDING, 0, 0)];
                        [cell setText:self->_place.fullAddress];
                        
                        FABarItem *item = [[FABarItem alloc] init];
                        item.backgroundColor = PLACEHOLDER_DEFAULT_GREY;
                        item.icon = [UIImage imageNamed:@"directions_con"];
                        [item addTarget:self withAction:@selector(getDirections)];
                        [cell setItem:item];
                        return cell;
                    };
                    return cellNodeBlock;
                }
            } else if (indexPath.row == 1) {
                if (_place.phone != nil) {
                    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                        PlaceDetailNode *cell = [[PlaceDetailNode alloc] init];
                        [cell setSeparatorInset:UIEdgeInsetsMake(0, TABLE_HORI_PADDING, 0, 0)];
                        [cell setText:[[NSString stringWithFormat:@"%@", self->_place.phone] phoneNumber]];
                        
                        FABarItem *item = [[FABarItem alloc] init];
                        item.backgroundColor = PLACEHOLDER_DEFAULT_GREY;
                        item.icon = [UIImage imageNamed:@"phone_con"];
                        [item addTarget:self withAction:@selector(dialPhoneNumber)];
                        [cell setItem:item];
                        return cell;
                    };
                    return cellNodeBlock;
                }
            } else if (indexPath.row == 2) {
                if (_place.url.string != nil) {
                    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                        PlaceDetailNode *cell = [[PlaceDetailNode alloc] init];
                        [cell setSeparatorInset:UIEdgeInsetsMake(0, TABLE_HORI_PADDING, 0, 0)];
                        [cell setText:self->_place.url.string];
                        
                        FABarItem *item = [[FABarItem alloc] init];
                        item.backgroundColor = PLACEHOLDER_DEFAULT_GREY;
                        item.icon = [UIImage imageNamed:@"hyperlink_con"];
                        [item addTarget:self withAction:@selector(openWebsite)];
                        [cell setItem:item];
                        return cell;
                    };
                    return cellNodeBlock;
                }
            } else if (indexPath.row == 3) {
                ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                    PlaceHoursNode *cell = [[PlaceHoursNode alloc] init];
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, TABLE_HORI_PADDING, 0, 0)];
                    [cell _showDays];
                    return cell;
                };
                return cellNodeBlock;
            } else if (indexPath.row == 4) {
                ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
                    PSInstagramViewer *cell = [[PSInstagramViewer alloc] init];
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, TABLE_HORI_PADDING, 0, 0)];
                    [cell showTopSeparator:false];
                    [cell showBottomSeparator:true];
                    cell.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);                    
                    return cell;
                };
                return cellNodeBlock;
            }
        }
    }
    
    /// default
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        ASCustomSeparatorCellNode *cell = [[ASCustomSeparatorCellNode alloc] init];
        cell.style.preferredSize = CGSizeMake(0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopSeparator:false];
        [cell showBottomSeparator:false];
        return cell;
    };
    return cellNodeBlock;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:true];
}

/// UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
