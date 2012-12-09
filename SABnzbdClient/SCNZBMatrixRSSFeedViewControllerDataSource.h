//
//  SCNZBMatrixRSSFeedViewControllerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@protocol SCNZBMatrixRSSFeedViewControllerDataSourceDelegate <NSObject>

@optional
- (void)rssFeedViewControllerDataSourceShouldDownloadWithResult:(id<SCNZBItem>)result;

@end

@interface SCNZBMatrixRSSFeedViewControllerDataSource : SCBaseTableViewDataSource

@property (nonatomic, strong, readonly) NSArray *results;
@property (nonatomic, strong) SCSearchFilterItem *filterItem; // Category, e.g. Movies > DivX
@property (nonatomic, weak) id<SCNZBMatrixRSSFeedViewControllerDataSourceDelegate> delegate;

@end
