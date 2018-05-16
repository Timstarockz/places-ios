//
//  FALocationButton.m
//  Places
//
//  Created by Timothy Desir on 4/10/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FALocationButton.h"

// helpers
#import "FAHelpers.h"

#define ICON_PADDING 12

@implementation FALocationButton {
    UIActivityIndicatorView *_spinny;
    UIImageView *_iconView;
    UILabel *_name;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 12;
        self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.7].CGColor;
        self.layer.borderWidth = DIV_HEIGHT;
        
        // init icon view
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(ICON_PADDING/1.5, (self.frame.size.height/2)-((self.frame.size.height-ICON_PADDING)/2), self.frame.size.height-ICON_PADDING, self.frame.size.height-ICON_PADDING)];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.image = [UIImage imageNamed:@"location_arrow_on"];
        [self.contentView addSubview:_iconView];
        
        // init name
        _name = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.frame.origin.x+(ICON_PADDING*2), 0, (self.frame.size.width-self.frame.size.height)-ICON_PADDING, self.frame.size.height)];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        _name.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [self.contentView addSubview:_name];
    }
    
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconView.frame = CGRectMake(ICON_PADDING/1.5, (self.frame.size.height/2)-((self.frame.size.height-ICON_PADDING)/2), self.frame.size.height-ICON_PADDING, self.frame.size.height-ICON_PADDING);
    _name.frame = CGRectMake(_iconView.frame.origin.x+(ICON_PADDING*2), 0, (self.frame.size.width-self.frame.size.height)-ICON_PADDING, self.frame.size.height);
}

#pragma mark - Interface

- (void)showActivityIndicator:(BOOL)flag {
    
}

- (void)setTitle:(NSString *)title animated:(BOOL)flag {
    _name.text = title;
}

@end
