//
//  Onboarding_PermissionsPage.m
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FAHelpers.h"
#import "Onboarding_PermissionsPage.h"

@implementation Onboarding_PermissionsPage

#pragma mark - Properties

- (NSAttributedString *)title {
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Permissions" attributes:[self titleFontAttributesWithColor:[UIColor blackColor]]];
    return titleString;
}

- (NSArray<OKInfoItem *> *)infoItems {
    
    // location item
    OKInfoItem *location = [OKInfoItem new];
    location.title = [[NSAttributedString alloc] initWithString:@"Location Services" attributes:[self infoTitleFontAttributes]];
    location.subtitle = [[NSAttributedString alloc] initWithString:@"for" attributes:[self infoSubtitleFontAttributes]];
    location.icon = [[UIImage imageNamed:@"search_con2"] imageWithSize:CGSizeMake(30, 30)];
    location.iconColor = [UIColor colorWithRed:0.114 green:0.686 blue:0.925 alpha:1.00];
    location.body = [[NSAttributedString alloc] initWithString:@"• Finding places nearby\n• Directions\n• Local Events" attributes:[self infoBodyFontAttributes]];
    
    // contacts item
    OKInfoItem *contacts = [OKInfoItem new];
    contacts.title = [[NSAttributedString alloc] initWithString:@"Contacts" attributes:[self infoTitleFontAttributes]];
    contacts.subtitle = [[NSAttributedString alloc] initWithString:@"for" attributes:[self infoSubtitleFontAttributes]];
    contacts.icon = [[UIImage imageNamed:@"contacts_con"] imageWithSize:CGSizeMake(35, 35)];
    contacts.iconColor = [UIColor colorWithRed:0.973 green:0.675 blue:0.227 alpha:1.00];
    contacts.body = [[NSAttributedString alloc] initWithString:@"• Showing contacts associated with a particular place\n• Inviting to Places" attributes:[self infoBodyFontAttributes]];
    
    return @[location, contacts];
}

- (NSString *)nextButtonTitle {
    return @"Enable";
}

#pragma mark = Animation Sequences

- (NSArray<OKAnimation *> * _Nonnull)introSequence {
    return @[[OKAnimation delay:0.4],
             [OKAnimation fadeIn:@[@"title", @"find", @"favs", @"lists"] duration:1.2 postDelay:0.5],
             [OKAnimation fadeIn:@[@"next_button"] duration: 0.5 postDelay:0.0]];
}

- (NSArray<OKAnimation *> * _Nonnull)outroSequence {
    return @[[OKAnimation delay:0.4],
             [OKAnimation fadeOut:@[@"title", @"find", @"favs", @"lists"] duration:1.2 postDelay:0.5],
             [OKAnimation fadeOut:@[@"next_button"] duration: 0.5 postDelay:0.0]];
}

#pragma mark - Interface

@end
