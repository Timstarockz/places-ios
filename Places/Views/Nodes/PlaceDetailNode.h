//
//  PlaceDetailNode.h
//  Places
//
//  Created by Timothy Desir on 4/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ASCustomSeparatorCellNode.h"

@class FATabBarItem;

@interface PlaceDetailNode : ASCustomSeparatorCellNode

- (void)setText:(NSString *)text;
- (void)setItem:(FATabBarItem *)item;

@end
