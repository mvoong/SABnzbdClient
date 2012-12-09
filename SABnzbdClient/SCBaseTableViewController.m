//
//  SCBaseTableViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"

@interface SCBaseTableViewController ()

@property (nonatomic, assign) BOOL tableOffsetRequired;

@end

@implementation SCBaseTableViewController

- (UIScrollView *)scrollView
{
    return self.tableView;
}

- (UIView *)offsetTableForView
{
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [SCAppearance colourByName:ColourNameBarButtonTableSeparator];
    [self.tableView setBackgroundView:nil];
    
    // Only offset once per view load
    self.tableOffsetRequired = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    if ([self offsetTableForView] && self.tableOffsetRequired) {
        self.tableView.contentOffset = CGPointMake(0, [self offsetTableForView].frame.size.height);
        self.tableOffsetRequired = NO;
    }
}

- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

@end