//
//  BubbleScrollerNode.h
//  Places
//
//  Created by Timothy Desir on 4/3/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "BubbleNode.h"

@protocol BubbleScrollerNodeDelegate;

@interface BubbleScrollerNode : ASCellNode <ASCollectionDelegate, ASCollectionDataSource>
@property (nonatomic) id<BubbleScrollerNodeDelegate> delegate;
- (void)setItems:(NSArray <BubbleItem *> *)items;
@end

@protocol BubbleScrollerNodeDelegate <NSObject>
@optional
- (void)bubbleScrollerDidSelectItem:(BubbleItem *)item atIndexPath:(NSIndexPath *)indexPath;
@end
