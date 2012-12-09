//
//  SCDownloadItemDetailDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 03/04/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@class SCDownloadItem;

@interface SCDownloadItemDetailDataSource : SCBaseTableViewDataSource

@property (nonatomic, strong) SCDownloadItem *downloadItem;

@end
