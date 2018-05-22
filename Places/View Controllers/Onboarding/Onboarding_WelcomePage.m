//
//  Onboarding_WelcomePage.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FAHelpers.h"
#import "Onboarding_WelcomePage.h"

@implementation Onboarding_WelcomePage

#pragma mark - Properties

- (NSAttributedString *)title {
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Welcome to\n" attributes:[self titleFontAttributesWithColor:[UIColor blackColor]]];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Places" attributes:[self titleFontAttributesWithColor:[UIColor colorWithRed:0.114 green:0.733 blue:0.867 alpha:1.00]]]];
    return titleString;
}

- (NSArray<OKInfoItem *> *)infoItems {
    // find item
    OKInfoItem *find = [OKInfoItem new];
    find.title = [[NSAttributedString alloc] initWithString:@"Find" attributes:[self infoTitleFontAttributes]];
    find.icon = [[UIImage imageNamed:@"search_con2"] imageWithSize:CGSizeMake(30, 30)];
    find.iconColor = PLACEHOLDER_LIGHT_BLUE;
    find.body = [[NSAttributedString alloc] initWithString:@"Search and discover the best places around you and anywhere!" attributes:[self infoBodyFontAttributes]];
    
    // favorites item
    OKInfoItem *favs = [OKInfoItem new];
    favs.title = [[NSAttributedString alloc] initWithString:@"Favorites" attributes:[self infoTitleFontAttributes]];
    favs.icon = [[UIImage imageNamed:@"favs_con"] imageWithSize:CGSizeMake(30, 30)];
    favs.iconColor = [UIColor colorWithHexString:@"#fc4758"];
    favs.body = [[NSAttributedString alloc] initWithString:@"Keep track of all your favorite places in one place and quickly see the ones closest to you" attributes:[self infoBodyFontAttributes]];
    
    // lists item
    OKInfoItem *lists = [OKInfoItem new];
    lists.title = [[NSAttributedString alloc] initWithString:@"Lists" attributes:[self infoTitleFontAttributes]];
    lists.icon = [[UIImage imageNamed:@"lists_con"] imageWithSize:CGSizeMake(30, 30)];
    lists.iconColor = [UIColor colorWithHexString:@"#989898"];
    lists.body = [[NSAttributedString alloc] initWithString:@"Organize your places into lists to keep your Favorites clean" attributes:[self infoBodyFontAttributes]];
    
    return @[find, favs, lists];
}

- (NSString *)nextButtonTitle {
    return @"Continue";
}

#pragma mark = Animation Sequences

- (NSArray<OKAnimation *> * _Nonnull)introSequence {
    return @[[OKAnimation delay:5],
             [OKAnimation fadeIn:@[@"title", @"find", @"favs", @"lists"] duration:1.2 delay:1.0 postDelay:0.5],
             [OKAnimation fadeIn:@[@"next_button"] duration: 0.5 delay:1.0 postDelay:0.0]];
}

- (NSArray<OKAnimation *> * _Nonnull)outroSequence {
    return @[[OKAnimation delay:0.4],
             [OKAnimation fadeOut:@[@"title", @"find", @"favs", @"lists"] duration:1.2 delay:1.0 postDelay:0.5],
             [OKAnimation fadeOut:@[@"next_button"] duration: 0.5 delay:1.0 postDelay:0.0]];
}

#pragma mark - Interface

@end
