//
//  SCSearchAccountSelectionDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchAccountSelectionDataSource.h"
#import "SCBaseGroupedTableViewCell.h"
#import "SCSearchAccount.h"

@interface SCSearchAccountSelectionDataSource ()

@property (nonatomic, strong, readwrite) NSFetchedResultsController *providerFetchedResultsController;

@end

@implementation SCSearchAccountSelectionDataSource

- (void)loadData
{
    [super loadData];

    self.providerFetchedResultsController = [SCSearchAccount fetchAllSortedBy:@"displayIndex"
                                                            ascending:YES
                                                        withPredicate:nil
                                                              groupBy:nil
                                                             delegate:nil];
    [self.providerFetchedResultsController performFetch:NULL];
    [self didFinishLoading];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell = [[SCBaseGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.section == 0) {
        SCSearchAccount *account = [self.providerFetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = account.name;
    } else {
        cell.textLabel.text = NSLocalizedString(@"NZBMATRIX_RSS_KEY", nil);
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.providerFetchedResultsController.fetchedObjects count];
        default:
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"SEARCH_KEY", nil);
        default:
            return NSLocalizedString(@"FEEDS_KEY", nil);
    }
}

@end