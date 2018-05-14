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
#import "PlaceNode.h"

// frameworks
#import "FAKit.h"
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
        // set bar title
        self.navItem.title = @"New List";
        
        // set right bar item
        FABarItem *editItem = [[FABarItem alloc] initWithIcon:[UIImage imageNamed:@"mini_add_con"] andBackgroundColor:[UIColor darkGrayColor]];
        self.navItem.rightBarItem = editItem;
        
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

- (void)viewDidPresent:(BOOL)animated {
    [super viewDidPresent:animated];
    
    NSLog(@"%s - %lu", __PRETTY_FUNCTION__, (unsigned long)self.presentationOrigin);
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
        return [FATableHeader headerWithText:@"RECENTLY VIEWED" andHeight:30];
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
