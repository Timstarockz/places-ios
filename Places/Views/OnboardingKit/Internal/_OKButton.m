//
//  _OKButton.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "_OKButton.h"

@implementation _OKButton

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.114 green:0.733 blue:0.867 alpha:1.00];
        self.cornerRadius = 12;
        self.clipsToBounds = true;
        
        // init title node
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.maximumNumberOfLines = 1;
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        _titleNode.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[self titlePlaceholderFontAttributesWithColor:[UIColor whiteColor]]];
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titlePlaceholderFontAttributesWithColor:(UIColor *)color {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentCenter;
    
    return @{NSForegroundColorAttributeName: color,
             NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    ASRelativeLayoutSpec *mainRel = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionCenter
                                                                                          verticalPosition:ASRelativeLayoutSpecPositionCenter sizingOption:ASRelativeLayoutSpecSizingOptionDefault
                                                                                                     child:_titleNode];
    
    
    return mainRel;
}

#pragma mark - Actions

#pragma mark - Helpers

- (void) setHighlighted: (BOOL) highlighted {
    [super setHighlighted: highlighted];
    self.alpha = highlighted ? 0.5f : 1.0f;
}

@end
