//
//  OKOnboardingPage.h
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "OKInfoItem.h"
#import "OKAnimation.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface OKOnboardingPage : ASDisplayNode

- (NSAttributedString * _Nonnull)title;
- (nullable NSArray<OKInfoItem *> *)infoItems;
- (NSString * _Nonnull)nextButtonTitle;

- (NSArray<OKAnimation *> * _Nonnull)introSequence;
- (NSArray<OKAnimation *> * _Nonnull)outroSequence;


// Default Fonts:
- (NSDictionary * _Nonnull)titleFontAttributesWithColor:(UIColor * _Nonnull)color;

- (NSDictionary * _Nonnull)infoTitleFontAttributes;

- (NSDictionary * _Nonnull)infoSubtitleFontAttributes;

- (NSDictionary * _Nonnull)infoBodyFontAttributes;

@end
