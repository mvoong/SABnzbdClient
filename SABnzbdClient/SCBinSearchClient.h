//
//  SCBinSearchClient.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchClient.h"
#import "SCNZBResult.h"

@class SCBinSearchClient;

@interface SCBinSearchClient : SCSearchClient

+ (id)client;
+ (NSURL *)directDownloadURLForBinSearchId:(NSNumber *)binSearchId;
- (NSArray *)searchResultItemsFromResponse:(NSString *)response;

@end
