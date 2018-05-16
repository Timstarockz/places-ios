//
//  PlaceInfoTitleNode.h
//  Places
//
//  Created by Timothy Desir on 4/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface PlaceInfoTitleNode : ASDisplayNode

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)sub withRating:(NSInteger)rating;

@end
