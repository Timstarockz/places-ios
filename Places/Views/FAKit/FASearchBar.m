//
//  FASearchBar.m
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FASearchBar.h"

// helpers
#import "FAHelpers.h"


#define _FASEARCHBAR_CELL_PADDING 8
#define _FASEARCHBAR_TEXT_PADDING 8
#define _FASEARCHBAR_CANCEL_WIDTH 55


@interface FASearchBar () <UITextFieldDelegate>
@end

@implementation FASearchBar {
    UIControl *_cellView;
    UITextField *_textField;
    UIImageView *_iconView;
    UIView *_rightDiv;
    UIButton *_rightButton;
    UIButton *_cancelButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isEditing = false;
        
        // init cell view
        _cellView = [[UIControl alloc] initWithFrame:CGRectMake(_FASEARCHBAR_CELL_PADDING, 6, self.frame.size.width-(_FASEARCHBAR_CELL_PADDING*2), FASEARCHBAR_HEIGHT - FASEARCHBAR_TEXTCELL_PADDING)];
        _cellView.backgroundColor = [UIColor colorWithWhite:0.80 alpha:0.5];
        _cellView.layer.masksToBounds = true;
        _cellView.layer.cornerRadius = 12;
        _cellView.autoresizesSubviews = true;
        [_cellView addTarget:self action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cellView];
        
        // init icon view
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, (_cellView.frame.size.height/2) - (15/2), 15, 15)];
        _iconView.image = [UIImage imageNamed:@"searchbar_con"];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [_cellView addSubview:_iconView];
        
        // init text field
        int icx = (_iconView.frame.origin.x + _iconView.frame.size.width);
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(icx + _FASEARCHBAR_TEXT_PADDING,
                                                                   (_cellView.frame.size.height/2)-18/2,
                                                                   (_cellView.frame.size.width-icx)-(_FASEARCHBAR_TEXT_PADDING*2),
                                                                   18)];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _textField.placeholder = @"Search Field";
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        [_cellView addSubview:_textField];
        
        // init cancel button
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(self.frame.size.width, _cellView.frame.origin.y, _FASEARCHBAR_CANCEL_WIDTH, _cellView.frame.size.height);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _cancelButton.alpha = 0.0;
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_cancelButton addTarget:self action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, FASEARCHBAR_HEIGHT);
    _iconView.frame = CGRectMake(18, (_cellView.frame.size.height/2) - (15/2), 15, 15);
    if (!_isEditing) {
        _cellView.frame = CGRectMake(_FASEARCHBAR_CELL_PADDING, 6, self.frame.size.width-(_FASEARCHBAR_CELL_PADDING*2), FASEARCHBAR_HEIGHT - FASEARCHBAR_TEXTCELL_PADDING);
    } else {
        _cellView.frame = CGRectMake(_FASEARCHBAR_CELL_PADDING, 6, self.frame.size.width-(_FASEARCHBAR_CELL_PADDING*3)-_FASEARCHBAR_CANCEL_WIDTH, FASEARCHBAR_HEIGHT - FASEARCHBAR_TEXTCELL_PADDING);
        _cancelButton.frame = CGRectMake((_cellView.frame.origin.x+_cellView.frame.size.width)+_FASEARCHBAR_CELL_PADDING, _cellView.frame.origin.y, _FASEARCHBAR_CANCEL_WIDTH, _cellView.frame.size.height);
    }
}

#pragma mark - Public Interface

- (void)setPlaceholder:(NSString *)placeholder {
    _textField.placeholder = placeholder;
}

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)setIcon:(UIImage *)icon {
    _iconView.image = icon;
}

- (void)becomeFirstResponder {
    [_textField becomeFirstResponder];
    _isEditing = true;
}

- (void)resignFirstResponder {
    [_textField resignFirstResponder];
    [self mediumFeedback];
    [self _showCancelButton:false];
    _isEditing = false;
}

#pragma mark - Private Interface

- (void)_showCancelButton:(BOOL)flag {
    if (flag) {
        // begin cancel button animation
        [self mediumFeedback];
        [UIView animateWithDuration:0.2 animations:^{
            self->_cellView.frame = CGRectMake(_FASEARCHBAR_CELL_PADDING, 6, self.frame.size.width-(_FASEARCHBAR_CELL_PADDING*3)-_FASEARCHBAR_CANCEL_WIDTH, FASEARCHBAR_HEIGHT - FASEARCHBAR_TEXTCELL_PADDING);
            self->_cancelButton.frame = CGRectMake((self->_cellView.frame.origin.x+self->_cellView.frame.size.width)+_FASEARCHBAR_CELL_PADDING, self->_cellView.frame.origin.y, _FASEARCHBAR_CANCEL_WIDTH, self->_cellView.frame.size.height);
            self->_cancelButton.alpha = 1.0;
        }];
    } else {
        // hide cancel button
        [UIView animateWithDuration:0.2 animations:^{
            self->_cellView.frame = CGRectMake(_FASEARCHBAR_CELL_PADDING, 6, self.frame.size.width-(_FASEARCHBAR_CELL_PADDING*2), FASEARCHBAR_HEIGHT - FASEARCHBAR_TEXTCELL_PADDING);
            self->_cancelButton.frame = CGRectMake(self.frame.size.width, self->_cellView.frame.origin.y, _FASEARCHBAR_CANCEL_WIDTH, self->_cellView.frame.size.height);
            self->_cancelButton.alpha = 0.0;
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _isEditing = true;
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self _showCancelButton:true];
    if ([(id)_delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]) {
        __weak FASearchBar *sb = self;
        [(id)_delegate searchBarDidBeginEditing:sb];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _isEditing = false;
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self resignFirstResponder];
    if ([(id)_delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
        __weak FASearchBar *sb = self;
        [(id)_delegate searchBarDidEndEditing:sb];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    [self resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    _text = textField.text;
    if ([(id)_delegate respondsToSelector:@selector(searchBarDidChangeCharacters:)]) {
        __weak FASearchBar *sb = self;
        [(id)_delegate searchBarDidChangeCharacters:sb];
    }
    
    return true;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([(id)_delegate respondsToSelector:@selector(searchBarDidReturn:)]) {
        __weak FASearchBar *sb = self;
        [(id)_delegate searchBarDidReturn:sb];
    }
    
    return true;
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
