//
//  ASCustomSeparatorCellNode.m
//  Places
//
//  Created by Timothy Desir on 4/19/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "ASCustomSeparatorCellNode.h"

@implementation ASCustomSeparatorCellNode {
    UIEdgeInsets sepInset;
    ASDisplayNode *topDiv, *bottomDiv;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // init sepInset
        sepInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        // init top div
        topDiv = [[ASDisplayNode alloc] init];
        topDiv.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self addSubnode:topDiv];
        
        // init bottom div
        bottomDiv = [[ASDisplayNode alloc] init];
        bottomDiv.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self addSubnode:bottomDiv];
        [self showBottomSeparator:false];
    }
    
    return self;
}

#pragma mark - Fonts

#pragma mark - Layout

- (void)layout {
    [super layout];
    CGFloat divHeight = 1.0f / [[UIScreen mainScreen] scale];
    topDiv.frame = CGRectMake(sepInset.left, 0, (self.frame.size.width-sepInset.left)-sepInset.right, divHeight);
    bottomDiv.frame = CGRectMake(sepInset.left, self.frame.size.height-divHeight, (self.frame.size.width-sepInset.left)-sepInset.right, divHeight);
}

#pragma mark - Actions

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    sepInset = separatorInset;
}

- (void)showTopSeparator:(BOOL)flag {
    topDiv.hidden = !flag;
}

- (void)showBottomSeparator:(BOOL)flag {
    bottomDiv.hidden = !flag;
}

- (void)setSeparatorColor:(UIColor *)color {
    topDiv.backgroundColor = color;
    bottomDiv.backgroundColor = color;
}

#pragma mark - Helpers

@end
