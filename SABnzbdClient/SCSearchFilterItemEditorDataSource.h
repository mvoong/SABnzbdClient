//
//  SCSearchFilterItemEditorDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 19/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@class SCSearchAccount;
@class SCSearchFilterCategory;
@class SCSearchFilterItem;
@class SCSearchFilterItemEditorDataSource;

@protocol  SCSearchFilterItemEditorDataSourceDelegate <SCBaseDataSourceDelegate>

@optional
- (void)searchFilterItemEditorDataSourceDidChangeSearchFilterItem:(SCSearchFilterItemEditorDataSource *)dataSource;

@end

@interface SCSearchFilterItemEditorDataSource : SCBaseTableViewDataSource <UITableViewDelegate>

@property (nonatomic, strong) SCSearchFilterCategory *filterCategory;
@property (nonatomic, strong) SCSearchAccount *searchAccount;
@property (nonatomic, weak) id<SCSearchFilterItemEditorDataSourceDelegate> delegate;

- (BOOL)hasActiveFilter;

@end
