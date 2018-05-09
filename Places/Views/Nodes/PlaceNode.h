//
//  PlaceNode.h
//  Places
//
//  Created by Timothy Desir on 3/23/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

@import AsyncDisplayKit;

#define PLACE_ICON_SIZE 66
#define PLACE_TOP_BOTTOM_PADDING 16
#define PLACE_LEFT_RIGHT_PADDING 12

#define PLACE_TEXT_SPACING 3
#define PLACE_HORI_DETAIL_PADDING 8

@interface PlaceNode : ASCellNode

- (void)setIcon:(UIImage *)image;
- (void)setIconURL:(NSString *)url;

- (void)setIconColor:(UIColor *)color;
- (void)setBubbleIcon:(UIImage *)icon;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setFooter:(NSString *)footer;
- (void)setRating:(NSInteger)rating; // max: 5

@end
