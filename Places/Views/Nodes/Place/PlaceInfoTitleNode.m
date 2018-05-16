//
//  PlaceInfoTitleNode.m
//  Places
//
//  Created by Timothy Desir on 4/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PlaceInfoTitleNode.h"

// helpers
#import "FAHelpers.h"

@implementation PlaceInfoTitleNode {
    ASTextNode *titleNode;
    ASTextNode *subtitleNode;
    ASImageNode *starsNode;
    
    // tmp
    NSInteger _rating;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _rating = 5;
        
        // init title node
        titleNode = [[ASTextNode alloc] init];
        titleNode.maximumNumberOfLines = 1;
        titleNode.attributedText = [[NSAttributedString alloc] initWithString:@"Some Title Goes Here" attributes:[self titleFontAttributes]];
        
        // init subtitle node
        subtitleNode = [[ASTextNode alloc] init];
        subtitleNode.maximumNumberOfLines = 1;
        subtitleNode.attributedText = [[NSAttributedString alloc] initWithString:@"Thai • 164ft •" attributes:[self subtitleFontAttributes]];
        
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
    
    return @{NSForegroundColorAttributeName: [UIColor darkGrayColor],
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

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    ASStackLayoutSpec *subStars = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                          spacing:3
                                                                   justifyContent:ASStackLayoutJustifyContentCenter
                                                                       alignItems:ASStackLayoutAlignItemsCenter
                                                                         children:@[subtitleNode, (_rating > 0 && _rating <= 5) ? starsNode : [[ASLayoutSpec alloc] init]]];
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:2
                                                                    justifyContent:ASStackLayoutJustifyContentCenter
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[titleNode,
                                                                                     subStars]];
    //
    return mainStack;
}

#pragma mark - Actions

#pragma mark - Helpers

- (void)setTitle:(NSString *)title {
    titleNode.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[self titleFontAttributes]];
}

- (void)setSubtitle:(NSString *)sub withRating:(NSInteger)rating {
    subtitleNode.attributedText = [[NSAttributedString alloc] initWithString:sub attributes:[self subtitleFontAttributes]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _rating = rating;
        if (rating <= 0 || rating > 5) {
            [self transitionLayoutWithAnimation:false shouldMeasureAsync:false measurementCompletion:nil];
        }
    });
}

@end
