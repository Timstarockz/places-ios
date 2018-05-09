//
//  PSInstagramViewer.m
//  Places
//
//  Created by Timothy Desir on 4/29/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "PSInstagramViewer.h"

@interface PSInstagramImageNode : ASCellNode
- (void)setImageURL:(NSURL *)url;
@end
@implementation PSInstagramImageNode {
    ASNetworkImageNode *image;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // init image
        image = [[ASNetworkImageNode alloc] init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        //
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    ASInsetLayoutSpec *mainInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) child:image];
    return mainInset;
}

#pragma mark - Actions

#pragma mark - Helpers

- (void)setImageURL:(NSURL *)url {
    [image setURL:url];
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////


@interface PSInstagramViewer (Internal) <ASCollectionDelegate, ASCollectionDataSource>
@end

@implementation PSInstagramViewer {
    ASCollectionNode *photoCollection;
    NSMutableArray *igImages;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // init collection view layout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        // init photo collection
        photoCollection = [[ASCollectionNode alloc] initWithCollectionViewLayout:layout];
        photoCollection.delegate = self;
        photoCollection.dataSource = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->photoCollection.view.pagingEnabled = true;
        });
        
        //
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

- (void)didLoad {
    [super didLoad];
}

#pragma mark - Fonts

#pragma mark - Layout

- (void)layout {
    [super layout];
    self.style.preferredSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    photoCollection.style.preferredSize = self.style.preferredSize;
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    mainStack.justifyContent = ASStackLayoutJustifyContentStart;
    mainStack.alignContent = ASStackLayoutAlignItemsCenter;
    mainStack.children = @[photoCollection];
    //
    return mainStack;
}

#pragma mark - Actions

- (void)getPhotosFromCoordinates:(CLLocationCoordinate2D)coo {
    [[InstagramEngine sharedEngine] getMediaAtLocation:coo withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        self->igImages = [NSMutableArray arrayWithArray:media];
        [self->photoCollection performBatchUpdates:^{
            [self->photoCollection reloadData];
        } completion:^(BOOL finished) {
            
        }];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        self->igImages = nil;
        [self->photoCollection performBatchUpdates:^{
            [self->photoCollection reloadData];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - Helpers

#pragma mark - ASCollectionNodeDelegate

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    if (igImages) {
        return igImages.count;
    }
    
    return 6;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath; {
    // default
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        PSInstagramImageNode *cell = [[PSInstagramImageNode alloc] init];
        cell.style.preferredSize = self.style.preferredSize;
        if (self->igImages) {
            InstagramMedia *photo = self->igImages[indexPath.row];
            [cell setImageURL:photo.standardResolutionImageURL];
        }
        return cell;
    };
    
    return cellNodeBlock;
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ASSizeRangeMake(self.style.preferredSize);
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

/// UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
