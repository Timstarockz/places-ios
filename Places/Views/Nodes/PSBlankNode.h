//
//  PSBlankNode.h
//  Places
//
//  Created by Timothy Desir on 4/29/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface PSBlankNode : ASDisplayNode

@property (nonatomic, readonly) ASTextNode *title;
@property (nonatomic, readonly) ASTextNode *message;
@property (nonatomic, readonly) ASImageNode *image;
@property (nonatomic) ASButtonNode *action;

@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) CGFloat verticalSpacing;

@property (nonatomic) NSArray *layoutOrder;
/// default layout:
// [image,
//  title,
//  message,
//  action]

- (void)setTitleText:(NSString *)titleText;
- (void)setMessageText:(NSString *)messageText;
- (void)setIconImage:(UIImage *)img;

//
- (void)showLoadingState:(BOOL)flag;
- (void)showLoadingState:(BOOL)flag withText:(NSString *)text;

- (void)hideNodeAnimated:(BOOL)animated;

@end
