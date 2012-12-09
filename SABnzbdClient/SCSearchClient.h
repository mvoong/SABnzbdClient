//
//  SCSearchClient.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerClient.h"

@class SCSearchClient;

@protocol SCSearchClientDelegate

@optional
- (void)searchClientDidUpdateResults:(SCSearchClient *)client;
- (void)searchClientDidVerifyAccount:(SCSearchClient *)client;

@end

@interface SCSearchClient : SCServerClient

@property (nonatomic, weak) id<SCSearchClientDelegate> delegate;

- (NSOperation *)startSearchRequestWithTerm:(NSString *)searchTerm success:(void (^)(NSArray *results, NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
