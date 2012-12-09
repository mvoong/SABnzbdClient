//
//  SCNZBMatrixCategoryViewControllerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixCategoryViewControllerDataSource.h"
#import "SCBaseTableViewCell.h"

@interface SCNZBMatrixCategoryViewControllerDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController *categoryFetchedResultsController;

@end

@implementation SCNZBMatrixCategoryViewControllerDataSource

- (void)loadData
{
    [super loadData];
    
    SCSearchFilterCategory *category = [SCSearchFilterCategory categoryWithKey:kSearchFilterCategoryKeyNZBMatrixCategory];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category = %@", category];
    self.categoryFetchedResultsController = [SCSearchFilterItem fetchAllSortedBy:@"displayIndex"
                                                                       ascending:YES
                                                                   withPredicate:predicate
                                                                         groupBy:nil
                                                                        delegate:self];
    [self.categoryFetchedResultsController performFetch:NULL];
}

- (void)setSearchString:(NSString *)searchString
{
    SCSearchFilterCategory *category = [SCSearchFilterCategory categoryWithKey:kSearchFilterCategoryKeyNZBMatrixCategory];
    NSPredicate *predicate = nil;
    
    if ([searchString length] > 0)
        predicate = [NSPredicate predicateWithFormat:@"category = %@ AND name contains[cd] %@", category, searchString];
    else
        predicate = [NSPredicate predicateWithFormat:@"category = %@", category];
    
    self.categoryFetchedResultsController.fetchRequest.predicate = predicate;
    [self.categoryFetchedResultsController performFetch:NULL];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SCBaseTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[SCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    SCSearchFilterItem *filterItem = [self.categoryFetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = filterItem.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoryFetchedResultsController.fetchedObjects count];
}

@end
