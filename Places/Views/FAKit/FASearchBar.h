//
//  FASearchBar.h
//  Food
//
//  Created by Timothy Desir on 3/6/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FASEARCHBAR_HEIGHT 58
#define FASEARCHBAR_TEXTCELL_PADDING 16

@protocol FASearchBarDelegate;

@interface FASearchBar : UIView

@property (nonatomic) NSString *placeholder;
@property (nonatomic) NSString *text;

@property (nonatomic) UIImage *icon;

@property (nonatomic) id<FASearchBarDelegate> delegate;

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

@property (nonatomic, readonly) BOOL isEditing;

@end


@protocol FASearchBarDelegate <NSObject>
@optional

- (void)searchBarDidBeginEditing:(FASearchBar *)searchBar;
- (void)searchBarDidEndEditing:(FASearchBar *)searchBar;

- (void)searchBarDidChangeCharacters:(FASearchBar *)searchBar;

- (void)searchBarDidReturn:(FASearchBar *)searchBar;

@end
