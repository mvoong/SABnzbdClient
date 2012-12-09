//
//  SCSearchFilterItemEditorViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 19/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"
#import "SCSearchFilterItemEditorDataSource.h"

@class SCSearchAccount;
@class SCSearchFilterCategory;

@interface SCSearchFilterItemEditorViewController : SCBaseTableViewController <SCSearchFilterItemEditorDataSourceDelegate>

@property (nonatomic, strong) SCSearchAccount *searchAccount;
@property (nonatomic, strong) SCSearchFilterCategory *filterCategory;
@property (nonatomic, strong) IBOutlet SCSearchFilterItemEditorDataSource *dataSource;

@end
