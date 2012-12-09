//
//  SCNZBMatrixRSSFeedViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixRSSFeedViewController.h"
#import "SCNZBMatrixRSSFeedViewControllerDataSource.h"
#import "SCSearchResultDetailViewController.h"

@interface SCNZBMatrixRSSFeedViewController () <SCBaseDataSourceDelegate, SCSearchResultDetailViewControllerDelegate, SCNZBMatrixRSSFeedViewControllerDataSourceDelegate, SCCategoryPickerDataSourceDelegate>

@property (nonatomic, strong) NSOperation *downloadClientOperation;
@property (nonatomic, strong) SCSABnzbdClient *client;
@property (nonatomic, strong) id<SCNZBItem> selectedResult;

@end

@implementation SCNZBMatrixRSSFeedViewController

- (SCNZBMatrixRSSFeedViewControllerDataSource *)itemDataSource
{
    return (SCNZBMatrixRSSFeedViewControllerDataSource *)self.dataSource;
}

- (void)setup
{
    [super setup];
    self.client = [SCSABnzbdClient clientWithServer:[SCServer activeServer]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the category
    [[self itemDataSource] setFilterItem:self.filterItem];
    
    self.title = self.filterItem.name;
    self.dataSource.delegate = self;
    [self.dataSource loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataSource stopLoadingData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<SCNZBItem> result = [[self itemDataSource] results][indexPath.row];
    SCSearchResultDetailViewController *viewController = [[SCSearchResultDetailViewController alloc] init];
    viewController.searchResult = result;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)baseDataSourceDidStartLoading:(SCBaseDataSource *)dataSource
{
    [self showActivityIndicator];
}

- (void)baseDataSourceDidSucceed:(SCBaseDataSource *)dataSource
{
    [self.tableView reloadData];
    
    if ([[[self itemDataSource] results] count] == 0) {
        [self showPlaceholderWithMessage:NSLocalizedString(@"NO_RESULTS_FOUND_KEY", nil)];
    }
}

- (void)baseDataSourceDidStopLoading:(SCBaseDataSource *)dataSource
{
    [self hideActivityIndicator];
}

- (void)baseDataSource:(SCBaseDataSource *)dataSource didFailWithError:(NSString *)errorDescription
{
    [self showPlaceholderWithMessage:errorDescription];
}

#pragma mark - Long press download

- (void)rssFeedViewControllerDataSourceShouldDownloadWithResult:(id<SCNZBItem>)result
{
    SCServer *server = [SCServer activeServer];
    
    if (server) {
        if ([server.categories count]) {
            self.selectedResult = result;
            SCCategoryPickerDataSource *dataSource = [[SCCategoryPickerDataSource alloc] initWithDelegate:self server:server];
            [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SEARCH_RESULT_CATEGORY_KEY", nil)];
        } else {
            [self startDownloadWithCategory:nil result:result];
        }
    } else {
        [SCPopupMessageView showWithMessage:NSLocalizedString(@"NO_ACTIVE_SERVER_KEY", nil) overView:self.view];
    }
}

- (void)categoryPickerDataSource:(SCCategoryPickerDataSource *)dataSource didPickCategory:(SCCategory *)category
{
    [self startDownloadWithCategory:category result:self.selectedResult];
    self.selectedResult = nil;
}

- (void)startDownloadWithCategory:(SCCategory *)category result:(id<SCNZBItem>)result
{
    if (!result)
        return;
    
    [self showActivityIndicator];
    [self.downloadClientOperation cancel];
    self.downloadClientOperation = [self.client startDownloadRequestWithURL:[result downloadURL]
                                                                       name:result.name
                                                                   category:category
                                                                    success:^(NSString *apiError) {
                                                                        if (apiError) {
                                                                            [SCPopupMessageView showWithMessage:apiError
                                                                                                       overView:self.view];
                                                                            [self hideActivityIndicator];
                                                                            
                                                                        } else {
                                                                            [SCPopupMessageView showWithMessage:NSLocalizedString(@"DOWNLOAD_ADDED_KEY", nil)
                                                                                                       overView:self.view
                                                                                                      iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
                                                                            
                                                                            [self hideActivityIndicator];
                                                                        }
                                                                    } failure:^(NSError *error) {
                                                                        [SCPopupMessageView showWithMessage:[error localizedDescription]
                                                                                                   overView:self.view];
                                                                        [self hideActivityIndicator];
                                                                    }];
    
}

#pragma mark - Triggering downloads from details screen

- (void)searchResultDetailViewControllerDidAddDownload:(SCSearchResultDetailViewController *)viewController
{
    [self.navigationController popToViewController:self animated:YES];
    
    [SCPopupMessageView showWithMessage:NSLocalizedString(@"DOWNLOAD_ADDED_KEY", nil)
                               overView:self.view
                              iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
}

- (void)searchViewControllerDataSourceDidFailToDownloadWithError:(NSString *)error
{
    [SCPopupMessageView showWithMessage:error overView:self.view];
    [self hideActivityIndicator];
}

@end
