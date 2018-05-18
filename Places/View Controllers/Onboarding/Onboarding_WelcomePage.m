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

#pragma mark - Fonts

- (NSDictionary *)titleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor blackColor],
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Properties

- (NSAttributedString *)title {
    return [[NSAttributedString alloc] initWithString:@"Welcome to\nPlaces" attributes:[self titleFontAttributes]];
}

- (NSArray<OKInfoItem *> *)infoItems {
    
    // find item
    OKInfoItem *find = [OKInfoItem new];
    find.title = [[NSAttributedString alloc] initWithString:@"Find" attributes:[self titleFontAttributes]];
    find.icon = [UIImage imageNamed:@"search_con2"];
    find.iconColor = PLACEHOLDER_LIGHT_BLUE;
    
    // favorites item
    OKInfoItem *favs = [OKInfoItem new];
    favs.title = [[NSAttributedString alloc] initWithString:@"Favorites" attributes:[self titleFontAttributes]];
    favs.icon = [UIImage imageNamed:@"favs_con"];
    favs.iconColor = [UIColor colorWithHexString:@"#fc4758"];
    
    // lists item
    OKInfoItem *lists = [OKInfoItem new];
    lists.title = [[NSAttributedString alloc] initWithString:@"Lists" attributes:[self titleFontAttributes]];
    lists.icon = [UIImage imageNamed:@"lists_con"];
    lists.iconColor = [UIColor colorWithHexString:@"#989898"];
    
    
    return @[find, favs, lists];
}

- (NSString *)nextButtonTitle {
    return @"Continue";
}

#pragma mark - Interface

@end
