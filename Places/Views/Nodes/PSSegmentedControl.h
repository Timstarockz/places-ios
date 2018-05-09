//
//  PSSegmentedControl.h
//  Places
//
//  Created by Timothy Desir on 4/19/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "ASCustomSeparatorCellNode.h"

#define PSSEG_CORNER_RADIUS 10
#define SEG_HEIGHT 77
#define SEG_ICON_SIZE 35

@interface PSSegment : NSObject

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic) UIImage *icon;

@property (nullable, nonatomic, readonly) id target;
@property (nullable, nonatomic, readonly) SEL selector;

+ (PSSegment *_Nullable)segmentWithTitle:(NSString *_Nullable)title andIcon:(UIImage *_Nullable)icon;
+ (PSSegment *_Nullable)segmentWithTitle:(NSString *_Nullable)title andIcon:(UIImage *_Nullable)icon withTarget:(id _Nullable)target andSelector:(SEL _Nullable)sel;

- (void)addTarget:(id _Nullable)target withSelector:(SEL _Nullable)sel;

@end

@interface PSSegmentedControl : ASCustomSeparatorCellNode

@property (nullable, nonatomic, readonly) NSArray <PSSegment *> *segments;
- (void)setSegments:(NSArray <PSSegment *> *_Nullable)segments;

- (void)setLoading:(BOOL)loading atIndex:(NSInteger)index;

- (void)addSegment:(PSSegment *_Nullable)segment atIndex:(NSInteger)index;
- (void)replaceSegmentAtIndex:(NSInteger)index withSegment:(PSSegment *_Nullable)segment;
- (void)removeSegmentAtIndex:(NSInteger)index;

@end
