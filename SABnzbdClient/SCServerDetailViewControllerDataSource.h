//
//  SCServerDetailViewControllerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"
#import "SCServer.h"

@interface SCServerDetailViewControllerDataSource : SCBaseTableViewDataSource

@property (nonatomic, strong) SCServer *server;

@end
