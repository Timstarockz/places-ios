//
//  FAVisualEffectButton.m
//  Places
//
//  Created by Timothy Desir on 4/11/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import "FAVisualEffectButton.h"

@implementation FAVisualEffectButton {
    id _target;
    SEL _action;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        self.layer.masksToBounds = true;
        
        // add gesture recogs
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.025;
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

#pragma mark - Public Interface

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    _target = target;
    _action = action;
}

- (void)removeTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents {
    _target = nil;
    _action = nil;
}

- (void)highlight:(BOOL)flag {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = (flag) ? 0.8 : 1.0;
        //self.transform = CGAffineTransformMakeScale((flag) ? 1.1 : 1.0, (flag) ? 1.1 : 1.0);
    }];
}

#pragma mark - Helpers

- (void)mediumFeedback {
    UIImpactFeedbackGenerator *tap = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [tap prepare];
    [tap impactOccurred];
    [tap prepare];
    tap = nil;
}

#pragma mark - Gesture Recognizers

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

@end
