//
//  SCSearchAccountSelectionDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@interface SCSearchAccountSelectionDataSource : SCBaseTableViewDataSource

@property (nonatomic, strong, readonly) NSFetchedResultsController *providerFetchedResultsController;

@end
