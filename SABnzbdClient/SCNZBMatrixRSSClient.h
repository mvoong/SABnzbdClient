//
//  SCNZBMatrixRSSClient.h
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerClient.h"

@interface SCNZBMatrixRSSClient : SCServerClient

+ (id)client;
- (NSOperation *)startRSSRequestWithCategoryID:(NSString *)categoryID success:(void (^)(NSArray *items))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
