//
//  SCBaseTableViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseScrollViewViewController.h"
#import "SCBaseTableViewDataSource.h"

@interface SCBaseTableViewController : SCBaseScrollViewViewController <UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet SCBaseDataSource *dataSource;

- (UIView *)offsetTableForView;

@end
