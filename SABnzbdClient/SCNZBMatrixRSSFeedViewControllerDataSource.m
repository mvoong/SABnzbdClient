//
//  SCNZBMatrixRSSFeedViewControllerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixRSSFeedViewControllerDataSource.h"
#import "SCNZBMatrixRSSItemCell.h"
#import "SCNZBMatrixRSSClient.h"
#import "SCSABnzbdClient.h"

@interface SCNZBMatrixRSSFeedViewControllerDataSource ()

@property (nonatomic, strong, readwrite) NSArray *results;
@property (nonatomic, strong) NSOperation *feedRequestOperation;

@end

@implementation SCNZBMatrixRSSFeedViewControllerDataSource

- (void)loadData
{
    [super loadData];
    
    [self.feedRequestOperation cancel];
    self.feedRequestOperation = [[SCNZBMatrixRSSClient client] startRSSRequestWithCategoryID:self.filterItem.value success:^(NSArray *items) {
        self.results = items;
        [self didSucceedLoading];
    } failure:^(NSError *error) {
        [self didFailWithLocalisedError:[error localizedDescription]];
    }];
}

- (void)stopLoadingData
{
    [super stopLoadingData];
    
    [self.feedRequestOperation cancel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SCNZBMatrixRSSItemCell";
    SCNZBMatrixRSSItemCell *cell = (SCNZBMatrixRSSItemCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [SCNZBMatrixRSSItemCell loadFromNib];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(triggerDownloadWithRecogniser:)]];
    }
    
    cell.result = self.results[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

- (void)triggerDownloadWithRecogniser:(UIGestureRecognizer *)recogniser
{
    if (recogniser.state != UIGestureRecognizerStateBegan)
        return;
    
    id<SCNZBItem> result = [(SCNZBMatrixRSSItemCell *)recogniser.view result];
    
    if ([self.delegate respondsToSelector:@selector(rssFeedViewControllerDataSourceShouldDownloadWithResult:)]) {
        [self.delegate rssFeedViewControllerDataSourceShouldDownloadWithResult:result];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
