//
//  BubbleNode.h
//  Places
//
//  Created by Timothy Desir on 4/9/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface BubbleItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UIColor *color;

+ (BubbleItem *)itemWithTitle:(NSString *)title andIcon:(UIImage *)icon andColor:(UIColor *)color;

@end

//////////////////////////////////////////////////////////

@interface BubbleNode : ASCellNode
- (void)setBubble:(BubbleItem *)item;
@end
