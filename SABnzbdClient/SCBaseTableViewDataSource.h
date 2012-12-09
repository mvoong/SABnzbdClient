//
//  SCBaseTableViewDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseDataSource.h"

@interface SCBaseTableViewDataSource : SCBaseDataSource <UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
