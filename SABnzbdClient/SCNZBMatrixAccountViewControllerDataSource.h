//
//  SCNZBMatrixAccountViewControllerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"
#import "SCNZBMatrixSearchClient.h"

@class SCSearchAccount;

@interface SCNZBMatrixAccountViewControllerDataSource : SCBaseTableViewDataSource

@property (nonatomic, strong) SCSearchAccount *account;

- (void)verify;

@end
