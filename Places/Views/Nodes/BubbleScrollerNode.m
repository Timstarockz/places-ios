//
//  BubbleScrollerNode.m
//  Places
//
//  Created by Timothy Desir on 4/3/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "BubbleScrollerNode.h"

// viwws
#import "BubbleNode.h"
#import "FATabbedToolbar.h"

// helpers
#import "FAHelpers.h"


@implementation BubbleScrollerNode {
    ASCollectionNode *_collectionNode;
    NSArray *_bubbles;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // init collection node
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        _collectionNode.delegate = self;
        _collectionNode.dataSource = self;
        _collectionNode.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
        
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
             NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
    _collectionNode.view.showsVerticalScrollIndicator = false;
    _collectionNode.view.showsHorizontalScrollIndicator = false;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    _collectionNode.style.preferredSize = CGSizeMake(constrainedSize.min.width, 100);
    //
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 0, 8, 0) child:_collectionNode];
}


#pragma mark - Actions

- (void)setItems:(NSArray <BubbleItem *> *)items; {
    _bubbles = items;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_collectionNode reloadData];
    });
}

#pragma mark - Collection Node Delegate/Data Source

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return _bubbles.count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        BubbleNode *bub = [[BubbleNode alloc] init];
        [bub setBubble:self->_bubbles[indexPath.row]];
        return bub;
    };
    return cellNodeBlock;
}


- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [(id)_delegate respondsToSelector:@selector(bubbleScrollerDidSelectItem:atIndexPath:)]) {
        [(id)_delegate bubbleScrollerDidSelectItem:_bubbles[indexPath.row] atIndexPath:indexPath];
    }
}

@end
