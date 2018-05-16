//
//  NewListHeaderNode.m
//  Places
//
//  Created by Timothy Desir on 5/15/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "NewListHeaderNode.h"
#import "PlaceNode.h"

@implementation NewListHeaderNode {
    ASImageNode *iconNode;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init icon node
        iconNode = [[ASImageNode alloc] init];
        iconNode.style.preferredSize = CGSizeMake(PLACE_ICON_SIZE, PLACE_ICON_SIZE);
        iconNode.clipsToBounds = true;
        iconNode.cornerRadius = PLACE_ICON_SIZE / 2;
        iconNode.image = [UIImage imageNamed:@"stupid"];
        
        // init title node
        _titleNode = [[ASEditableTextNode alloc] init];
        _titleNode.placeholderEnabled = true;
        _titleNode.attributedText = [[NSAttributedString alloc] initWithString:@"woo" attributes:[self titlePlaceholderFontAttributesWithColor:[UIColor darkGrayColor]]];
        _titleNode.attributedPlaceholderText = [[NSAttributedString alloc] initWithString:@"enter title..." attributes:[self titlePlaceholderFontAttributesWithColor:[UIColor lightGrayColor]]];
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

- (void)didLoad {
    [super didLoad];
    [_titleNode becomeFirstResponder];
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
    //
    _titleNode.style.minWidth = ASDimensionMake(@(fabs([UIScreen mainScreen].bounds.size.width-(PLACE_LEFT_RIGHT_PADDING*2)-(PLACE_HORI_DETAIL_PADDING*2)-(PLACE_ICON_SIZE))).integerValue);
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:12
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[iconNode, _titleNode]];
    //
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(PLACE_TOP_BOTTOM_PADDING,
                                                                         PLACE_LEFT_RIGHT_PADDING,
                                                                         PLACE_TOP_BOTTOM_PADDING,
                                                                         PLACE_LEFT_RIGHT_PADDING) child:mainStack];
}

#pragma mark - Actions

#pragma mark - Helpers

@end
