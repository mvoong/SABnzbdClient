//
//  SCDownloadQueueDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"
#import "SCSABnzbdClient.h"

@class SCDownloadQueueDataSource;

@protocol SCDownloadQueueDataSourceDelegate <NSObject>

@required
- (void)downloadQueueDataSourceDidFinishApplyingConfigSetting:(SCDownloadQueueDataSource *)dataSource;

@end

@interface SCDownloadQueueDataSource : SCBaseTableViewDataSource <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet id<SCDownloadQueueDataSourceDelegate> downloadQueueDelegate;
@property (nonatomic, strong) SCServer *server;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, readonly) NSFetchedResultsController *historyFetchedResultsController;

- (void)pauseForDuration:(NSTimeInterval)seconds;
- (void)updateSpeedLimitToSpeed:(NSUInteger)speedKBs;
- (BOOL)hasResults;

@end
