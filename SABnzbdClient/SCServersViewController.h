//
//  SCServersViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"

@class SCServersViewControllerDataSource;

@interface SCServersViewController : SCBaseTableViewController

@property (nonatomic, strong) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addServer;

@end
