//
//  _OKOnboardingPageLayouts.m
//  Places
//
//  Created by Timothy Desir on 5/18/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "_OKOnboardingPageLayouts.h"
#import "_OKButton.h"

ASLayoutSpec *_listItemPageLayout(ASTextNode *title, NSArray *items, _OKButton *nextButton) {
    ASStackLayoutSpec *_titleStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:0
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStart
                                                                            children:@[title]];
    ASStackLayoutSpec *_infoItemsStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:30
                                                                          justifyContent:ASStackLayoutJustifyContentCenter
                                                                              alignItems:ASStackLayoutAlignItemsStart
                                                                                children:items];
    ASStackLayoutSpec *buttonStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:0
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsCenter
                                                                            children:@[nextButton]];
    buttonStack.style.flexBasis = ASDimensionMake(@"20%");
    buttonStack.style.flexGrow = true;
    buttonStack.style.flexShrink = true;
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:35
                                                                    justifyContent:ASStackLayoutJustifyContentCenter
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:@[_titleStack,
                                                                                     _infoItemsStack]];
    mainStack.style.flexBasis = ASDimensionMake(@"80%");
    //
    ASStackLayoutSpec *stack = [ASStackLayoutSpec verticalStackLayoutSpec];
    stack.children = @[mainStack,
                       buttonStack];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(40, 30, 0, 30) child:stack];
}
