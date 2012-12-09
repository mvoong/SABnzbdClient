//
//  SCNZBMatrixSearchClient.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchClient.h"

@interface SCNZBMatrixSearchClient : SCSearchClient

+ (NSURL *)urlForNZBId:(NSNumber *)nzbId;
+ (NSURL *)directDownloadURLForNZBId:(NSNumber *)nzbId;
+ (NSURL *)nfoURLForNZBId:(NSNumber *)nzbId;
+ (id)client;

- (NSOperation *)startAccountRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
