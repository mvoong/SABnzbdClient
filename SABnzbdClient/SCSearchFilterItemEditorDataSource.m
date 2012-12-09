//
//  SCSearchFilterItemEditorDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 19/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchFilterItemEditorDataSource.h"
#import "SCSearchAccount.h"
#import "SCSearchFilterCategory.h"
#import "SCSearchFilterItem.h"
#import "SCBaseTableViewCell.h"

@interface SCSearchFilterItemEditorDataSource ()

@property (nonatomic, strong) NSArray *items;

- (void)applyFilterItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SCSearchFilterItemEditorDataSource

- (void)loadData
{
    [super loadData];

    self.items = [SCSearchFilterItem findAllSortedBy:@"displayIndex"
                                           ascending:YES
                                       withPredicate:[NSPredicate predicateWithFormat:@"category = %@", self.filterCategory]];

    if ([self.delegate respondsToSelector:@selector(baseDataSourceDidSucceed:)])
        [self.delegate baseDataSourceDidSucceed:self];

    [self didFinishLoading];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SCBaseTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [[SCBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    SCSearchFilterItem *filterItem = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = filterItem.name;

    BOOL selected = [self.searchAccount.filterItems containsObject:filterItem];
    cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self applyFilterItemAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // For an empty footer
    return 0.01f;
}

#pragma mark - Actions

- (void)applyFilterItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove other filters and add new one
    SCSearchFilterItem *filterItem = [self.items objectAtIndex:indexPath.row];
    [self.searchAccount addFilterItemsObject:filterItem];

    for (SCSearchFilterItem *item in [[self.searchAccount filterItems] copy]) {
        if (item != filterItem && item.category == self.filterCategory)
            [self.searchAccount removeFilterItemsObject:item];
    }

    [[NSManagedObjectContext defaultContext] save];

    if ([self.delegate respondsToSelector:@selector(searchFilterItemEditorDataSourceDidChangeSearchFilterItem:)]) {
        [self.delegate searchFilterItemEditorDataSourceDidChangeSearchFilterItem:self];
    }
}

#pragma mark - Inspection

- (BOOL)hasActiveFilter
{
    NSUInteger itemCount = [SCSearchFilterItem countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"searchAccounts CONTAINS %@", self.searchAccount]];
    return itemCount > 0;
}

@end