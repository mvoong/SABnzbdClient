//
//  SCServer.m
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServer.h"
#import "SCCategory.h"
#import "SCDownloadItem.h"
#import "SCHistoryItem.h"
#import "SCServerStatus.h"

@implementation SCServer

@dynamic active;
@dynamic apiKey;
@dynamic enableHTTPS;
@dynamic hostname;
@dynamic index;
@dynamic lastUpdated;
@dynamic name;
@dynamic port;
@dynamic downloadItems;
@dynamic historyItems;
@dynamic status;
@dynamic categories;

@end