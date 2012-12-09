//
//  SCDownloadQueueDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadQueueDataSource.h"
#import "SCDownloadItem.h"
#import "SCServer.h"
#import "SCDownloadItemCell.h"
#import "SCHistoryItemCell.h"
#import "SCSettingsConstants.h"
#import "SCHistoryItem.h"

@interface SCDownloadQueueDataSource ()

@property (nonatomic, strong) SCSABnzbdClient *client;
@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, readwrite) NSFetchedResultsController *historyFetchedResultsController;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL userDrivenModelChange;

@property (nonatomic, strong) NSOperation *statusClientOperation;
@property (nonatomic, strong) NSOperation *historyClientOperation;
@property (nonatomic, strong) NSOperation *switchClientOperation;
@property (nonatomic, strong) NSOperation *removeClientOperation;
@property (nonatomic, strong) NSOperation *pauseClientOperation;

@end

@implementation SCDownloadQueueDataSource

static const NSTimeInterval kDownloadQueueDataSourceStaleTimeSeconds = 60;

- (void)setServer:(SCServer *)server
{
    [self stopTrackingStaleIndication];

    _server = server;
    self.client = [SCSABnzbdClient clientWithServer:_server];

    if (server) {
        // Designed to be called only once
        self.fetchedResultsController = [SCDownloadItem fetchAllSortedBy:@"index"
                                                               ascending:YES
                                                           withPredicate:[NSPredicate predicateWithFormat:@"server = %@", self.server]
                                                                 groupBy:nil
                                                                delegate:self];

        self.historyFetchedResultsController = [SCHistoryItem fetchAllSortedBy:@"completed"
                                                                     ascending:NO
                                                                 withPredicate:[NSPredicate predicateWithFormat:@"server = %@", self.server]
                                                                       groupBy:nil
                                                                      delegate:self];
        
        [self.fetchedResultsController performFetch:NULL];
        [self.historyFetchedResultsController performFetch:NULL];
    }

    [self startTrackingStaleIndicationAgainstObject:server dateKeyPath:@"lastUpdated" staleAgeSeconds:kDownloadQueueDataSourceStaleTimeSeconds];
}

- (void)setSearchTerm:(NSString *)searchTerm
{
    _searchTerm = searchTerm;

    if ([searchTerm length]) {
        self.historyFetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"server = %@ AND name CONTAINS[cd] %@", self.server, self.searchTerm];
        self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"server = %@ AND filename CONTAINS[cd] %@", self.server, self.searchTerm];
    } else {
        self.historyFetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"server = %@", self.server];
        self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"server = %@", self.server];
    }

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {

    }
    [self.historyFetchedResultsController performFetch:&error];
    if (error) {
        
    }
}

- (void)loadData
{
    [super loadData];
    [self stopLoadingData];
    
    // Make active
    self.server.active = [NSNumber numberWithBool:YES];
    
    // Make others not active
    for (SCServer *otherServer in [SCServer findAll]) {
        if (otherServer != self.server && [otherServer.active boolValue]) {
            otherServer.active = [NSNumber numberWithBool:NO];
        }
    }

    self.statusClientOperation = [self.client startStatusRequestWithSuccess:^(NSString *apiError) {
        if (apiError) {
            if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                [self.delegate baseDataSource:self didFailWithError:apiError];
            
            [self didFinishLoading];
            [self scheduleReload];
        } else {
            self.historyClientOperation = [self.client startHistoryRequestWithSuccess:^(NSString *apiError) {
                if (apiError) {
                    if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                        [self.delegate baseDataSource:self didFailWithError:apiError];
                } else {
                    if ([self.delegate respondsToSelector:@selector(baseDataSourceDidSucceed:)])
                        [self.delegate baseDataSourceDidSucceed:self];
                    
                    [self didFinishLoading];
                    
                    [self scheduleReload];
                }
            } failure:^(NSError *error) {
                if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                    [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
                
                [self didFinishLoading];
                [self scheduleReload];
            }];
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
            [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
        
        [self didFinishLoading];
        [self scheduleReload];
    }];
}

- (void)stopLoadingData
{
    [super stopLoadingData];
    [self.timer invalidate];
    [self.historyClientOperation cancel];
    [self.statusClientOperation cancel];
}

- (void)scheduleReload
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[[NSUserDefaults standardUserDefaults] integerForKey:kSettingKeyRefreshRate]
                                                  target:self
                                                selector:@selector(loadData)
                                                userInfo:nil
                                                 repeats:NO];
}

#pragma mark - Data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count] + [[self.historyFetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        id <NSFetchedResultsSectionInfo>sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
        return [sectionInfo numberOfObjects];
    } else {
        id <NSFetchedResultsSectionInfo>sectionInfo = [[self.historyFetchedResultsController sections] objectAtIndex:0];
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    switch (indexPath.section) {
        case 0: {
            static NSString *cellId = @"SCDownloadItemCell";
            SCDownloadItemCell *downloadItemCell = (SCDownloadItemCell *)[tableView dequeueReusableCellWithIdentifier:cellId];

            if (downloadItemCell == nil) {
                downloadItemCell = (SCDownloadItemCell *)[SCDownloadItemCell loadFromNib];
            }

            SCDownloadItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
            downloadItemCell.downloadItem = item;

            cell = downloadItemCell;
            break;
        }

        case 1: {
            static NSString *cellId = @"SCHistoryItemCell";
            SCHistoryItemCell *historyItemCell = (SCHistoryItemCell *)[tableView dequeueReusableCellWithIdentifier:cellId];

            if (historyItemCell == nil) {
                historyItemCell = [SCHistoryItemCell loadFromNib];
            }

            SCHistoryItem *item = [self.historyFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            historyItemCell.historyItem = item;

            cell = historyItemCell;
            break;
        }

        default:
            break;
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"ACTIVE_KEY", nil);
        default:
            return NSLocalizedString(@"HISTORY_KEY", nil);
    }
}

- (BOOL)hasResults
{
    return [self.fetchedResultsController.fetchedObjects count] > 0 || [self.historyFetchedResultsController.fetchedObjects count] > 0;
}

#pragma mark - Editing rows

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    self.userDrivenModelChange = YES;

    id<NSFetchedResultsSectionInfo>sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:sourceIndexPath.section];

    NSMutableArray *items = [NSMutableArray arrayWithArray:[sectionInfo objects]];
    SCDownloadItem *itemToMove = [items objectAtIndex:sourceIndexPath.row];

    // Insert item at new index
    [items removeObject:itemToMove];
    [items insertObject:itemToMove atIndex:destinationIndexPath.row];
    NSUInteger index = 0;

    // Populate new indexes
    for (SCDownloadItem *item in items)
        item.index = [NSNumber numberWithInteger:index++];

    [[NSManagedObjectContext defaultContext] save];

    self.userDrivenModelChange = NO;

    [self.historyClientOperation cancel];
    [self.statusClientOperation cancel];
    [self.removeClientOperation cancel];
    [self.switchClientOperation cancel];
    
    self.switchClientOperation = [self.client startSwitchRequestWithItem:itemToMove
                                                                 toIndex:destinationIndexPath.row
                                                                 success:^(NSString *apiError) {
                                                                     if (apiError) {
                                                                         if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                                                                             [self.delegate baseDataSource:self didFailWithError:apiError];
                                                                     }
                                                                     
                                                                     [self didFinishLoading];
                                                                 } failure:^(NSError *error) {
                                                                     if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                                                                         [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
                                                                     
                                                                     [self didFinishLoading];
                                                                 }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.historyClientOperation cancel];
        [self.statusClientOperation cancel];
        [self.switchClientOperation cancel];
        [self.removeClientOperation cancel];
        
        NSString *mode = nil;
        NSString *nzbID = nil;
        
        if (indexPath.section == 0) {
            SCDownloadItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
            [item deleteEntity];
            mode = @"queue";
            nzbID = item.nzbId;
        } else {
            SCHistoryItem *item = [self.historyFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            [item deleteEntity];
            mode = @"history";
            nzbID = item.nzbId;
        }
        
        self.removeClientOperation = [self.client startRemoveRequestWithNZBID:nzbID
                                                                         mode:mode
                                                                      success:^(NSString *apiError) {
                                                                          if (apiError) {
                                                                              if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                                                                                  [self.delegate baseDataSource:self didFailWithError:apiError];
                                                                          }
                                                                          
                                                                          [self didFinishLoading];
                                                                      } failure:^(NSError *error) {
                                                                          if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                                                                              [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
                                                                          
                                                                          [self didFinishLoading];
                                                                      }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0;
}

#pragma mark - Changing server settings

- (void)pauseForDuration:(NSTimeInterval)seconds
{
    [self.pauseClientOperation cancel];

    if (seconds == -60) {
        // Pause indefinitely
        [self.client startPauseRequestWithSuccess:^(NSString *apiError) {
            if (apiError) {
                if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                    [self.delegate baseDataSource:self didFailWithError:apiError];
            } else {
                [self.downloadQueueDelegate downloadQueueDataSourceDidFinishApplyingConfigSetting:self];
            }
            
            [self didFinishLoading];
            [self loadData];
        } failure:^(NSError *error) {
            if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
        }];
    } else {
        NSString *value = [NSString stringWithFormat:@"%i", (NSInteger)(seconds / 60.0)];
        
        [self.client startConfigSetRequestWithName:@"set_pause" value:value success:^(NSString *apiError) {
            if (apiError) {
                if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                    [self.delegate baseDataSource:self didFailWithError:apiError];
            } else {
                [self.downloadQueueDelegate downloadQueueDataSourceDidFinishApplyingConfigSetting:self];
            }
            
            [self didFinishLoading];
            [self loadData];
        } failure:^(NSError *error) {
            if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
        }];
    }
}

- (void)updateSpeedLimitToSpeed:(NSUInteger)speedKBs
{
    NSString *value = [NSString stringWithFormat:@"%i", speedKBs];
    
    [self.client startConfigSetRequestWithName:@"speedlimit" value:value success:^(NSString *apiError) {
        if (apiError) {
            if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
                [self.delegate baseDataSource:self didFailWithError:apiError];
        } else {
            [self.downloadQueueDelegate downloadQueueDataSourceDidFinishApplyingConfigSetting:self];
        }
        [self didFinishLoading];
        [self loadData];
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
            [self.delegate baseDataSource:self didFailWithError:[error localizedDescription]];
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.userDrivenModelChange)
        [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
    atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (self.userDrivenModelChange)
        return;

    if (controller == self.historyFetchedResultsController)
        sectionIndex = 1;

    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
    atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
    newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.userDrivenModelChange)
        return;

    if (controller == self.historyFetchedResultsController) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
        newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];
    }

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationNone];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.userDrivenModelChange)
        [self.tableView endUpdates];
}

- (void)dealloc
{
    [self stopTrackingStaleIndication];
}

@end