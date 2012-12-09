//
//  SCNZBMatrixCategoryViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixCategoryViewController.h"
#import "SCNZBMatrixRSSFeedViewController.h"
#import "SCNZBMatrixCategoryViewControllerDataSource.h"
#import "SCSearchAccount+Additions.h"

@interface SCNZBMatrixCategoryViewController () <UISearchBarDelegate, UISearchDisplayDelegate>

@end

@implementation SCNZBMatrixCategoryViewController

- (UIView *)offsetTableForView
{
    return self.searchDisplayController.searchBar;
}

- (SCNZBMatrixCategoryViewControllerDataSource *)categoryDataSource
{
    return (SCNZBMatrixCategoryViewControllerDataSource *)self.dataSource;
}

- (SCSearchAccount *)searchAccount
{
    return [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"NZBMATRIX_RSS_KEY", nil);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ACCOUNT_KEY", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(showAccountSettings)];
    [self.dataSource loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Show placeholder if account details invalid
    SCSearchAccount *account = [SCSearchAccount searchAccountWithKey:kSearchAccountKeyNZBMatrix];
    if (![account isValid]) {
        [self showPlaceholderWithMessage:NSLocalizedString(@"CONFIGURE_NZB_MATRIX_KEY", nil)];
    } else {
        [self hidePlaceholder];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCNZBMatrixRSSFeedViewController *viewController = [[SCNZBMatrixRSSFeedViewController alloc] init];
    viewController.filterItem = [[[self categoryDataSource] categoryFetchedResultsController] objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showAccountSettings
{
    UIViewController *settingsViewController = [[self searchAccount] settingsViewController];
    [self showModalViewController:settingsViewController withDoneSystemItem:UIBarButtonSystemItemDone];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [[self categoryDataSource] setSearchString:searchString];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    // Let search data source know about the table view it's managing
    [[self categoryDataSource] setTableView:tableView];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    // Restore back to current table view
    [[self categoryDataSource] setTableView:self.tableView];
    
    // Clear search term
    [[self categoryDataSource] setSearchString:@""];
    
    // Reload table
    [self.tableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    [[self categoryDataSource] setTableView:self.tableView];
}

@end
