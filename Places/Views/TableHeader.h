//
//  TableHeader.h
//  Places
//
//  Created by Timothy Desir on 3/30/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeader : UIVisualEffectView

+ (TableHeader *)headerWithText:(NSString *)text andHeight:(CGFloat)height;

- (void)setText:(NSString *)text;

@end
