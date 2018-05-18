//
//  OKOnboardingPage.h
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "OKInfoItem.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface OKOnboardingPage : ASDisplayNode

- (NSAttributedString *)title;
- (NSArray<OKInfoItem *> *)infoItems;
- (NSString *)nextButtonTitle;

- (NSDictionary *)titleFontAttributes;

@end
