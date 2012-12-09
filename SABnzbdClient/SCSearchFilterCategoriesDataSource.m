//
//  SCSearchFilterCategoriesDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchFilterCategoriesDataSource.h"
#import "SCBaseGroupedTableViewCell.h"
#import "SCSearchFilterCategory.h"
#import "SCSearchFilterItem.h"
#import "SCSearchAccount.h"

@interface SCSearchFilterCategoriesDataSource ()

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SCSearchFilterCategoriesDataSource

@synthesize fetchedResultsController;
@synthesize searchAccount;

- (void)loadData
{
    [super loadData];

    NSPredicate *accountPredicate = [NSPredicate predicateWithFormat:@"account = %@", self.searchAccount];
    self.fetchedResultsController = [SCSearchFilterCategory fetchAllSortedBy:@"name"
                                                                   ascending:YES
                                                               withPredicate:accountPredicate
                                                                     groupBy:nil
                                                                    delegate:self];
    self.fetchedResultsController.delegate = self;
    [self.fetchedResultsController performFetch:NULL];

    [self didFinishLoading];
}

#pragma mark - Data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo>sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[SCBaseGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    SCSearchFilterCategory *category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = category.name;
    cell.detailTextLabel.text = nil;

    NSSet *items = [self.searchAccount.filterItems filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"category = %@", category]];

    if ([items count]) {
        cell.detailTextLabel.text = [[items anyObject] name];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView numberOfRowsInSection:section] > 0)
        return NSLocalizedString(@"FILTERS_KEY", nil);

    return nil;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
    atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
    newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end