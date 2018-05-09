//
//  ASCustomSeparatorCellNode.h
//  Places
//
//  Created by Timothy Desir on 4/19/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

@import AsyncDisplayKit;

@interface ASCustomSeparatorCellNode : ASCellNode

- (void)showTopSeparator:(BOOL)flag;
- (void)showBottomSeparator:(BOOL)flag;

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset;
- (void)setSeparatorColor:(UIColor *)color;

@end
