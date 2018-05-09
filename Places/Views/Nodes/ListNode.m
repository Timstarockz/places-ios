//
//  ListNode.m
//  Places
//
//  Created by Timothy Desir on 3/23/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "ListNode.h"

// helpers
#import "FAHelpers.h"

@implementation ListNode {
    ASNetworkImageNode *listIcon;
    ASTextNode *listTitle;
    ASTextNode *listSubtitle;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        // list icon
        listIcon = [[ASNetworkImageNode alloc] init];
        listIcon.style.preferredSize = CGSizeMake(LIST_ICON_SIZE, LIST_ICON_SIZE);
        listIcon.clipsToBounds = true;
        listIcon.cornerRadius = LIST_ICON_SIZE/2;
        listIcon.defaultImage = [UIImage imageNamed:@"stupid"];
        
        // place title
        listTitle = [[ASTextNode alloc] init];
        listTitle.maximumNumberOfLines = 1;
        listTitle.attributedText = [[NSAttributedString alloc] initWithString:@"Some list of places" attributes:[self titleFontAttributes]];
        
        // place subtitle
        listSubtitle = [[ASTextNode alloc] init];
        listSubtitle.maximumNumberOfLines = 1;
        listSubtitle.attributedText = [[NSAttributedString alloc] initWithString:@"8 places" attributes:[self subtitleFontAttributes]];
        
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#6c6c6c"],
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)subtitleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentLeft;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#555555"],
             NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    ASStackLayoutSpec *textStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:2
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:@[listTitle,
                                                                                     listSubtitle]];
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:8
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[listIcon, textStack]];
    //
    ASInsetLayoutSpec *mainInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:mainStack];
    
    return mainInset;
}

#pragma mark - Actions

#pragma mark - Helpers

@end
