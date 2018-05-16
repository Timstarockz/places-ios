//
//  PlaceHoursNode.h
//  Places
//
//  Created by Timothy Desir on 4/19/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ASCustomSeparatorCellNode.h"

#define HOURS_VERT_SPACING 15

@interface PlaceHoursNode : ASCustomSeparatorCellNode

@property (nonatomic, readonly) BOOL showingAllDays; // default false

- (void)toggleAllDays;
- (void)_showDays;

@end
