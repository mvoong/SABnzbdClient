//
//  SCDownloadQueueViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"
#import "SCDownloadQueueDataSource.h"
#import "SCPauseActionSheetPickerDataSource.h"
#import "SCSpeedLimitActionSheetPickerDataSource.h"

@class SCServer;
@class SCToolbarInfoView;

@interface SCDownloadQueueViewController : SCBaseTableViewController <SCBaseDataSourceDelegate, UIActionSheetDelegate, UISearchBarDelegate, UISearchDisplayDelegate, SCPauseSelectionViewDelegate, SCSpeedLimitSelectionViewDelegate, SCDownloadQueueDataSourceDelegate>

@property (nonatomic, strong) IBOutlet SCDownloadQueueDataSource *dataSource;
//@property (strong, nonatomic) IBOutlet SCDownloadQueueDataSource *searchDataSource;
@property (nonatomic, strong) SCServer *server;
@property (strong, nonatomic) IBOutlet SCToolbarInfoView *toolbarInfoView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *speedButton;

- (IBAction)showPauseActionSheet;
- (IBAction)showSpeedActionSheet;
- (IBAction)showSearchViewController;

@end
