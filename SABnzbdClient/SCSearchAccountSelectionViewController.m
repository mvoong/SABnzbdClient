//
//  SCSearchAccountSelectionViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchAccountSelectionViewController.h"
#import "SCSearchAccountSelectionDataSource.h"
#import "SCSearchAccount.h"
#import "SCSearchViewController.h"
#import "SCNZBMatrixCategoryViewController.h"

@interface SCSearchAccountSelectionViewController ()

@end

@implementation SCSearchAccountSelectionViewController

@synthesize dataSource;

- (void)setup
{
    [super setup];
    self.title = NSLocalizedString(@"ADD_NZB_TITLE", nil);
}

- (SCSearchAccountSelectionDataSource *)searchAccountDataSource
{
    return (SCSearchAccountSelectionDataSource *)self.dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.dataSource loadData];

    // Insert empty view to get rid of empty rows
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            SCSearchAccount *account = [[[self searchAccountDataSource] providerFetchedResultsController] objectAtIndexPath:indexPath];
            SCSearchViewController *searchViewController = [[SCSearchViewController alloc] initWithNibName:@"SCSearchViewController" bundle:nil];
            searchViewController.account = account;
            [self.navigationController pushViewController:searchViewController animated:YES];

            break;
        }
        default:
        {
            SCNZBMatrixCategoryViewController *viewController = [[SCNZBMatrixCategoryViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
    }
}

- (void)viewDidUnload
{
    self.dataSource = nil;
    [super viewDidUnload];
}

@end