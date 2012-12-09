//
//  SCSearchFilterItemEditorViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 19/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchFilterItemEditorViewController.h"
#import "SCSearchAccount.h"
#import "SCSearchFilterCategory.h"

@interface SCSearchFilterItemEditorViewController ()

- (void)removeFilter;

@end

@implementation SCSearchFilterItemEditorViewController

@synthesize searchAccount = _searchAccount;
@synthesize filterCategory = _filterCategory;
@synthesize dataSource = _dataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.filterCategory.name;

    self.dataSource.filterCategory = self.filterCategory;
    self.dataSource.searchAccount = self.searchAccount;
    [self.dataSource loadData];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeFilter)];
    self.navigationItem.rightBarButtonItem.enabled = [self.dataSource hasActiveFilter];
}

- (void)searchFilterItemEditorDataSourceDidChangeSearchFilterItem:(SCSearchFilterItemEditorDataSource *)dataSource
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)removeFilter
{
    [self.searchAccount removeFilterItems:[self.filterCategory items]];
    [[NSManagedObjectContext defaultContext] save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    self.dataSource = nil;
    [super viewDidUnload];
}

@end