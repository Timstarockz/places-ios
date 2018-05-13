//
//  FAStatusBarTray.m
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FAStatusBarTray.h"

// views
#import "FATabbedToolbar.h"

// helpers
#import "FAHelpers.h"

@implementation FAStatusBarTray {
    UIView *_div;
    UIView *_accessoryView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        
        // init div
        _div = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-DIV_HEIGHT, self.frame.size.width, DIV_HEIGHT)];
        _div.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        _div.alpha = 0.0;
        [self.contentView addSubview:_div];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _div.frame = CGRectMake(0, self.frame.size.height-DIV_HEIGHT, self.frame.size.width, DIV_HEIGHT);
}

#pragma mark - Public Interface

- (void)showTrayWithView:(UIView *)view {
    if (view) {
        if (_accessoryView) {
            view.alpha = 0.0;
            view.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, view.frame.size.width, view.frame.size.height);
            view.autoresizingMask = UIViewContentModeBottom;
            [self.contentView addSubview:view];
            [self.contentView bringSubviewToFront:_div];
            
            [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION animations:^{
                self->_accessoryView.alpha = 0.0;
                view.alpha = 1.0;
                
                self.frame = CGRectMake(0, 0, self.frame.size.width, ([UIApplication sharedApplication].statusBarFrame.size.height + view.frame.size.height));
                self->_div.frame = CGRectMake(0, self.frame.size.height-DIV_HEIGHT, self.frame.size.width, DIV_HEIGHT);
            } completion:^(BOOL finished) {
                [self->_accessoryView removeFromSuperview];
                self->_accessoryView = nil;
                self->_accessoryView = view;
            }];
        } else {
            [_accessoryView removeFromSuperview];
            _accessoryView = nil;
            _accessoryView = view;
            _accessoryView.alpha = 0.0;
            _accessoryView.frame = CGRectMake(0, (-_accessoryView.frame.size.height) + [UIApplication sharedApplication].statusBarFrame.size.height, _accessoryView.frame.size.width, _accessoryView.frame.size.height);
            _accessoryView.autoresizingMask = UIViewContentModeBottom;
            [self.contentView addSubview:_accessoryView];
            [self.contentView bringSubviewToFront:_div];
            
            [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                self.frame = CGRectMake(0, 0, self.frame.size.width, ([UIApplication sharedApplication].statusBarFrame.size.height + self->_accessoryView.frame.size.height));
                self->_div.frame = CGRectMake(0, self.frame.size.height-DIV_HEIGHT, self.frame.size.width, DIV_HEIGHT);
                self->_accessoryView.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self->_accessoryView.frame.size.width, self->_accessoryView.frame.size.height);
                
                self->_div.alpha = 1.0;
                self->_accessoryView.alpha = 1.0;
            } completion:^(BOOL finished) {
                //
            }];
        }
    } else {
        [self dismissTray];
    }
}

- (void)dismissTray {
    if (_accessoryView) {
        [UIView animateWithDuration:FATT_SPRING_ANIMATION_DURATION delay:0 usingSpringWithDamping:FATT_SPRING_ANIMATION_DAMPING initialSpringVelocity:FATT_SPRING_ANIMATION_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
            self.frame = CGRectMake(0, 0, self.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height);
            self->_div.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, DIV_HEIGHT);
            self->_accessoryView.frame = CGRectMake(0, (-self->_accessoryView.frame.size.height)+[UIApplication sharedApplication].statusBarFrame.size.height, self->_accessoryView.frame.size.width, self->_accessoryView.frame.size.height);
            
            self->_div.alpha = 0.0;
            self->_accessoryView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self->_accessoryView removeFromSuperview];
            self->_accessoryView = nil;
        }];
    }
}

@end
