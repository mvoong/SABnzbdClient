//
//  SCBaseTableViewDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@interface SCBaseTableViewDataSource ()

@end

@implementation SCBaseTableViewDataSource

@synthesize tableView = _tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)setStale:(BOOL)stale
{
    super.stale = stale;

    self.tableView.alpha = stale ? 0.3 : 1;
    self.tableView.userInteractionEnabled = !stale;
}

@end