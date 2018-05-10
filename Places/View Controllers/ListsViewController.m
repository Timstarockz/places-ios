//
//  ListsViewController.m
//  Food
//
//  Created by Timothy Desir on 3/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "ListsViewController.h"

// view controllers
#import "ListViewController.h"
#import "CreateListViewController.h"

// views
#import "ListNode.h"

// frameworks
#import "FAKit.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

// helpers
#import "FAHelpers.h"


@interface ListsViewController () <FASearchBarDelegate, ASTableDelegate, ASTableDataSource>

@end

@implementation ListsViewController {
    FASearchBar *searchBar;
    ASTableNode *listsNode;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init search bar
        searchBar = [[FASearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 58)];
        searchBar.delegate = self;
        searchBar.placeholder = @"Search for and through lists";
        
        // init lists table node
        listsNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        listsNode.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        listsNode.delegate = self;
        listsNode.dataSource = self;
        listsNode.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        listsNode.contentInset = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP , 0, FATOOLBAR_HEIGHT, 0);
        listsNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP, 0, FATOOLBAR_HEIGHT, 0);
        [self.view addSubnode:listsNode];
    }
    
    return self;
}

- (UIView *)statusBarAccessoryView {
    return searchBar;
}

- (FABarItem *)tabBarItem {
    FABarItem *root = [[FABarItem alloc] init];
    root.title = @"Lists of Places";
    root.icon = [UIImage imageNamed:@"lists_con"];
    root.backgroundColor = [UIColor colorWithHexString:@"#989898"];//@"#a871d1"];
    
    FABarItem *addButton = [[FABarItem alloc] init];
    addButton.title = @"New List";
    addButton.icon = [UIImage imageNamed:@"add_con"];
    addButton.backgroundColor = [UIColor darkGrayColor];
    [addButton addTarget:self withAction:@selector(newList)];
    root.rightItem = addButton;
    
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

#pragma mark - Interface

- (void)newList {
    CreateListViewController *create = [[CreateListViewController alloc] initWithNibName:nil bundle:nil];
    FANavigationController *createN = [[FANavigationController alloc] initWithRootViewController:create];
    createN.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.container presentViewController:createN animated:true completion:nil];
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
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASCellNode *(^cellNodeBlock)(void) = ^ASCellNode *() {
        ListNode *cell = [[ListNode alloc] init];
        return cell;
    };
    return cellNodeBlock;
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:true];
    
    // show list detail
    ListViewController *list = [[ListViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:list animated:true];
}

/// UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
