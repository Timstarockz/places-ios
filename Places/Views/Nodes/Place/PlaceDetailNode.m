//
//  PlaceDetailNode.m
//  Places
//
//  Created by Timothy Desir on 4/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PlaceDetailNode.h"

// views
#import "FATabbedToolbar.h"

// helpers
#import "FAHelpers.h"

#define BUTTON_SIZE 40
#define PADDING 13

@implementation PlaceDetailNode {
    ASTextNode *titleNode;
    ASDisplayNode *buttonNode;
    _FABarItemView *_buttonView;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // init title node
        titleNode = [[ASTextNode alloc] init];
        titleNode.maximumNumberOfLines = 4;
        
        // init button node
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_buttonView = [[_FABarItemView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_SIZE, BUTTON_SIZE)];
            CGFloat itemSize = BUTTON_SIZE-18;
            self->_buttonView.iconView.frame = CGRectMake((self->_buttonView.frame.size.width/2)-(itemSize/2), (self->_buttonView.frame.size.height/2)-(itemSize/2), itemSize, itemSize);
            self->_buttonView.alpha = 1.0;
            self->_buttonView.layer.cornerRadius = BUTTON_SIZE / 2;
        });
        buttonNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            return self->_buttonView;
        }];
        buttonNode.style.preferredSize = CGSizeMake(BUTTON_SIZE, BUTTON_SIZE);
        
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
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    titleNode.style.maxWidth = ASDimensionMake(constrainedSize.max.width-(TABLE_HORI_PADDING * 3)-BUTTON_SIZE);
    //
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.style.flexGrow = true;
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:0
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[titleNode, spacer, buttonNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(PADDING, TABLE_HORI_PADDING, PADDING, TABLE_HORI_PADDING) child:mainStack];
}

#pragma mark - Actions

#pragma mark - Helpers

- (void)setText:(NSString *)text {
    if (text != nil) {
        titleNode.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[self titleFontAttributes]];
    }
}

- (void)setItem:(FABarItem *)item {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_buttonView.iconView.image = item.icon;
        self->_buttonView.backgroundColor = item.backgroundColor;
        if (item.target && item.action) {
            self->_buttonView.target = item.target;
            self->_buttonView.action = item.action;
        }
    });
}

@end
