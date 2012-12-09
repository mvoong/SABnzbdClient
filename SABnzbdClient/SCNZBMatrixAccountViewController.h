//
//  SCNZBMatrixAccountViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"
#import "SCNZBMatrixAccountViewControllerDataSource.h"

@class SCSearchAccount;

@interface SCNZBMatrixAccountViewController : SCBaseTableViewController

@property (nonatomic, strong) SCSearchAccount *account;
@property (nonatomic, strong) IBOutlet SCNZBMatrixAccountViewControllerDataSource *dataSource;

@end
