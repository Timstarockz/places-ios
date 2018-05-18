//
//  OKInfoItem.h
//  Places
//
//  Created by Timothy Desir on 5/16/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage, UIColor;

@interface OKInfoItem : NSObject

@property (nonatomic) UIImage *icon;
@property (nonatomic) UIColor *iconColor;

@property (nonatomic) NSAttributedString *title;
@property (nonatomic) NSAttributedString *subtitle;
@property (nonatomic) NSAttributedString *body;

@end
