//
//  SCDownloadItemDetailViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 03/04/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadItemDetailViewController.h"
#import "SCDownloadItem.h"
#import "SCDownloadItemDetailDataSource.h"
#import "SCCategoryActionSheetPickerDataSource.h"
#import "SCScriptActionSheetPickerDataSource.h"
#import "SCPriorityActionSheetPickerDataSource.h"
#import "SCSABnzbdClient.h"
#import "SCCategory.h"
#import "SCScript.h"

@interface SCDownloadItemDetailViewController () <SCCategorySelectionViewDelegate, SCScriptSelectionViewDelegate, SCPrioritySelectionViewDelegate>

@property (nonatomic, strong) SCSABnzbdClient *client;
@property (nonatomic, strong) NSOperation *clientOperation;

@end

@implementation SCDownloadItemDetailViewController

- (SCDownloadItemDetailDataSource *)itemDataSource
{
    return (SCDownloadItemDetailDataSource *)self.dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.downloadItem.filename;
    [[self itemDataSource] setDownloadItem:self.downloadItem];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            SCCategoryActionSheetPickerDataSource *dataSource = [[SCCategoryActionSheetPickerDataSource alloc] initWithDelegate:self downloadItem:self.downloadItem];
            [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SEARCH_RESULT_CATEGORY_KEY", nil)];
            break;
        }
        case 1:
        {
            SCPriorityActionSheetPickerDataSource *dataSource = [[SCPriorityActionSheetPickerDataSource alloc] initWithDelegate:self downloadItem:self.downloadItem];
            [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"PRIORITY", nil)];
            break;
        }
        case 2:
        {
            if ([SCScript countOfEntities] > 0) {
                SCScriptActionSheetPickerDataSource *dataSource = [[SCScriptActionSheetPickerDataSource alloc] initWithDelegate:self downloadItem:self.downloadItem];
                [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SCRIPT", nil)];
            }
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (SCSABnzbdClient *)client
{
    if (!_client) {
        _client = [SCSABnzbdClient clientWithServer:self.downloadItem.server];
    }
    
    return _client;
}
#pragma mark - Delegate

- (void)categorySelectionViewDidSelectCategory:(SCCategory *)category
{
    [self.clientOperation cancel];
    self.clientOperation = [self.client startChangeRequestForMode:@"change_cat" value1:self.downloadItem.nzbId value2:category.name success:^(NSString *apiError) {
        if (apiError) {
            [SCPopupMessageView showWithMessage:apiError overView:self.view];
        } else {
            [SCPopupMessageView showWithMessage:nil overView:self.view iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
            self.downloadItem.category = category;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SCPopupMessageView showWithMessage:[error localizedDescription] overView:self.view iconImage:[UIImage imageNamed:@"Icon-Wifi.png"]];
    }];
}

- (void)scriptActionSheetViewDidSelectScript:(NSString *)script
{
    [self.clientOperation cancel];
    self.clientOperation = [self.client startChangeRequestForMode:@"change_script" value1:self.downloadItem.nzbId value2:script success:^(NSString *apiError) {
        if (apiError) {
            [SCPopupMessageView showWithMessage:apiError overView:self.view];
        } else {
            [SCPopupMessageView showWithMessage:nil overView:self.view iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
            self.downloadItem.script = script;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SCPopupMessageView showWithMessage:[error localizedDescription] overView:self.view iconImage:[UIImage imageNamed:@"Icon-Wifi.png"]];
    }];
}

- (void)priorityActionSheetViewDidSelectPriority:(SCSABnzbdItemPriority)priority
{
    [self.clientOperation cancel];
    self.clientOperation = [self.client startPriorityChangeRequestForNzbId:self.downloadItem.nzbId priority:priority success:^(NSString *apiError) {
        if (apiError) {
            [SCPopupMessageView showWithMessage:apiError overView:self.view];
        } else {
            [SCPopupMessageView showWithMessage:nil overView:self.view iconImage:[UIImage imageNamed:@"Icon-Tick.png"]];
            self.downloadItem.priority = [SCPriorityActionSheetPickerDataSource stringForPriority:priority];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [SCPopupMessageView showWithMessage:[error localizedDescription] overView:self.view iconImage:[UIImage imageNamed:@"Icon-Wifi.png"]];
    }];
}

@end