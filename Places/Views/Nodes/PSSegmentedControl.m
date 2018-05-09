//
//  PSSegmentedControl.m
//  Places
//
//  Created by Timothy Desir on 4/19/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PSSegmentedControl.h"

// helpers
#import "FAHelpers.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PSSegment

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

+ (PSSegment *_Nullable)segmentWithTitle:(NSString *_Nullable)title andIcon:(UIImage *_Nullable)icon {
    return [PSSegment segmentWithTitle:title andIcon:icon withTarget:nil andSelector:nil];
}

+ (PSSegment *_Nullable)segmentWithTitle:(NSString *_Nullable)title andIcon:(UIImage *_Nullable)icon withTarget:(id _Nullable)target andSelector:(SEL _Nullable)sel {
    PSSegment *seg = [[PSSegment alloc] init];
    seg.title = title;
    seg.icon = icon;
    [seg addTarget:target withSelector:sel];
    return seg;
}

- (void)addTarget:(id _Nullable )target withSelector:(SEL _Nullable)sel {
    _target = target;
    _selector = sel;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface _PSSegmentedView : ASControlNode
- (void)setIcon:(UIImage *)icon;
- (void)setTitle:(NSString *)title;

- (void)setLoading:(BOOL)flag;

- (void)setIsFirst;
- (void)setIsLast;
- (void)setDefault;
@end
@implementation _PSSegmentedView {
    ASDisplayNode *spinnyNode;
    UIActivityIndicatorView *_spinny;
    
    ASImageNode *iconNode;
    ASTextNode *titleNode;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = true;
        self.clipsToBounds = true;
        self.backgroundColor = PLACEHOLDER_DEFAULT_GREY;
        
        // init icon node
        iconNode = [[ASImageNode alloc] init];
        iconNode.style.preferredSize = CGSizeMake(SEG_ICON_SIZE, SEG_ICON_SIZE);
        
        // init title node
        titleNode = [[ASTextNode alloc] init];
        titleNode.maximumNumberOfLines = 2;
        
        // init spinny
        spinnyNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            spin.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            spin.hidesWhenStopped = false;
            spin.alpha = 0.0;
            [spin startAnimating];
            return spin;
        }];
        _spinny = (UIActivityIndicatorView *)spinnyNode.view;
        [self addSubnode:spinnyNode];
        
        //
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)titleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentCenter;
    
    return @{NSForegroundColorAttributeName: [UIColor whiteColor],
             NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
    _spinny.frame = CGRectMake((self.frame.size.width/2)-(20/2), (self.frame.size.height/2)-(20/2), 20, 20);
    [self.view bringSubviewToFront:_spinny];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:4
                                                                    justifyContent:ASStackLayoutJustifyContentCenter
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:@[iconNode,
                                                                                     titleNode]];
    return mainStack;
}

#pragma mark - Actions

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        [self mediumFeedback];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = (highlighted) ? 0.8 : 1.0;
        //self.view.transform = CGAffineTransformMakeScale((highlighted) ? 1.1 : 1.0, (highlighted) ? 1.1 : 1.0);
    }];
}

#pragma mark - Helpers

- (void)setIcon:(UIImage *)icon {
    iconNode.image = icon;
}

- (void)setTitle:(NSString *)title {
    titleNode.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[self titleFontAttributes]];
}

- (void)setLoading:(BOOL)flag {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (flag) {
            [self setUserInteractionEnabled:false];
            [self->_spinny startAnimating];
        } else {
            [self setUserInteractionEnabled:true];
            [self->_spinny stopAnimating];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self->iconNode.view.alpha = (flag) ? 0.0 : 1.0;
            self->titleNode.view.alpha = (flag) ? 0.0 : 1.0;
            self->_spinny.alpha = (flag) ? 1.0 : 0.0;
        }];
    });
}

- (void)setIsFirst {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.layer.cornerRadius = PSSEG_CORNER_RADIUS;
        self.layer.maskedCorners = (kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner);
    });
}

- (void)setIsLast {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.layer.cornerRadius = PSSEG_CORNER_RADIUS;
        self.layer.maskedCorners = (kCALayerMaxXMaxYCorner | kCALayerMaxXMinYCorner);
        [self setLoading:true];
    });
}

- (void)setDefault {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.layer.cornerRadius = 0;
    });
}

- (void)mediumFeedback {
    UIImpactFeedbackGenerator *tap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [tap prepare];
    [tap impactOccurred];
    [tap prepare];
    tap = nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////

#define SEG_PADDING (TABLE_HORI_PADDING-3)

@implementation PSSegmentedControl {
    NSMutableArray <_PSSegmentedView *> *_segmentViews;
    ASDisplayNode *spacerNode;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.style.minHeight = ASDimensionMake(SEG_HEIGHT+SEG_PADDING);
        self.style.maxHeight = ASDimensionMake(SEG_HEIGHT+SEG_PADDING);
        [self showTopSeparator:false];
        [self showBottomSeparator:false];
        
        // init spacer node
        spacerNode = [[ASDisplayNode alloc] init];
        spacerNode.style.minHeight = ASDimensionMake(SEG_PADDING);
        spacerNode.style.maxHeight = ASDimensionMake(SEG_PADDING);
        spacerNode.style.minWidth = ASDimensionMake(1);
        spacerNode.style.maxWidth = ASDimensionMake(1);
        spacerNode.backgroundColor = [UIColor clearColor];
        
        //
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
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                           spacing:1
                                                                    justifyContent:ASStackLayoutJustifyContentCenter
                                                                        alignItems:ASStackLayoutAlignItemsCenter
                                                                          children:_segmentViews];
    //
    ASStackLayoutSpec *secStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:0
                                            justifyContent:ASStackLayoutJustifyContentCenter
                                                alignItems:ASStackLayoutAlignItemsCenter
                                                  children:@[mainStack, spacerNode]];
    //
    ASInsetLayoutSpec *mainInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, SEG_PADDING, 0, SEG_PADDING) child:secStack];
    //
    return mainInset;
}

#pragma mark - Actions

- (void)setSegments:(NSArray <PSSegment *> *_Nullable)segments {
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_segments = segments;
        self->_segmentViews = [NSMutableArray new];
        
        NSUInteger count = self->_segments.count;
        for (PSSegment *segment in self->_segments) {
            NSUInteger index = [self->_segments indexOfObject:segment];
            
            _PSSegmentedView *segV = [self segmentViewFromObject:segment];
            segV.view.tag = index;
            segV.style.minHeight = ASDimensionMake(SEG_HEIGHT);
            segV.style.maxHeight = ASDimensionMake(SEG_HEIGHT);
            segV.style.minWidth = ASDimensionMake((([UIScreen mainScreen].bounds.size.width)-(SEG_PADDING*(count-1)))/count);
            segV.style.maxWidth = ASDimensionMake((([UIScreen mainScreen].bounds.size.width)-(SEG_PADDING*(count-1)))/count);
            if (index == 0) {
                [segV setIsFirst];
            } else if (index == self->_segments.count-1) {
                [segV setIsLast];
            }
            
            [self->_segmentViews addObject:segV];
        }
        
        // refresh layout
        [self transitionLayoutWithAnimation:false shouldMeasureAsync:false measurementCompletion:nil];
    });
}

- (void)setLoading:(BOOL)loading atIndex:(NSInteger)index {
    
}

- (void)addSegment:(PSSegment *_Nullable)segment atIndex:(NSInteger)index {
    NSMutableArray *segs = [NSMutableArray arrayWithArray:_segments];
    _PSSegmentedView *segV = [self segmentViewFromObject:segment];
    [_segmentViews insertObject:segV atIndex:index];
    [segs replaceObjectAtIndex:index withObject:segment];
    _segments = segs;
}

- (void)replaceSegmentAtIndex:(NSInteger)index withSegment:(PSSegment *_Nullable)segment {
    NSMutableArray *segs = [NSMutableArray arrayWithArray:_segments];
    _PSSegmentedView *segV = [self segmentViewFromObject:segment];
    if (index == 0) {
        [segV setIsFirst];
        _PSSegmentedView *oldf = [self->_segmentViews objectAtIndex:0];
        [oldf setDefault];
    } else if (index == self->_segments.count-1) {
        [segV setIsLast];
    }
    
    [self->_segmentViews replaceObjectAtIndex:index withObject:segV];
    [segs replaceObjectAtIndex:index withObject:segment];
    _segments = segs;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionLayoutWithAnimation:false shouldMeasureAsync:false measurementCompletion:nil];
    });
}

- (void)removeSegmentAtIndex:(NSInteger)index {
    [_segmentViews removeObjectAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionLayoutWithAnimation:false shouldMeasureAsync:false measurementCompletion:nil];
    });
}

#pragma mark - Helpers

- (_PSSegmentedView *)segmentViewFromObject:(PSSegment *)segment {
    _PSSegmentedView *seg = [[_PSSegmentedView alloc] init];
    [seg setIcon:segment.icon];
    [seg setTitle:segment.title];
    if (segment.target && segment.selector) {
        [seg addTarget:segment.target action:segment.selector forControlEvents:ASControlNodeEventTouchUpInside];
    }
    
    return seg;
}

@end
