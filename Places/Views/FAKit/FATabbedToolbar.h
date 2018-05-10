//
//  FATabbedToolbar.h
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FATT_ANIMATION_DURATION 0.2

#define FATT_SPRING_ANIMATION_DURATION 0.3
#define FATT_SPRING_ANIMATION_DAMPING 0.8
#define FATT_SPRING_ANIMATION_VELOCITY 0.8

#define FATABBAR_SIZE (([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom < 0) ? 99 : 99 + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom)
#define FATABBARITEM_SIZE 60
#define FATABBAR_CORNER_RADIUS 12
#define FATABBARITEM_PADDING FATABBARITEM_SIZE - 10
#define FATTABBARITEM_INSIDE_PADDING 40
#define FATTABBARITEM_OUTSIDE_PADDING 30

#define FATOOLBAR_HEIGHT (([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom < 0) ? 66 : 66 + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom)
#define FATOOLBAR_ITEM_SIZE (FATABBARITEM_SIZE-18)
#define FATOOLBAR_ITEM_PADDING 12

typedef NS_ENUM(NSUInteger, FATabbedToolbarMode) {
    FATTTabBarMode,
    FATTToolbarMode,
};

@interface _FABarItemView : UIView
@property (nonatomic) UIImageView *iconView;

@property (nonatomic) id target;
@property (nonatomic) SEL action;

- (void)shrink:(BOOL)flag withX:(CGFloat)x andY:(CGFloat)y;
@end

@interface FABarItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) UIImage *icon;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) NSUInteger index;

@property (nonatomic, readonly) id target;
@property (nonatomic, readonly) SEL action;

@property (nonatomic) UIView *customCenterView;
@property (nonatomic) FABarItem *rightItem;

- (void)addTarget:(id)target withAction:(SEL)action;

- (instancetype)initWithIcon:(UIImage *)icon;
- (instancetype)initWithIcon:(UIImage *)icon andBackgroundColor:(UIColor *)color;

@end

@protocol FATabBarDelegate;

@interface FATabbedToolbar : UIVisualEffectView

- (void)setTabBarItems:(NSArray *)items;
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)flag; // go to ToolbarMode

- (void)setRightBarItem:(FABarItem *)item animated:(BOOL)flag;
- (void)deselectItem; // return back to TabBarMode

@property (nonatomic, readonly) FATabbedToolbarMode mode;
@property (nonatomic, readonly) NSArray <FABarItem *> *items;
@property (nonatomic, readonly) NSInteger selectedIndex;

@property (nonatomic) id<FATabBarDelegate> tabBarDelegate;

@end

@protocol FATabBarDelegate <NSObject>
@optional

- (void)tabBarItem:(FABarItem *)item selectedAtIndex:(NSInteger)index;
- (void)tabBarDidDeselectItem:(FABarItem *)item atIndex:(NSInteger)index;

@end
