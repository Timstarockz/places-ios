//
//  TableHeader.m
//  Places
//
//  Created by Timothy Desir on 3/30/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "TableHeader.h"

// helpers
#import "FAHelpers.h"

@implementation TableHeader {
    UILabel *_textLabel;
    UIView *_bdiv, *_tdiv;
}

+ (TableHeader *)headerWithText:(NSString *)text andHeight:(CGFloat)height {
    TableHeader *header = [[TableHeader alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    [header setText:text];
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        
        
        // init text label
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _textLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_textLabel];
        
        // init bdiv
        _bdiv = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-DIV_HEIGHT, self.frame.size.width, DIV_HEIGHT)];
        _bdiv.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self.contentView addSubview:_bdiv];
        
        // init tdiv
        _tdiv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, DIV_HEIGHT)];
        _tdiv.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [self.contentView addSubview:_tdiv];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _bdiv.frame = CGRectMake(0, self.frame.size.height-DIV_HEIGHT, self.frame.size.width, DIV_HEIGHT);
    _tdiv.frame = CGRectMake(0, 0, self.frame.size.width, DIV_HEIGHT);
}

- (void)setText:(NSString *)text {
    if (text) {
        _textLabel.text = [text uppercaseString];
    }
}

@end
