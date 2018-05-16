//
//  FANavBar.m
//  Places
//
//  Created by Timothy Desir on 4/11/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FANavBar.h"

// views
#import "FATabbedToolbar.h"

#define BACK_BUTTON_SIZE 40
#define BUTTON_PADDING 12

@interface FANavBar ()
- (void)_setBackButtonIcon:(UIImage *)icon;
@end

@implementation FANavBar {
    UILabel *_titleLabel;
    UIView *_customView;
    _FABarItemView *_rightItem;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // init back button
        
        // init title label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FANAVBAR_ITEM_SIZE, 0, self.frame.size.width-(FANAVBAR_ITEM_SIZE*2), self.frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"Title Label";
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_customView) {
        CGFloat bWid = FANAVBAR_ITEM_SIZE + BUTTON_PADDING;
        _customView.frame = CGRectMake(bWid, 0, self.frame.size.width-(bWid*2), self.frame.size.height);
    } else {
        _titleLabel.frame = CGRectMake(FANAVBAR_ITEM_SIZE, 0, self.frame.size.width-(FANAVBAR_ITEM_SIZE*2), self.frame.size.height);
    }
    
    if (_rightItem) {
        _rightItem.frame = CGRectMake(self.frame.size.width-(FANAVBAR_ITEM_SIZE)-BUTTON_PADDING, (self.frame.size.height/2)-(FANAVBAR_ITEM_SIZE/2), FANAVBAR_ITEM_SIZE, FANAVBAR_ITEM_SIZE);
    }
}

#pragma mark - Public Interface

- (void)setItem:(FANavigationItem *)item {
    if (item.title) {
        [self setTitle:item.title];
    } else {
        [self setCustomView:item.titleView];
    }
    [self setLeftItem:item.leftBarItem];
    [self setRightItem:item.rightBarItem];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
    [_customView removeFromSuperview];
    _customView = nil;
}

- (void)setCustomView:(UIView *)view {
    _titleLabel.hidden = true;
    _customView = view;
    [self addSubview:_customView];
    [self layoutSubviews];
}

- (void)setLeftItem:(FABarItem *)item {
    
}

- (void)setRightItem:(FABarItem *)item {
    if (_rightItem) {
        [_rightItem removeFromSuperview];
        _rightItem = nil;
    }
    
    CGFloat itemSize = FANAVBAR_ITEM_SIZE-5;
    _rightItem = [[_FABarItemView alloc] initWithFrame:CGRectMake(self.frame.size.width-(FANAVBAR_ITEM_SIZE)-BUTTON_PADDING, (self.frame.size.height/2)-(FANAVBAR_ITEM_SIZE/2), FANAVBAR_ITEM_SIZE, FANAVBAR_ITEM_SIZE)];
    _rightItem.iconView.frame = CGRectMake((_rightItem.frame.size.width/2)-(itemSize/2), (_rightItem.frame.size.height/2)-(itemSize/2), itemSize, itemSize);
    _rightItem.iconView.image = item.icon;
    if (item.target && item.action) {
        _rightItem.target = item.target;
        _rightItem.action = item.action;
    }
    [self addSubview:_rightItem];
}

- (void)setShowBackButton:(BOOL)flag {
    if (flag) {
        [self _showBackButton];
    } else {
        if (_backButton) {
            [_backButton removeFromSuperview];
            _backButton = nil;
        }
    }
}

- (void)setLeftItemEnabled:(BOOL)enabled animated:(BOOL)flag {
    
}

- (void)setRightItemEnabled:(BOOL)enabled animated:(BOOL)flag {
    [UIView animateWithDuration:(flag) ? FATT_ANIMATION_DURATION : 0.0 animations:^{
        self->_rightItem.userInteractionEnabled = enabled;
        self->_rightItem.alpha = (enabled) ? 1.0 : 0.5;
    }];
}

#pragma mark - Private Interface

- (void)_showBackButton {
    if (_backButton) {
        [_backButton removeFromSuperview];
        _backButton = nil;
    }
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    _backButton.alpha = 0.5;
    [_backButton setAdjustsImageWhenHighlighted:true];
    [_backButton setImage:[UIImage imageNamed:@"back_arrow_con"] forState:UIControlStateNormal];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -(_backButton.imageView.frame.origin.x * 2) + (BUTTON_PADDING * 2), 0, 0);
    [self addSubview:_backButton];
}

- (void)_setBackButtonIcon:(UIImage *)icon {
    [_backButton setImage:icon forState:UIControlStateNormal];
    _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -(_backButton.imageView.frame.origin.x * 2) + (BUTTON_PADDING * 2), 0, 0);
}

@end
