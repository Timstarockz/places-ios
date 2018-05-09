//
//  PSInstagramViewer.h
//  Places
//
//  Created by Timothy Desir on 4/29/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

@import InstagramKit;
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ASCustomSeparatorCellNode.h"

@interface PSInstagramViewer : ASCustomSeparatorCellNode

- (void)getPhotosFromCoordinates:(CLLocationCoordinate2D)coo;

@end
