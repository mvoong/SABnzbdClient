//
//  SCDownloadItemDetailViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 03/04/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"

@class SCDownloadItem;

@interface SCDownloadItemDetailViewController : SCBaseTableViewController

@property (nonatomic, strong) SCDownloadItem *downloadItem;

@end
