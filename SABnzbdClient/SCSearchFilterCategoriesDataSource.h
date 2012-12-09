//
//  SCSearchFilterCategoriesDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@class SCSearchAccount;

@interface SCSearchFilterCategoriesDataSource : SCBaseTableViewDataSource <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SCSearchAccount *searchAccount;

@end
