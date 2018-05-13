//
//  PlaceNode.m
//  Places
//
//  Created by Timothy Desir on 3/23/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PlaceNode.h"

// views
#import "FATabbedToolbar.h"

// helpers
#import "FAHelpers.h"

@interface PlaceNode (Internal)

@end

@implementation PlaceNode {
    ASNetworkImageNode *placeIcon;
    ASDisplayNode *placeBubble;
    _FABarItemView *_placeBubble;
    ASTextNode *placeTitle;
    ASTextNode *placeSubtitle;
    ASTextNode *placeFooter;
    ASImageNode *starsNode;
    
    ASDisplayNode *div;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        // place icon
        placeIcon = [[ASNetworkImageNode alloc] init];
        placeIcon.style.preferredSize = CGSizeMake(PLACE_ICON_SIZE, PLACE_ICON_SIZE);
        placeIcon.clipsToBounds = true;
        placeIcon.cornerRadius = PLACE_ICON_SIZE / 2;
        placeIcon.defaultImage = [UIImage imageNamed:@"stupid"];
        
        // place bubble
        /// TODO:
        /// convert this junk into PlaceIconNode
        placeBubble = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            self->_placeBubble = [[_FABarItemView alloc] initWithFrame:CGRectMake(0, 0, PLACE_ICON_SIZE, PLACE_ICON_SIZE)];
            self->_placeBubble.backgroundColor = PLACEHOLDER_ORANGE;
            self->_placeBubble.iconView.image = [UIImage imageNamed:@"breakfast2_placecon"];
            self->_placeBubble.userInteractionEnabled = false;
            self->_placeBubble.alpha = 1.0;
            self->_placeBubble.layer.cornerRadius = PLACE_ICON_SIZE / 2;
            return self->_placeBubble;
        }];
        placeBubble.style.preferredSize = CGSizeMake(PLACE_ICON_SIZE, PLACE_ICON_SIZE);
        ///
        
        // place title
        placeTitle = [[ASTextNode alloc] init];
        placeTitle.maximumNumberOfLines = 2;
        placeTitle.truncationMode = NSLineBreakByTruncatingTail;
        placeTitle.attributedText = [[NSAttributedString alloc] initWithString:@"Place Title" attributes:[self titleFontAttributes]];
        
        // place subtitle
        placeSubtitle = [[ASTextNode alloc] init];
        placeSubtitle.maximumNumberOfLines = 1;
        placeSubtitle.attributedText = [[NSAttributedString alloc] initWithString:@"Place Subtitle" attributes:[self subtitleFontAttributes]];
        
        // place footer
        placeFooter = [[ASTextNode alloc] init];
        placeFooter.maximumNumberOfLines = 1;
        placeFooter.attributedText = [[NSAttributedString alloc] initWithString:@"Place Footer" attributes:[self footerFontAttributes]];
        
        // init stars node
        starsNode = [[ASImageNode alloc] init];
        starsNode.contentMode = UIViewContentModeScaleToFill;
        starsNode.image = [UIImage imageNamed:@"review_stars_5"];
        starsNode.style.preferredSize = CGSizeMake(80, 13);
        
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#6c6c6c"],
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)subtitleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#555555"],
             NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)footerFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#949494"],
             NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    placeTitle.style.maxWidth = ASDimensionMake(@(fabs([UIScreen mainScreen].bounds.size.width-(PLACE_LEFT_RIGHT_PADDING*2)-(PLACE_HORI_DETAIL_PADDING*2)-(PLACE_ICON_SIZE))).integerValue);
    placeSubtitle.style.maxWidth = ASDimensionMake(@(fabs([UIScreen mainScreen].bounds.size.width-(PLACE_LEFT_RIGHT_PADDING*2)-(PLACE_HORI_DETAIL_PADDING)-(PLACE_ICON_SIZE))).integerValue);
    placeFooter.style.maxWidth = ASDimensionMake(@(fabs([UIScreen mainScreen].bounds.size.width-(PLACE_LEFT_RIGHT_PADDING*2)-(PLACE_HORI_DETAIL_PADDING)-(PLACE_ICON_SIZE))).integerValue);
    //
    ASStackLayoutSpec *textStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:PLACE_TEXT_SPACING
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:@[placeTitle,
                                                                                     placeSubtitle,
                                                                                     placeFooter,
                                                                                     starsNode]];
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:PLACE_HORI_DETAIL_PADDING
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[placeBubble, textStack]];
    //
    ASInsetLayoutSpec *mainInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(PLACE_TOP_BOTTOM_PADDING,
                                                                                                 PLACE_LEFT_RIGHT_PADDING,
                                                                                                 PLACE_TOP_BOTTOM_PADDING,
                                                                                                 PLACE_LEFT_RIGHT_PADDING)
                                                                          child:mainStack];
    
    return mainInset;
}

#pragma mark - Actions

#pragma mark - Helpers

- (void)setIcon:(UIImage *)image {
    placeIcon.image = nil;
    placeIcon.defaultImage = image;
}

- (void)setIconURL:(NSString *)url {
    [placeIcon setURL:[NSURL URLWithString:url]];
}

- (void)setIconColor:(UIColor *)color {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_placeBubble.backgroundColor = color;
    });
}

- (void)setBubbleIcon:(UIImage *)icon {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_placeBubble.iconView.image = icon;
    });
}

- (void)setTitle:(NSString *)title {
    if (title) {
        placeTitle.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[self titleFontAttributes]];
    }
}

- (void)setSubtitle:(NSString *)subtitle {
    placeSubtitle.attributedText = [[NSAttributedString alloc] initWithString:subtitle attributes:[self subtitleFontAttributes]];
}

- (void)setFooter:(NSString *)footer {
    if (footer) {
        placeFooter.attributedText = [[NSAttributedString alloc] initWithString:footer attributes:[self footerFontAttributes]];
    }
}

- (void)setRating:(NSInteger)rating {
    
}

@end
