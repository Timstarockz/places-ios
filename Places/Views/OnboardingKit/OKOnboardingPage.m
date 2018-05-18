//
//  OKOnboardingPage.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "OKOnboardingPage.h"
#import "_OKOnboardingPageLayouts.h"

@implementation OKOnboardingPage

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
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
    return _listItemPageLayout();
}

#pragma mark - Actions

#pragma mark - Helpers

- (NSAttributedString *)title {
    return nil;
}

- (NSArray<OKInfoItem *> *)infoItems {
    return @[];
}

- (NSString *)nextButtonTitle {
    return nil;
}

@end
