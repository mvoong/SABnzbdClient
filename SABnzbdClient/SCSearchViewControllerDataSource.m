//
//  SCSearchViewControllerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchViewControllerDataSource.h"
#import "SCNZBResult.h"
#import "SCBaseGroupedTableViewCell.h"
#import "SCSearchResultCell.h"
#import "SCSearchAccount+Additions.h"

#import "SCBinSearchClient.h"
#import "SCNZBMatrixSearchClient.h"
#import "SCSABnzbdClient.h"
#import "SCPopupMessageView.h"

@interface SCSearchViewControllerDataSource ()

@property (nonatomic, strong) SCSearchClient *searchClient;
@property (nonatomic, strong) NSOperation *searchClientOperation;
@property (nonatomic, strong, readwrite) NSArray *results;

@end

@implementation SCSearchViewControllerDataSource

+ (NSArray *)sortDescriptorsForOrder:(SCSearchOrderingScopeBarItem)order
{
    switch (order) {
        case SCSearchOrderingScopeBarItemDate:
        {
            return [[NSArray alloc] initWithObjects:
                    [[NSSortDescriptor alloc] initWithKey:@"usenetDate" ascending:NO],
                    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES],
                    nil];
        } break;
        case SCSearchOrderingScopeBarItemName:
        {
            return [[NSArray alloc] initWithObjects:
                    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES],
                    [[NSSortDescriptor alloc] initWithKey:@"usenetDate" ascending:NO],
                    nil];
        } break;
        case SCSearchOrderingScopeBarItemSize:
        {
            return [[NSArray alloc] initWithObjects:
                    [[NSSortDescriptor alloc] initWithKey:@"size" ascending:NO],
                    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES],
                    nil];
        } break;
        default: // Hits or default
        {
            return [[NSArray alloc] initWithObjects:
                    [[NSSortDescriptor alloc] initWithKey:@"hits" ascending:NO],
                    [[NSSortDescriptor alloc] initWithKey:@"usenetDate" ascending:NO],
                    [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES],
                    nil];
        } break;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.order = SCSearchOrderingScopeBarItemHits;
    }
    return self;
}

- (void)setSearchTerm:(NSString *)searchTerm
{
    _searchTerm = searchTerm;
    [self clearResults];
    [self.searchClientOperation cancel];
}

- (void)setOrder:(SCSearchOrderingScopeBarItem)order
{
    _order = order;
    
    // Update sort descriptor
    self.results = [self sortedResults:self.results];
    [self.tableView reloadData];
}

- (void)performSearch:(NSString *)searchTerm
{
    self.searchTerm = searchTerm;

    if ([searchTerm length]) {
        [self.delegate searchViewControllerDataSourceDidStartLoading:self];

        [self.searchClientOperation cancel];
        self.searchClient = [self.searchAccount searchClient];
        self.searchClientOperation = [self.searchClient startSearchRequestWithTerm:self.searchTerm success:^(NSArray *results, NSString *apiError) {
            self.results = [self sortedResults:results];
            
            if (apiError) {
                [self.delegate searchViewControllerDataSource:self didFailWithError:apiError];
            } else {
                [self.delegate searchViewControllerDataSourceDidFinishLoading:self];
            }
        } failure:^(NSError *error) {
            [self.delegate searchViewControllerDataSource:self didFailWithError:[error localizedDescription]];
        }];
    }
}

- (NSArray *)sortedResults:(NSArray *)results
{
    return [results sortedArrayUsingDescriptors:[SCSearchViewControllerDataSource sortDescriptorsForOrder:self.order]];
}

- (void)clearResults
{
    self.results = nil;
    [self.tableView reloadData];

    [self stopLoadingData];
}

#pragma mark - Data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SCSearchResultCell";
    SCSearchResultCell *cell = (SCSearchResultCell *)[tableView dequeueReusableCellWithIdentifier:cellId];

    if (cell == nil) {
        cell = [SCSearchResultCell loadFromNib];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(triggerDownloadWithRecogniser:)]];
    }

    cell.result = self.results[indexPath.row];

    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

- (void)triggerDownloadWithRecogniser:(UIGestureRecognizer *)recogniser
{
    if (recogniser.state != UIGestureRecognizerStateBegan)
        return;
    
    SCNZBResult *result = [(SCSearchResultCell *)recogniser.view result];
    
    if ([self.delegate respondsToSelector:@selector(searchViewControllerDataSourceShouldDownloadWithResult:)]) {
        [self.delegate searchViewControllerDataSourceShouldDownloadWithResult:result];
    }
        
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end