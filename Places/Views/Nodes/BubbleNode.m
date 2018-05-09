//
//  BubbleNode.m
//  Places
//
//  Created by Timothy Desir on 4/9/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "BubbleNode.h"

// viwws
#import "FATabbedToolbar.h"

// helpers
#import "FAHelpers.h"


#define BUBBLE_SIZE 66


@implementation BubbleItem

+ (BubbleItem *)itemWithTitle:(NSString *)title andIcon:(UIImage *)icon andColor:(UIColor *)color {
    BubbleItem *item = [BubbleItem new];
    item.title = title;
    item.icon = icon;
    item.color = color;
    
    return item;
}

@end


@implementation BubbleNode {
    ASDisplayNode *_bubbleNode;
    _FABarItemView *_bubbleView;
    ASTextNode *_titleNode;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // bubble
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_bubbleView = [[_FABarItemView alloc] initWithFrame:CGRectMake(0, 0, BUBBLE_SIZE, BUBBLE_SIZE)];
            self->_bubbleView.backgroundColor = PLACEHOLDER_ORANGE;
            self->_bubbleView.iconView.image = [UIImage imageNamed:@"breakfast2_placecon"];
            self->_bubbleView.alpha = 1.0;
            self->_bubbleView.layer.cornerRadius = BUBBLE_SIZE / 2;
            self->_bubbleView.userInteractionEnabled = false;
        });
        _bubbleNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            return self->_bubbleView;
        }];
        _bubbleNode.style.preferredSize = CGSizeMake(BUBBLE_SIZE, BUBBLE_SIZE);
        
        // title
        _titleNode = [[ASTextNode alloc] init];
        _titleNode.maximumNumberOfLines = 1;
        
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentCenter;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#6c6c6c"],
             NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:5.5
                                            justifyContent:ASStackLayoutJustifyContentCenter
                                                alignItems:ASStackLayoutAlignItemsCenter
                                                  children:@[_bubbleNode,
                                                             _titleNode]];
}

#pragma mark - Actions

- (void)setBubble:(BubbleItem *)item {
    _titleNode.attributedText = [[NSAttributedString alloc] initWithString:item.title attributes:[self titleFontAttributes]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_bubbleView.iconView.image = item.icon;
        self->_bubbleView.backgroundColor = item.color;
    });
}

@end
