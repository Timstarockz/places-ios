//
//  PSBlankNode.m
//  Places
//
//  Created by Timothy Desir on 4/29/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PSBlankNode.h"

// helpers
#import "FAHelpers.h"

@implementation PSBlankNode {
    // loading state
    BOOL isLoading;
    ASTextNode *_loading;
    ASDisplayNode *spinnyNode;
    UIActivityIndicatorView *spinny;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        isLoading = false;
        self.backgroundColor = [UIColor whiteColor];
        
        // title
        _title = [[ASTextNode alloc] init];
        
        // message
        _message = [[ASTextNode alloc] init];
        
        // image
        _image = [[ASImageNode alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        
        // action
        _action = [[ASButtonNode alloc] init];
        
        // loading
        _loading = [[ASTextNode alloc] init];
        _loading.attributedText = [[NSAttributedString alloc] initWithString:@"Loading..." attributes:[self messageFontAttributes]];
        
        // spinny node
        spinnyNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            spin.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            spin.hidesWhenStopped = true;
            return spin;
        }];
        spinny = (UIActivityIndicatorView *)spinnyNode.view;
        
        
        /// default spacing
        _verticalSpacing = 10;
        
        /// default inset
        _contentInset = UIEdgeInsetsMake(30, 20, 30, 20);
        
        /// default layout
        _layoutOrder = @[_image, _title, _message, _action];
        
        
        ///
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)messageFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentCenter;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#6c6c6c"],
             NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    if (!isLoading) {
        //
        ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                               spacing:_verticalSpacing
                                                                        justifyContent:ASStackLayoutJustifyContentCenter
                                                                            alignItems:ASStackLayoutAlignItemsCenter
                                                                              children:_layoutOrder];
        //
        ASInsetLayoutSpec *mainInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:_contentInset child:mainStack];
        //
        
        return mainInset;
    } else {
        //
        ASStackLayoutSpec *loadingStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                  spacing:(_loading.attributedText.string.length > 0) ? 20 : 0
                                                                           justifyContent:ASStackLayoutJustifyContentCenter
                                                                               alignItems:ASStackLayoutAlignItemsCenter
                                                                                 children:@[spinnyNode, _loading]];
        //
        
        return loadingStack;
    }
}

#pragma mark - Actions

- (void)refreshUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionLayoutWithAnimation:false shouldMeasureAsync:false measurementCompletion:nil];
    });
}

- (void)showLoadingState:(BOOL)flag {
    [self showLoadingState:flag withText:@""];
}

- (void)showLoadingState:(BOOL)flag withText:(NSString *)text {
    isLoading = flag;
    _loading.attributedText = [[NSAttributedString alloc] initWithString:text attributes:[self messageFontAttributes]];
    self.userInteractionEnabled = true;
    self.alpha = 1.0;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (flag) {
            [self->spinny startAnimating];
        } else {
            [self->spinny stopAnimating];
        }
    });
    [self refreshUI];
}

- (void)hideNodeAnimated:(BOOL)animated {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        self.userInteractionEnabled = false;
    }];
}

#pragma mark - Helpers

- (void)setTitleText:(NSString *)titleText {
    _title.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", titleText]  attributes:[self messageFontAttributes]];
    [self refreshUI];
}

- (void)setMessageText:(NSString *)messageText {
    _message.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", messageText]  attributes:[self messageFontAttributes]];
    [self refreshUI];
}

- (void)setIconImage:(UIImage *)img {
    _image.image = img;
    [self refreshUI];
}

- (void)setLayoutOrder:(NSArray *)layout {
    _layoutOrder = layout;
    [self refreshUI];
}


@end
