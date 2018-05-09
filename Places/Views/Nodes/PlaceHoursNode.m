//
//  PlaceHoursNode.m
//  Places
//
//  Created by Timothy Desir on 4/19/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "PlaceHoursNode.h"

// helpers
#import "FAHelpers.h"


@interface PlaceHoursHeaderNode : ASDisplayNode
- (void)setShowingAll:(BOOL)showingAll;
- (void)addTarget:(id)targ withSelector:(SEL)sel;
@property (readonly) BOOL showing;
@end

@implementation PlaceHoursHeaderNode {
    ASTextNode *hoursNode;
    ASButtonNode *toggleButtonNode;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // init hours node
        hoursNode = [[ASTextNode alloc] init];
        hoursNode.maximumNumberOfLines = 1;
        hoursNode.attributedText = [[NSAttributedString alloc] initWithString:@"Open: 11AM - 3AM" attributes:[self titleFontAttributes]];
        
        // init toggle button node
        toggleButtonNode = [[ASButtonNode alloc] init];
        [self setShowingAll:false];
        
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
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium],
             NSParagraphStyleAttributeName: pstyle};
}

- (NSDictionary *)buttonTitleFontAttributes {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSTextAlignmentRight;
    
    return @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#6c6c6c"],
             NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.style.flexGrow = true;
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    mainStack.justifyContent = ASStackLayoutJustifyContentStart;
    mainStack.alignItems = ASStackLayoutAlignItemsCenter;
    mainStack.children = @[hoursNode, spacer, toggleButtonNode];
    //
    return mainStack;
}

#pragma mark - Actions

- (void)setShowingAll:(BOOL)showingAll {
    _showing = showingAll;
    if (showingAll) {
        toggleButtonNode.titleNode.attributedText = [[NSAttributedString alloc] initWithString:@"show today" attributes:[self buttonTitleFontAttributes]];
    } else {
        toggleButtonNode.titleNode.attributedText = [[NSAttributedString alloc] initWithString:@"show all" attributes:[self buttonTitleFontAttributes]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionLayoutWithAnimation:true shouldMeasureAsync:false measurementCompletion:nil];
    });
}

- (void)addTarget:(id)targ withSelector:(SEL)sel {
    [toggleButtonNode addTarget:targ action:sel forControlEvents:ASControlNodeEventTouchUpInside];
}

#pragma mark - Helpers

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////

@interface PlaceDayNode : ASDisplayNode
- (void)setDay:(NSString *)day;
- (void)setHours:(NSString *)hours;

@property (nonatomic) BOOL selected;
@end

@implementation PlaceDayNode {
    ASTextNode *dayNode;
    ASTextNode *hoursNode;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // init day node
        dayNode = [[ASTextNode alloc] init];
        dayNode.maximumNumberOfLines = 1;
        
        // init hours node
        hoursNode = [[ASTextNode alloc] init];
        hoursNode.maximumNumberOfLines = 1;
        
        //
        self.style.alignSelf = ASStackLayoutAlignSelfStretch;
        self.automaticallyManagesSubnodes = true;
    }
    
    return self;
}

#pragma mark - Fonts

- (NSDictionary *)textFontAttributesWithAlignment:(NSTextAlignment)alignment selected:(BOOL)selected {
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = alignment;
    
    return @{NSForegroundColorAttributeName: (selected) ? [UIColor blackColor] : [UIColor lightGrayColor],
             NSFontAttributeName: [UIFont systemFontOfSize:(selected) ? 17 : 16 weight:(selected) ? UIFontWeightSemibold : UIFontWeightRegular],
             NSParagraphStyleAttributeName: pstyle};
}

#pragma mark - Layout

- (void)layout {
    [super layout];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    //
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.style.flexGrow = true;
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    mainStack.justifyContent = ASStackLayoutJustifyContentStart;
    mainStack.alignItems = ASStackLayoutAlignItemsCenter;
    mainStack.children = @[dayNode, spacer, hoursNode];
    //
    return mainStack;
}

#pragma mark - Actions

#pragma mark - Helpers

- (void)setSelected:(BOOL)selected {
    dayNode.attributedText = [[NSAttributedString alloc] initWithString:dayNode.attributedText.string attributes:[self textFontAttributesWithAlignment:NSTextAlignmentLeft selected:selected]];
    hoursNode.attributedText = [[NSAttributedString alloc] initWithString:hoursNode.attributedText.string attributes:[self textFontAttributesWithAlignment:NSTextAlignmentRight selected:selected]];
}

- (void)setDay:(NSString *)day {
    dayNode.attributedText = [[NSAttributedString alloc] initWithString:day attributes:[self textFontAttributesWithAlignment:NSTextAlignmentLeft selected:false]];
}

- (void)setHours:(NSString *)hours {
    hoursNode.attributedText = [[NSAttributedString alloc] initWithString:hours attributes:[self textFontAttributesWithAlignment:NSTextAlignmentRight selected:false]];
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////


#define DAYS @[@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday"]


@implementation PlaceHoursNode {
    PlaceHoursHeaderNode *headerNode;
    NSMutableArray *_dayNodes;
    NSMutableArray *_mainChildren;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        // init header node
        headerNode = [[PlaceHoursHeaderNode alloc] init];
        [headerNode addTarget:self withSelector:@selector(toggleAllDays)];
        
        //
        _dayNodes = [self dayNodesFromDayStrings:DAYS];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    ASStackLayoutSpec *daysStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                           spacing:4
                                                                    justifyContent:ASStackLayoutJustifyContentStart
                                                                        alignItems:ASStackLayoutAlignItemsStart
                                                                          children:_dayNodes];
    //
    ASStackLayoutSpec *mainStack = [ASStackLayoutSpec verticalStackLayoutSpec];
    mainStack.justifyContent = ASStackLayoutJustifyContentStart;
    mainStack.alignContent = ASStackLayoutAlignItemsCenter;
    mainStack.spacing = HOURS_VERT_SPACING;
    mainStack.children = @[headerNode,
                           (headerNode.showing) ? daysStack : [[ASLayoutSpec alloc] init]];
    //
    ASInsetLayoutSpec *mainInset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(HOURS_VERT_SPACING, TABLE_HORI_PADDING, (headerNode.showing) ? HOURS_VERT_SPACING : 0, TABLE_HORI_PADDING) child:mainStack];
    //
    return mainInset;
}

#pragma mark - Layout Transition Animations

- (void)animateLayoutTransition:(id <ASContextTransitioning>)context
{
    /// Get subnodes
    __block NSArray *insertedNodes = context.insertedSubnodes;
    __block NSArray *removedNodes = context.removedSubnodes;
    
    /// Do Animation
    headerNode.userInteractionEnabled = false;
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        // show "insertedNodes"
        for (ASDisplayNode *hiNode in insertedNodes) {
            [hiNode setAlpha:1.0];
        }
        // hide "removedSubnodes"
        for (ASDisplayNode *byeNode in removedNodes) {
            [byeNode setAlpha:0.0];
        }
    } completion:^(BOOL finished) {
        self->headerNode.userInteractionEnabled = true;
        [context completeTransition:finished];
        [self setNeedsLayout];
    }];
}

#pragma mark - Actions

- (void)toggleAllDays {
    [headerNode setShowingAll:!headerNode.showing];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionLayoutWithAnimation:true shouldMeasureAsync:false measurementCompletion:nil];
    });
}

- (void)_showDays {
    _dayNodes = [self dayNodesFromDayStrings:DAYS];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionLayoutWithAnimation:true shouldMeasureAsync:false measurementCompletion:nil];
    });
}

#pragma mark - Helpers

- (NSMutableArray <PlaceDayNode *> *)dayNodesFromDayStrings:(NSArray *)days {
    NSMutableArray *ds = [NSMutableArray new];
    for (NSString *day in days) {
        PlaceDayNode *dayNode = [[PlaceDayNode alloc] init];
        [dayNode setDay:[day capitalizedString]];
        [dayNode setHours:@"11AM - 3AM"];
        if ([days indexOfObject:day] == 1) {
            [dayNode setSelected:true];
        }
        [ds addObject:dayNode];
    }
    return ds;
}


@end
