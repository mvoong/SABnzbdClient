//
//  SCServerDetailViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"
#import "SCServer.h"

@class SCServerDetailViewControllerDataSource;

@interface SCServerDetailViewController : SCBaseTableViewController

@property (nonatomic, strong) SCServer *server;
@property (nonatomic, assign) BOOL duplicated;

@end
