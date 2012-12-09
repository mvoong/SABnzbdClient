//
//  SCServersViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServersViewController.h"
#import "SCServersViewControllerDataSource.h"
#import "SCServerDetailViewController.h"
#import "SCDownloadQueueViewController.h"

@interface SCServersViewController ()

@end

@implementation SCServersViewController

@synthesize dataSource = _dataSource;
@synthesize addButton = _addButton;

- (void)setup
{
    [super setup];
    self.title = NSLocalizedString(@"SERVERS_KEY", @"Servers");
}

- (SCServersViewControllerDataSource *)serversDataSource
{
    return (SCServersViewControllerDataSource *)self.dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = self.addButton;

    // Navigate to active server if exists
    SCServer *activeServer = [SCServer activeServer];

    if (activeServer) {
        SCDownloadQueueViewController *queueViewController = [[SCDownloadQueueViewController alloc] initWithNibName:@"SCDownloadQueueViewController" bundle:nil];
        queueViewController.server = activeServer;
        [self.navigationController pushViewController:queueViewController animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditing:NO animated:NO];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];

    if (!editing) {
        [[NSManagedObjectContext defaultContext] save];
    }

    [self.navigationItem setRightBarButtonItem:editing ? nil:self.addButton animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        SCServer *server = [[[self serversDataSource] fetchedResultsController] objectAtIndexPath:indexPath];
        SCServerDetailViewController *serverDetailViewController = [[SCServerDetailViewController alloc] initWithNibName:@"SCServerDetailViewController" bundle:nil];
        serverDetailViewController.server = server;
        [self showModalViewController:serverDetailViewController withDoneSystemItem:UIBarButtonSystemItemDone];
    } else {
        SCDownloadQueueViewController *queueViewController = [[SCDownloadQueueViewController alloc] initWithNibName:@"SCDownloadQueueViewController" bundle:nil];
        SCServer *server = [[[self serversDataSource] fetchedResultsController] objectAtIndexPath:indexPath];
        queueViewController.server = server;
        [self.navigationController pushViewController:queueViewController animated:YES];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // Don't allow targeting outside of original section
    return sourceIndexPath.section == proposedDestinationIndexPath.section ? proposedDestinationIndexPath : sourceIndexPath;
}

- (void)addServer
{
    SCServer *server = [SCServer createEntity];
    server.name = NSLocalizedString(@"NEW_SERVER_NAME_KEY", @"New Server");
    server.port = [NSNumber numberWithInteger:9090];
    server.apiKey = @"";
    server.hostname = @"";
    server.active = [NSNumber numberWithBool:NO];

    SCServerDetailViewController *serverDetailViewController = [[SCServerDetailViewController alloc] initWithNibName:@"SCServerDetailViewController" bundle:nil];
    serverDetailViewController.server = server;
    [self showModalViewController:serverDetailViewController withDoneSystemItem:UIBarButtonSystemItemDone];
}

- (void)viewDidUnload
{
    self.dataSource = nil;
    self.addButton = nil;

    [super viewDidUnload];
}

@end