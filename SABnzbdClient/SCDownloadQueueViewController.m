//
//  SCDownloadQueueViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadQueueViewController.h"
#import "SCServer.h"
#import "SCDownloadItemCell.h"
#import "SCToolbarInfoView.h"
#import "SCSearchAccountSelectionViewController.h"
#import "SCDownloadItemDetailViewController.h"
#import "SCStatusTransformer.h"

@implementation SCDownloadQueueViewController

- (void)setServer:(SCServer *)server
{
    _server = server;
    self.title = server.name;
    self.toolbarInfoView.server = server;
}

#pragma mark - SCBaseTableViewController

- (UIView *)offsetTableForView
{
    return self.searchDisplayController.searchBar;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.title = self.server.name;
    self.dataSource.server = self.server;
//    self.searchDataSource.server = self.server;
    self.toolbarInfoView.server = self.server;

    // Insert empty view to get rid of empty rows
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.dataSource loadData];
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, self.toolbar.frame.size.height, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataSource stopLoadingData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setEditing:NO animated:YES scheduleReload:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];

    // Cell heights need to be recalculated
    [self.tableView reloadData];
}

#pragma mark - Data source

- (void)baseDataSource:(SCBaseDataSource *)dataSource didFailWithError:(NSString *)errorDescription
{
    if (self.editing) {
        [self setEditing:NO animated:YES];
    }

    self.editButtonItem.enabled = NO;

    [SCPopupMessageView showWithMessage:errorDescription overView:self.view iconImage:[UIImage imageNamed:@"Icon-Wifi.png"]];
}

- (void)baseDataSourceDidSucceed:(SCBaseDataSource *)dataSource
{
    self.editButtonItem.enabled = [self.dataSource hasResults];
    self.pauseButton.enabled = YES;
    self.speedButton.enabled = YES;
}

- (void)baseDataSourceDidStartLoading:(SCBaseDataSource *)dataSource
{
    self.editButtonItem.enabled = [self.dataSource hasResults] > 0 && ![dataSource isStale];
    self.pauseButton.enabled = YES;
    self.speedButton.enabled = YES;
}

- (void)baseDataSourceDidStopLoading:(SCBaseDataSource *)dataSource
{
}

#pragma mark - Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self setEditing:editing animated:animated scheduleReload:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated scheduleReload:(BOOL)scheduleReload
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];

    if (editing) {
        // Disable loading data while editing
        [self.dataSource stopLoadingData];
    } else if (scheduleReload) {
        [self.dataSource loadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Pause / Speed

- (void)showPauseActionSheet
{
    SCPauseActionSheetPickerDataSource *dataSource = [[SCPauseActionSheetPickerDataSource alloc] initWithDelegate:self];
    [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"PAUSE_KEY", nil)];
}

- (void)pauseSelectionViewDidSelectPauseTime:(NSTimeInterval)pauseTimeSeconds
{
    [self.dataSource pauseForDuration:pauseTimeSeconds];
}

- (void)pauseSelectionViewDidClearPauseTime
{
    [self.dataSource pauseForDuration:0];
}

- (void)showSpeedActionSheet
{
    SCSpeedLimitActionSheetPickerDataSource *dataSource = [[SCSpeedLimitActionSheetPickerDataSource alloc] initWithDelegate:self];
    [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SPEED_KEY", nil)];
}

- (void)speedLimitSelectionViewDidSelectSpeed:(NSUInteger)speedKB
{
    [self.dataSource updateSpeedLimitToSpeed:speedKB];
}

- (void)speedLimitSelectionViewDidClearSpeedLimit
{
    [self.dataSource updateSpeedLimitToSpeed:0];
}

- (void)downloadQueueDataSourceDidFinishApplyingConfigSetting:(SCDownloadQueueDataSource *)dataSource
{
    [SCPopupMessageView showWithMessage:nil overView:self.view iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
}

#pragma mark - Search

- (void)showSearchViewController
{
    UIViewController *searchViewController = [[SCSearchAccountSelectionViewController alloc] initWithNibName:@"SCSearchAccountSelectionViewController" bundle:nil];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (![self.dataSource.searchTerm isEqualToString:searchString]) {
        self.dataSource.searchTerm = searchString;
        return YES;
    }

    return NO;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    // Let search data source know about the table view it's managing
    self.dataSource.tableView = tableView;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    // Restore back to current table view
    self.dataSource.tableView = self.tableView;
    
    // Clear search term
    self.dataSource.searchTerm = nil;;
    
    // Reload table
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            SCDownloadItem *item = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
            CGFloat width = self.tableView.frame.size.width;

            if (self.editing)
                width -= 63;

            return [SCDownloadItemCell heightForItem:item width:width];
            break;
        }

        default:
            return 70.0f;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // Don't allow dragging to second section
    if (proposedDestinationIndexPath.section == 1)
        return sourceIndexPath;

    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SCDownloadItem *item = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([SCStatusTransformer downloadStatusForNumber:item.status] != DownloadStatusGrabbing) {
            SCDownloadItemDetailViewController *vc = [[SCDownloadItemDetailViewController alloc] init];
            vc.downloadItem = item;
    
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)viewDidUnload
{
    self.dataSource = nil;
//    self.searchDataSource = nil;
    self.toolbarInfoView = nil;
    self.toolbar = nil;
    self.pauseButton = nil;
    self.speedButton = nil;

    [super viewDidUnload];
}

@end