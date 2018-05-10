//
//  FATabbedToolbar.m
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FATabbedToolbar.h"

// helpers
#import "FAHelpers.h"

#define FABARITEM_ICON_PADDING 30
#define FABARITEM_SMALL_ICON_PADDING 23

@implementation _FABarItemView

static CGFloat _iconPadding = FABARITEM_ICON_PADDING;

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = frame.size.width / 2;
        self.alpha = 0.85;
        
        // init iconView
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-_iconPadding, self.frame.size.height-_iconPadding)];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        //_iconView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:_iconView];
        
        // add gesture recogs
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.025;
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [UIView animateWithDuration:(_shrinking) ? FATT_SPRING_ANIMATION_DURATION : 0.0 delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_iconView.frame = CGRectMake((self.frame.size.width/2)-(self->_iconView.frame.size.width/2), (self.frame.size.height/2)-(self->_iconView.frame.size.height/2), self->_iconView.frame.size.width, self->_iconView.frame.size.height);
    } completion:nil];
}

#pragma mark - Methods

- (void)handleLongPress:(UIGestureRecognizer *)recog {
    if (recog.state == UIGestureRecognizerStateBegan) {
        [self mediumFeedback];
        [self highlight:true];
    }
    if (recog.state == UIGestureRecognizerStateEnded) {
        [self highlight:false];
        if (_target && _action) {
            [_target performSelectorOnMainThread:_action withObject:self waitUntilDone:false];
        }
    }
    if (recog.state == UIGestureRecognizerStateChanged) {
        [self highlight:false];
    }
    if (recog.state == UIGestureRecognizerStateFailed) {
        [self highlight:false];
    }
    if (recog.state == UIGestureRecognizerStateCancelled) {
        [self highlight:false];
    }
}

- (void)mediumFeedback {
    UIImpactFeedbackGenerator *tap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [tap prepare];
    [tap impactOccurred];
    [tap prepare];
    tap = nil;
}

- (void)highlight:(BOOL)flag {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = (flag) ? 0.8 : 1.0;
        self.transform = CGAffineTransformMakeScale((flag) ? 1.1 : 1.0, (flag) ? 1.1 : 1.0);
    }];
}

static BOOL _shrinking = false;
- (void)shrink:(BOOL)flag withX:(CGFloat)x andY:(CGFloat)y {
    _shrinking = true;
    _iconPadding = (flag) ? FABARITEM_SMALL_ICON_PADDING : FABARITEM_ICON_PADDING;
    [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(x, y, (flag) ? FATOOLBAR_ITEM_SIZE : FATABBARITEM_SIZE, (flag) ? FATOOLBAR_ITEM_SIZE : FATABBARITEM_SIZE);
        self.layer.cornerRadius = ((flag) ? FATOOLBAR_ITEM_SIZE : FATABBARITEM_SIZE) / 2;
        self->_iconView.frame = CGRectMake((self.frame.size.width/2)-(self->_iconView.frame.size.width/2), (self.frame.size.height/2)-(self->_iconView.frame.size.height/2), self.frame.size.width-_iconPadding, self.frame.size.height-_iconPadding);
    } completion:^(BOOL finished) {
        _shrinking = false;
    }];
}

@end


@implementation FABarItem

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor purpleColor];
    }
    
    return self;
}

- (instancetype)initWithIcon:(UIImage *)icon {
    self = [self init];
    if (self) {
        _icon = icon;
    }
    
    return self;
}

- (instancetype)initWithIcon:(UIImage *)icon andBackgroundColor:(UIColor *)color {
    self = [self initWithIcon:icon];
    if (self) {
        _backgroundColor = color;
    }
    
    return self;
}

#pragma mark - Interface

- (void)addTarget:(id)target withAction:(SEL)action {
    _target = target;
    _action = action;
}

@end


@implementation FATabbedToolbar {
    UIView *_div;
    UIControl *_tabBarView;
    __weak FABarItem *_selectedItem;
    UIView *_customView;
    _FABarItemView *_rightItem;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _mode = FATTTabBarMode;
        
        // init div
        _div = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, DIV_HEIGHT)];
        _div.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self.contentView addSubview:_div];
        
        // init tab bar view
        _tabBarView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tabBarView.backgroundColor = [UIColor clearColor];
        _tabBarView.layer.masksToBounds = false;
        [_tabBarView addTarget:self action:@selector(deselectItem) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_tabBarView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _div.frame = CGRectMake(0, 0, self.frame.size.width, DIV_HEIGHT);
    
    if (_mode == FATTTabBarMode) {
        _tabBarView.frame = CGRectMake((self.frame.size.width/2) - (_tabBarView.frame.size.width/2),
                                       (self.frame.size.height/2) - (_tabBarView.frame.size.height/2),
                                       _tabBarView.frame.size.width, _tabBarView.frame.size.height);
        
        // round top left and right corners of tab bar
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                             cornerRadii:CGSizeMake(FATABBAR_CORNER_RADIUS, FATABBAR_CORNER_RADIUS)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    } else {
        
    }
}

#pragma mark - Public Interface

- (void)setTabBarItems:(NSArray *)items {
    // clear the subviews if they exist
    if (_items) {
        for (id subview in _tabBarView.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    // create bubbles
    _items = items;
    int initx = 0;
    for (int i = 0; i < items.count; i++) {
        FABarItem *item = items[i];
        item.index = i;
        _FABarItemView *view = [[_FABarItemView alloc] initWithFrame:CGRectMake(initx, 0, FATABBARITEM_SIZE, FATABBARITEM_SIZE)];
        view.backgroundColor = item.backgroundColor;
        view.iconView.image = item.icon;
        view.target = self;
        view.action = @selector(selectedItem:);
        view.tag = i;
        [_tabBarView addSubview:view];
        initx = initx + FATABBARITEM_SIZE + FATTABBARITEM_INSIDE_PADDING;
        _tabBarView.frame = CGRectMake(0, 0, initx - FATTABBARITEM_INSIDE_PADDING, FATABBARITEM_SIZE);
    }
    
    // force layout
    [self layoutSubviews];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)flag {
    if (_mode == FATTTabBarMode) {
        [self _displayToolbarItem:_items[index] animated:flag];
    }
}

- (void)setRightBarItem:(FABarItem *)item animated:(BOOL)flag {
    if (_mode == FATTToolbarMode) {
        [self _presentRightBarItemFrom:item animated:flag];
    }
}

- (void)deselectItem {
    if (_mode == FATTToolbarMode) {
        _mode = FATTTabBarMode;
        
        [self mediumFeedback];
        [self _restoreBubbles];
        
        if ([(id)_tabBarDelegate respondsToSelector:@selector(tabBarDidDeselectItem:atIndex:)]) {
            [(id)_tabBarDelegate tabBarDidDeselectItem:_selectedItem atIndex:_selectedItem.index];
        }
        
        // remove toolbar items
        [self _removeRightItem];
        [self _removeCustomCenterView];
    }
}

#pragma mark - Private Interface

- (void)_displayToolbarItem:(FABarItem *)item animated:(BOOL)flag {
    _mode = FATTToolbarMode;
    _selectedItem = item;
    [self _collapseBubblesAtIndex:item.index animated:flag];
    
    // present the right toolbar item if there is one
    if (_selectedItem.rightItem) {
        [self _presentRightBarItemFrom:item animated:flag];
    }
    
    // present the custom center view if there is one
    if (_selectedItem.customCenterView) {
        [self _presentCustomCenterViewFrom:item animated:flag];
    }
}

- (void)selectedItem:(_FABarItemView *)item {
    [self _displayToolbarItem:_items[item.tag] animated:true];
    
    // only call delegate method when the user taps on the bar item and NOT when the setSelectedIndex: method is called
    if ([(id)_tabBarDelegate respondsToSelector:@selector(tabBarItem:selectedAtIndex:)]) {
        [(id)_tabBarDelegate tabBarItem:_items[item.tag] selectedAtIndex:item.tag];
    }
}

/// Animations

- (void)_collapseBubblesAtIndex:(NSInteger)index animated:(BOOL)flag {
    _FABarItemView *item = [_tabBarView viewWithTag:index];
    [UIView animateWithDuration:(flag) ? FATT_SPRING_ANIMATION_DURATION : 0.0 delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.layer.mask = nil;
        self.frame = CGRectMake(0, self.superview.frame.size.height-FATOOLBAR_HEIGHT, self.superview.frame.size.width, FATOOLBAR_HEIGHT);
        item.frame = CGRectMake(0, 0, FATABBARITEM_SIZE, FATABBARITEM_SIZE);
        for (_FABarItemView *barItem in self->_tabBarView.subviews) {
            barItem.userInteractionEnabled = false;
            [barItem shrink:true withX:0 andY:0];
            if (barItem.tag != index) {
                barItem.center = item.center;
                barItem.alpha = 0.0;
            }
        }
        self->_tabBarView.frame = CGRectMake(FATOOLBAR_ITEM_PADDING, (self.frame.size.height/2) - (FATOOLBAR_ITEM_SIZE/2), FATOOLBAR_ITEM_SIZE, FATOOLBAR_ITEM_SIZE);
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)_restoreBubbles {
    [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.superview.frame.size.height-FATABBAR_SIZE, self.superview.frame.size.width, FATABBAR_SIZE);
        int initx = 0;
        for (_FABarItemView *barItem in self->_tabBarView.subviews) {
            barItem.userInteractionEnabled = true;
            barItem.alpha = 1.0;
            [barItem shrink:false withX:initx andY:0];
            initx = initx + FATABBARITEM_SIZE + FATTABBARITEM_INSIDE_PADDING;
            self->_tabBarView.frame = CGRectMake(0, 0, initx - FATTABBARITEM_INSIDE_PADDING, FATABBARITEM_SIZE);
        }
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)_presentRightBarItemFrom:(FABarItem *)item animated:(BOOL)flag {
    if (_rightItem) {
        [_rightItem removeFromSuperview];
        _rightItem = nil;
    }
    
    _rightItem = [[_FABarItemView alloc] initWithFrame:CGRectMake(self.frame.size.width, (self.frame.size.height/2)-(FATABBARITEM_SIZE/2), FATABBARITEM_SIZE, FATABBARITEM_SIZE)];
    _rightItem.iconView.image = item.rightItem.icon;
    _rightItem.alpha = 0.0;
    if (item.rightItem.target && item.rightItem.action) {
        _rightItem.target = item.rightItem.target;
        _rightItem.action = item.rightItem.action;
    }
    [self.contentView addSubview:_rightItem];
    [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self->_rightItem shrink:true withX:self.frame.size.width-(FATOOLBAR_ITEM_SIZE)-(FATOOLBAR_ITEM_PADDING) andY:(self.frame.size.height/2)-(FATOOLBAR_ITEM_SIZE/2)];
        self->_rightItem.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self->_rightItem layoutSubviews];
    }];
}

- (void)_removeRightItem {
    if (_rightItem) {
        [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->_rightItem.frame = CGRectMake(self.frame.size.width, (self.frame.size.height/2)-(FATABBARITEM_SIZE/2), FATABBARITEM_SIZE, FATABBARITEM_SIZE);
            self->_rightItem.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self->_rightItem removeFromSuperview];
            self->_rightItem = nil;
            self->_selectedItem = nil;
        }];
    }
}

- (void)_presentCustomCenterViewFrom:(FABarItem *)item animated:(BOOL)flag {
    
}

- (void)_removeCustomCenterView {
    
}

///

- (void)mediumFeedback {
    UIImpactFeedbackGenerator *tap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [tap prepare];
    [tap impactOccurred];
    [tap prepare];
    tap = nil;
}

@end
