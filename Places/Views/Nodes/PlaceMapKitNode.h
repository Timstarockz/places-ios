//
//  PlaceMapKitNode.h
//  Places
//
//  Created by Timothy Desir on 4/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#define MAP_CORNER_RADIUS 10

@interface PlaceMapKitNode : ASCellNode

- (void)setLatitude:(double)latitude andLongitude:(double)longitude;

@end
