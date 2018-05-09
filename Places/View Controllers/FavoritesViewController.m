//
//  FavoritesViewController.m
//  Food
//
//  Created by Timothy Desir on 3/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "FavoritesViewController.h"

// view controllers
#import "PlaceViewController.h"

// tmp
#import "FASearchBar.h"
#import "FATabbedToolbar.h"

// views
#import "TableHeader.h"
#import "PlaceNode.h"

// frameworks
#import <AsyncDisplayKit/AsyncDisplayKit.h>

// helpers
#import "FAHelpers.h"


@interface FavoritesViewController () <FASearchBarDelegate, ASTableDelegate, ASTableDataSource, UITableViewDelegate>

@end

@implementation FavoritesViewController {
    FASearchBar *searchBar;
    ASTableNode *favoritesNode;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init search bar
        searchBar = [[FASearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 58)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Search favorite places";
        
        // init favorites table node
        favoritesNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        favoritesNode.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        favoritesNode.delegate = self;
        favoritesNode.dataSource = self;
        favoritesNode.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        favoritesNode.contentInset = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP-0.5 , 0, FATOOLBAR_HEIGHT, 0);
        favoritesNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP, 0, FATOOLBAR_HEIGHT, 0);
        [self.view addSubnode:favoritesNode];
    }
    
    return self;
}

- (UIView *)statusBarAccessoryView {
    return searchBar;
}

- (FATabBarItem *)tabBarItem {
    FATabBarItem *root = [[FATabBarItem alloc] init];
    root.title = @"Favorite Places";
    root.icon = [UIImage imageNamed:@"favs_con"];
    root.backgroundColor = [UIColor colorWithHexString:@"#fc4758"];//@"#eaa73e"];
    
    FATabBarItem *mapButton = [[FATabBarItem alloc] init];
    root.rightItem = mapButton;
    mapButton.title = @"Toggle Map View";
    mapButton.icon = [UIImage imageNamed:@"map_con3"];
    mapButton.backgroundColor = [UIColor darkGrayColor];
    
    return root;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"Find";
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FASearchBarDelegate

- (void)searchBarDidBeginEditing:(FASearchBar *)searchBar {
    
}

- (void)searchBarDidEndEditing:(FASearchBar *)searchBar {
    
}


- (void)searchBarDidChangeCharacters:(FASearchBar *)searchBar {
    
}


- (void)searchBarDidReturn:(FASearchBar *)searchBar {
    
}

#pragma mark - ASTableNodeDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 2;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 15;
    } else {
        return 0;
    }
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        PlaceNode *cell = [[PlaceNode alloc] init];
        [cell setTitle:@"Osha Thai Restaurant"];
        [cell setSubtitle:@"Bar • 100ft"];
        [cell setFooter:@"696 Geary Street"];
        return cell;
    };
    return cellNodeBlock;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        TableHeader *header = [[TableHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [header setText:@"FAVORITES AROUND YOU"];
        return header;
    } else if (section == 1) {
        TableHeader *header = [[TableHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [header setText:@"15 FAVORITES"];
        return header;
    } else {
        return nil;
    }
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:true];
}

/// UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
