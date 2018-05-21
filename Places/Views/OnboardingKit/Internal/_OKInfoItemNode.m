//
//  _OKInfoItemNode.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "_OKInfoItemNode.h"
#import "OKInfoItem.h"

@implementation _OKInfoItemNode {
    OKInfoItem *_item;
    
    ASImageNode *iconNode;
    ASTextNode *titleNode, *subtitleNode, *bodyNode;
}

#pragma mark - Initialization

- (instancetype)initWithItem:(OKInfoItem *)item {
    self = [super init];
    if (self) {
        _item = item;
        
        // init icon node
        iconNode = [[ASImageNode alloc] init];
        iconNode.style.preferredSize = CGSizeMake(60, 60);
        iconNode.cornerRadius = 60 / 2;
        iconNode.clipsToBounds = true;
        iconNode.backgroundColor = _item.iconColor;
        iconNode.image = _item.icon;
        iconNode.contentMode = UIViewContentModeCenter;
        //iconNode.forcedSize = CGSizeMake(30, 30);
        
        // init title node
        titleNode = [[ASTextNode alloc] init];
        titleNode.maximumNumberOfLines = 1;
        titleNode.attributedText = _item.title;
        
        // init subtitle node
        subtitleNode = [[ASTextNode alloc] init];
        subtitleNode.maximumNumberOfLines = 1;
        subtitleNode.attributedText = _item.subtitle;
        
        // init body node
        bodyNode = [[ASTextNode alloc] init];
        bodyNode.maximumNumberOfLines = 4;
        bodyNode.attributedText = _item.body;
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titlePlaceholderFontAttributesWithColor:(UIColor *)color {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: color,
             NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    // title / subtitle stack
    ASStackLayoutSpec *titleStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                            spacing:3
                                                                     justifyContent:ASStackLayoutJustifyContentCenter
                                                                         alignItems:ASStackLayoutAlignItemsCenter
                                                                           children:@[titleNode, subtitleNode]];
    
    // text stack
    ASStackLayoutSpec *textStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:3
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:@[titleStack,
                                                                                     bodyNode]];
    textStack.style.flexShrink = 1.0;
    // main stack
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:16 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[iconNode, textStack]];
    //mainStack.style.flexShrink = 1.0;
    
    //
    return mainStack;
}

#pragma mark - Actions

#pragma mark - Helpers

@end
