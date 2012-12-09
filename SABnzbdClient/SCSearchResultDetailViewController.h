//
//  SCSearchResultDetailViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"
#import "SCSearchResultDetailViewControllerDataSource.h"
#import "SCSABnzbdClient.h"
#import "SCBinSearchClient.h"
#import "SCCategoryPickerDataSource.h"

@class SCSearchResultDetailViewController;

@protocol SCSearchResultDetailViewControllerDelegate <NSObject>

@required
- (void)searchResultDetailViewControllerDidAddDownload:(SCSearchResultDetailViewController *)viewController;

@end

@interface SCSearchResultDetailViewController : SCBaseTableViewController <SCCategoryPickerDataSourceDelegate>

@property (nonatomic, strong) id<SCNZBItem> searchResult;
@property (nonatomic, strong) IBOutlet SCSearchResultDetailViewControllerDataSource *dataSource;
@property (nonatomic, weak) id<SCSearchResultDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *downloadButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

- (IBAction)startDownload;

@end
