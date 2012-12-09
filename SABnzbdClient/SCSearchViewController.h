//
//  SCSearchViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewController.h"
#import "SCSearchViewControllerDataSource.h"
#import "SCSearchFilterCategoriesDataSource.h"
#import "SCSearchResultDetailViewController.h"

@class SCAsynchronousSearchDisplayController;

@interface SCSearchViewController : SCBaseTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, SCSearchViewControllerDataSourceDelegate, UIActionSheetDelegate, SCSearchResultDetailViewControllerDelegate>

@property (nonatomic, strong) IBOutlet SCSearchViewControllerDataSource *dataSource;
@property (nonatomic, strong) IBOutlet SCSearchFilterCategoriesDataSource *categoriesDataSource;
@property (nonatomic, strong) IBOutlet SCAsynchronousSearchDisplayController *asynchronousSearchDisplayController;
@property (nonatomic, strong) SCSearchAccount *account;
@end
