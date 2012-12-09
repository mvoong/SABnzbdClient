//
//  SCSearchClient.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchClient.h"

@implementation SCSearchClient

@synthesize delegate = _delegate;

- (NSOperation *)startSearchRequestWithTerm:(NSString *)searchTerm success:(void (^)(NSArray *, NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    return nil;
}

@end