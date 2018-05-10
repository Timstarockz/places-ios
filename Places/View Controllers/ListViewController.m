//
//  ListViewController.m
//  Places
//
//  Created by Timothy Desir on 3/31/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

// main
#import "ListViewController.h"

// view controllers
#import "PlaceViewController.h"

// views
#import "PlaceNode.h"
#import "PSBlankNode.h"
#import "PlaceInfoTitleNode.h"
#import "ASCustomSeparatorCellNode.h"

// frameworks
#import "FAKit.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

// helpers
#import "AppDelegate.h"
#import "FAHelpers.h"

@interface ListViewController () <ASTableDelegate, ASTableDataSource, UITableViewDelegate>

@end

@implementation ListViewController {
    FANavBar *navBar;
    PlaceInfoTitleNode *titleView;
    ASTableNode *listTable;
    PSBlankNode *blankNode;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init nav bar
        navBar = [[FANavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
        [navBar setShowBackButton:true];
        //
        FABarItem *share = [[FABarItem alloc] init];
        share.title = @"Share Place";
        share.icon = [UIImage imageNamed:@"share_con"];
        share.backgroundColor = [UIColor darkGrayColor];
        [navBar setRightItem:share];
        [navBar.backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        // init info title node
        titleView = [[PlaceInfoTitleNode alloc] init];
        [titleView setTitle:@"List Title"];
        [titleView setSubtitle:@"9 Places" withRating:0];
        [navBar setCustomView:titleView.view];
        
        // init list table
        listTable = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        listTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        listTable.delegate = self;
        listTable.dataSource = self;
        listTable.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        listTable.contentInset = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP , 0, FATOOLBAR_HEIGHT, 0);
        listTable.view.scrollIndicatorInsets = UIEdgeInsetsMake(TABLE_CONTENT_INSET_TOP, 0, FATOOLBAR_HEIGHT, 0);
        //listTable.view.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubnode:listTable];
        
        // init blank node
        //blankNode = [[PSBlankNode alloc] init];
        //blankNode.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        //blankNode.layoutOrder = @[blankNode.image,
        //                          blankNode.message];
        //[blankNode setMessageText:@"didn't load!"];
        //[self.view addSubnode:blankNode];
        //[blankNode showLoadingState:true];
    }
    
    return self;
}

- (UIView *)statusBarAccessoryView {
    return navBar;
}

- (FABarItem *)tabBarItem {
    FABarItem *root = [[FABarItem alloc] init];
    root.title = @"Find Places";
    root.icon = [UIImage imageNamed:@"search_con2"];
    root.backgroundColor = [UIColor colorWithHexString:@"#20c3e1"];
    
    FABarItem *favorite = [[FABarItem alloc] init];
    favorite.title = @"Toggle Favorite Place";
    favorite.icon = [UIImage imageNamed:@"favs_con"];
    favorite.backgroundColor = [UIColor darkGrayColor];
    root.rightItem = favorite;
    
    return root;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASTableNodeDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return 1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return 9;
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

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableNode deselectRowAtIndexPath:indexPath animated:true];
}

/// UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
