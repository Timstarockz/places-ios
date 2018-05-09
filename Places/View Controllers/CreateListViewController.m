//
//  CreateListViewController.m
//  Places
//
//  Created by Timothy Desir on 5/8/18.
//  Copyright © 2018 Tim Inc. All rights reserved.
//

//  main
#import "CreateListViewController.h"

// views
#import "TableHeader.h"
#import "PlaceNode.h"

// frameworks
#import <AsyncDisplayKit/AsyncDisplayKit.h>

// helpers
#import "AppDelegate.h"
#import "FAHelpers.h"

@interface CreateListViewController () <ASTableDelegate, ASTableDataSource, UITableViewDelegate>

@end

@implementation CreateListViewController {
    ASTableNode *newListTable;
}

#pragma mark - Initialization

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New List";
        
        // init new list table
        newListTable = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        newListTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        newListTable.delegate = self;
        newListTable.dataSource = self;
        newListTable.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubnode:newListTable];
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASTableNodeDelegate

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    // 0: title header
    // 1: recently viewed places
    return 2;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 20;
    }
    
    return 0;
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
    if (section == 1) {
        return 30;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        TableHeader *header = [[TableHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        [header setText:@"RECENTLY VIEWED"];
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
