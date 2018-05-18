//
//  OKOnboardingViewController.h
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class OKOnboardingPage;

@interface OKOnboardingViewController : ASViewController

+ (OKOnboardingViewController *)initializeWithPages:(NSArray<OKOnboardingPage *> *)pages;

@end
