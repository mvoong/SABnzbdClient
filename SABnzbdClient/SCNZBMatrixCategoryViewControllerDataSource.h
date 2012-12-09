//
//  SCNZBMatrixCategoryViewControllerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@interface SCNZBMatrixCategoryViewControllerDataSource : SCBaseTableViewDataSource

- (void)setSearchString:(NSString *)searchString;

@property (nonatomic, strong, readonly) NSFetchedResultsController *categoryFetchedResultsController;

@end
