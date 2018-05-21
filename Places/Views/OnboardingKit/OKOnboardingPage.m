//
//  OKOnboardingPage.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "OKOnboardingPage.h"

#import "_OKInfoItemNode.h"
#import "_OKButton.h"
#import "_OKOnboardingPageLayouts.h"

@implementation OKOnboardingPage {
    ASTextNode *_titleNode;
    _OKButton *_nextButton;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // init title node
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.attributedText = [self title];
        
        // init next button
        _nextButton = [[_OKButton alloc] initWithTitle:[self nextButtonTitle]];
        _nextButton.style.minHeight = ASDimensionMake(55);
        _nextButton.style.maxHeight = ASDimensionMake(55);
        _nextButton.style.minWidth = ASDimensionMake(100);
        //_nextButton.style.flexGrow = 1.0;
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titleFontAttributesWithColor:(UIColor *)color {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: color,
             NSFontAttributeName: [UIFont systemFontOfSize:36 weight:UIFontWeightHeavy],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)infoTitleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor blackColor],
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)infoSubtitleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
             NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)infoBodyFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
             NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    //
    ASStackLayoutSpec *_titleStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:0
                                                                     justifyContent:ASStackLayoutJustifyContentCenter
                                                                         alignItems:ASStackLayoutAlignItemsStart
                                                                           children:@[_titleNode]];
    ASStackLayoutSpec *_infoItemsStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:30
                                                                          justifyContent:ASStackLayoutJustifyContentCenter
                                                                              alignItems:ASStackLayoutAlignItemsStart
                                                                                children:[self _infoItems]];
    ASStackLayoutSpec *buttonStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:0
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsCenter
                                                                            children:@[_nextButton]];
    buttonStack.style.flexBasis = ASDimensionMake(@"20%");
    buttonStack.style.flexGrow = true;
    buttonStack.style.flexShrink = true;
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:35
                                                                    justifyContent:ASStackLayoutJustifyContentCenter
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:@[_titleStack,
                                                                                     _infoItemsStack]];
    mainStack.style.flexBasis = ASDimensionMake(@"80%");
    //
    ASStackLayoutSpec *stack = [ASStackLayoutSpec verticalStackLayoutSpec];
    stack.children = @[mainStack,
                       buttonStack];

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(40, 30, 0, 30) child:stack];
}

#pragma mark - Actions

#pragma mark - Helpers

- (NSAttributedString *)title {
    return [[NSAttributedString alloc] initWithString:@"OnboardingKit"];
}

- (NSArray<OKInfoItem *> *)infoItems {
    return @[];
}

- (NSArray<_OKInfoItemNode *> *)_infoItems {
    NSMutableArray *nodes = [NSMutableArray new];
    for (OKInfoItem *item in [self infoItems]) {
        [nodes addObject:[[_OKInfoItemNode alloc] initWithItem:item]];
    }
    return nodes;
}

- (NSString *)nextButtonTitle {
    return @"Begin Setup";
}

@end
