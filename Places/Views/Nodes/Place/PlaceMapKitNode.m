//
//  PlaceMapKitNode.m
//  Places
//
//  Created by Timothy Desir on 4/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// frameworks
@import MapKit;
@import CoreLocation;

// main
#import "PlaceMapKitNode.h"

// helpers
#import "FAHelpers.h"

#define MAP_PADDING 15
#define MAP_HORI_PADDING (TABLE_HORI_PADDING-3)

@implementation PlaceMapKitNode {
    ASMapNode *map;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init map
        map = [[ASMapNode alloc] init];
        map.clipsToBounds = true;
        map.cornerRadius = MAP_CORNER_RADIUS;
        //map.liveMap = true;
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    map.style.preferredSize = CGSizeMake(constrainedSize.max.width, 150);
    //
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(MAP_PADDING, MAP_HORI_PADDING, MAP_PADDING, MAP_HORI_PADDING) child:map];
}

#pragma mark - Actions

#pragma mark - Helpers

- (void)setLatitude:(double)latitude andLongitude:(double)longitude {
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);
    [map setRegion:MKCoordinateRegionMakeWithDistance(coord, 500, 500)];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coord;
    map.annotations = @[annotation];
}

@end
