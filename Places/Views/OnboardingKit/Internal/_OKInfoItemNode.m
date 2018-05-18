//
//  _OKInfoItemNode.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "_OKInfoItemNode.h"

@implementation _OKInfoItemNode {
    OKInfoItem *_item;
}

#pragma mark - Initialization

- (instancetype)initWithItem:(OKInfoItem *)item {
    self = [super init];
    if (self) {
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
    return [[ASLayoutSpec alloc] init];
}

#pragma mark - Actions

- (void)setInfo:(OKInfoItem *)item {
    
}

#pragma mark - Helpers

@end
