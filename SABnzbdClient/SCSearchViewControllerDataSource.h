//
//  SCSearchViewControllerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"
#import "SCSearchAccount.h"
#import "SCSearchClient.h"

@class SCSearchViewControllerDataSource;

@protocol SCSearchViewControllerDataSourceDelegate <NSObject>

@required
- (void)searchViewControllerDataSourceDidStartLoading:(SCSearchViewControllerDataSource *)dataSource;
- (void)searchViewControllerDataSourceDidFinishLoading:(SCSearchViewControllerDataSource *)dataSource;
- (void)searchViewControllerDataSource:(SCSearchViewControllerDataSource *)dataSource didFailWithError:(NSString *)error;

@optional
- (void)searchViewControllerDataSourceShouldDownloadWithResult:(SCNZBResult *)result;

@end

@interface SCSearchViewControllerDataSource : SCBaseTableViewDataSource <SCSearchClientDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) SCSearchAccount *searchAccount;
@property (nonatomic, weak) id<SCSearchViewControllerDataSourceDelegate> delegate;
@property (nonatomic, assign) SCSearchOrderingScopeBarItem order;
@property (nonatomic, strong, readonly) NSArray *results;

- (void)performSearch:(NSString *)searchTerm;
- (void)clearResults;

@end
