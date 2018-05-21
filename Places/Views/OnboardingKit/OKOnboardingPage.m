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

- (void)layoutDidFinish {
    [super layoutDidFinish];
    
    if ([self introSequence].count > 0) {
        [self _runAnimation:[self introSequence].firstObject];
    }
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
    return _listItemPageLayout(_titleNode, [self _infoItems], _nextButton);
}

#pragma mark - Actions

#pragma mark - Helpers

- (NSAttributedString * _Nonnull)title; {
    return [[NSAttributedString alloc] initWithString:@"OnboardingKit"];
}

- (nullable NSArray<OKInfoItem *> *)infoItems; {
    return @[];
}

- (NSArray<_OKInfoItemNode *> *)_infoItems {
    NSMutableArray *nodes = [NSMutableArray new];
    for (OKInfoItem *item in [self infoItems]) {
        [nodes addObject:[[_OKInfoItemNode alloc] initWithItem:item]];
    }
    return nodes;
}

- (NSString * _Nonnull)nextButtonTitle; {
    return @"Let's go!";
}

- (NSArray<OKAnimation *> * _Nonnull)introSequence; {
    return @[];
}

- (NSArray<OKAnimation *> * _Nonnull)outroSequence {
    return @[];
}

#pragma mark - Animation Sequences

- (void)_runAnimation:(OKAnimation *)animation {
    
    // run "animations" for "delay"
    if ([animation.key isEqualToString:@"delay"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.preDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // CALL NEXT ANIMATION
        });
    }
    
    // run animations for "fadeIn"
    if ([animation.key isEqualToString:@"fadeIn"]) {
        /// BEFORE:
        _titleNode.alpha = 0.0;
        _nextButton.alpha = 0.0;
        for (_OKInfoItemNode *node in self.subnodes) {
            node.alpha = 0.0;
        }
        
        /// AFTER:
        [UIView animateWithDuration:animation.duration delay:animation.preDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_titleNode.alpha = 1.0;
            self->_nextButton.alpha = 1.0;
            for (_OKInfoItemNode *node in self.subnodes) {
                node.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.postDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // CALL NEXT ANIMATION
            });
        }];
    }
}

@end
