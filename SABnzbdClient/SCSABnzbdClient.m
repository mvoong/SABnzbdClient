//
//  SCSABnzbdClient.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSABnzbdClient.h"
#import "AFJSONRequestOperation.h"
#import "SCAppDelegate.h"
#import "SCDownloadItem+JSON.h"
#import "SCCategory.h"
#import "SCServer.h"
#import "SCScript.h"
#import "SCServerStatus+JSON.h"
#import "SCNZBResult.h"
#import "SCHistoryItem+JSON.h"
#import "SCNZBMatrixSearchClient.h"

@interface SCSABnzbdClient ()

- (NSString *)processStatusRequestResponseWithJSON:(id)json;
- (NSString *)processHistoryRequestResponseWithJSON:(id)json;
- (NSString *)processDownloadRequestResponseWithJSON:(id)json;
- (NSString *)processSwitchRequestResponseWithJSON:(id)json;
- (NSString *)processRemoveRequestResponseWithJSON:(id)json;
- (NSString *)processPauseRequestResponseWithJSON:(id)json;
- (NSString *)processConfigSetRequestResponseWithJSON:(id)json;
- (NSString *)errorStringForJSON:(id)json;

@end

@implementation SCSABnzbdClient

@synthesize server = _server;

+ (id)clientWithServer:(SCServer *)server
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%i",
                           [server.enableHTTPS boolValue] ? @"https":@"http",
                           server.hostname,
                           [server.port integerValue]];
    
    SCSABnzbdClient *client = [[self alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    client.server = server;

    return client;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [allParameters setObject:self.server.apiKey forKey:@"apikey"];
    [allParameters setObject:@"json" forKey:@"output"];
    
    NSMutableURLRequest *request = [super requestWithMethod:method path:@"api" parameters:allParameters];
    
    return request;
}

- (NSDictionary *)parameterDictionaryForVerb:(NSString *)verb
{
    return [self parameterDictionaryForVerb:verb otherParameters:nil];
}

- (NSDictionary *)parameterDictionaryForVerb:(NSString *)verb otherParameters:(NSDictionary *)otherParameters
{
    if (otherParameters) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:otherParameters];
        [dictionary setObject:verb forKey:@"mode"];
        
        return [NSDictionary dictionaryWithDictionary:dictionary];
    } else {
        return [NSDictionary dictionaryWithObject:verb forKey:@"mode"];
    }
}

#pragma mark - Requests

- (NSOperation *)startStatusRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
	NSURLRequest *request = [self requestWithMethod:@"GET" path:nil parameters:[self parameterDictionaryForVerb:@"queue"]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processStatusRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startHistoryRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSURLRequest *request = [self requestWithMethod:@"GET"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:@"history" otherParameters:[NSDictionary dictionaryWithObject:@"50" forKey:@"limit"]]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processHistoryRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startDownloadRequestWithURL:(NSURL *)downloadURL name:(NSString *)name category:(SCCategory *)category success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [downloadURL absoluteString], @"name",
                                       nil];

    if (name)
        [parameters setObject:name forKey:@"nzbname"];

    if (category)
        [parameters setObject:category.name forKey:@"cat"];
    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:@"addurl" otherParameters:parameters]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processDownloadRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startSwitchRequestWithItem:(SCDownloadItem *)item toIndex:(NSUInteger)index success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                item.nzbId, @"value",
                                [[NSNumber numberWithInteger:index] stringValue], @"value2",
                                nil];
    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:@"switch" otherParameters:parameters]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processSwitchRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);

    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startRemoveRequestWithNZBID:(NSString *)nzbID mode:(NSString *)mode success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"delete", @"name",
                                nzbID, @"value",
                                nil];
    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:mode otherParameters:parameters]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processRemoveRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;    
}

- (NSOperation *)startPauseRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:@"pause"]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processPauseRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startConfigSetRequestWithName:(NSString *)name value:(NSString *)value success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"name",
                                value, @"value",
                                nil];

    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:@"config" otherParameters:parameters]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processConfigSetRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
        
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startChangeRequestForMode:(NSString *)mode value1:(NSString *)value1 value2:(NSString *)value2 success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                value1, @"value",
                                value2, @"value2",
                                nil];
    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:mode otherParameters:parameters]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processConfigSetRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startPriorityChangeRequestForNzbId:(NSString *)nzbId priority:(SCSABnzbdItemPriority)priority success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"priority", @"name",
                                nzbId, @"value",
                                [NSString stringWithFormat:@"%i", priority], @"value2",
                                nil];
    
    NSURLRequest *request = [self requestWithMethod:@"POST"
                                               path:nil
                                         parameters:[self parameterDictionaryForVerb:@"queue" otherParameters:parameters]];
    
    AFHTTPRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *apiError = [self processConfigSetRequestResponseWithJSON:JSON];
        if (successBlock)
            successBlock(apiError);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

#pragma mark - Processing

- (NSString *)processStatusRequestResponseWithJSON:(id)json
{
    NSString *apiErrorString = [self errorStringForJSON:json];
    
    if (!apiErrorString) {
        // Categories
        NSMutableSet *categories = [NSMutableSet set];

        for (NSString *categoryName in [json valueForKeyPath:@"queue.categories"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"server = %@ AND name = %@", self.server, categoryName];
            SCCategory *category = [SCCategory findFirstWithPredicate:predicate];

            if (!category)
                category = [SCCategory createEntity];

            category.name = categoryName;
            [categories addObject:category];
        }

        // Delete ones that don't exist anymore
        for (SCCategory *category in self.server.categories) {
            if (![categories containsObject:category])
                [category deleteEntity];
        }

        self.server.categories = categories;
        
        // Scripts
        NSMutableSet *scripts = [NSMutableSet setWithCapacity:10];
        
        for (NSString *scriptName in [json valueForKeyPath:@"queue.scripts"]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", scriptName];
            SCScript *script = [SCScript findFirstWithPredicate:predicate];
            
            if (!script) {
                script = [SCScript createEntity];
            }
            
            script.name = scriptName;
            [scripts addObject:script];
        }
        
        // Delete ones that don't exist anymore
        for (SCScript *script in [SCScript findAll]) {
            if (![scripts containsObject:script]) {
                [script deleteEntity];
            }
            }

        // Download items
        NSMutableSet *downloadItems = [NSMutableSet set];

        for (NSDictionary *jobItem in [json valueForKeyPath:@"queue.slots"]) {
            // Search for existing items
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"server = %@ AND nzbId = %@",
                                      self.server,
                                      [jobItem objectForKey:@"nzo_id"]];
            SCDownloadItem *downloadItem = [SCDownloadItem findFirstWithPredicate:predicate];

            if (!downloadItem)
                downloadItem = [SCDownloadItem createEntity];

            downloadItem.server = self.server;
            [downloadItem populateFromJSON:jobItem];
            [downloadItems addObject:downloadItem];
        }

        // Delete ones that don't exist anymore
        for (SCDownloadItem *item in self.server.downloadItems) {
            if (![downloadItems containsObject:item])
                [item deleteEntity];
        }

        self.server.downloadItems = downloadItems;

        // Status
        SCServerStatus *status = self.server.status;

        if (!status)
            status = [SCServerStatus createEntity];

        [status populateFromJSON:[json objectForKey:@"queue"]];
        self.server.status = status;
        self.server.lastUpdated = [NSDate date];

        [[NSManagedObjectContext defaultContext] save];
    }
    
    return apiErrorString;
}

- (NSString *)processHistoryRequestResponseWithJSON:(id)json
{
    NSString *apiErrorString = [self errorStringForJSON:json];
    
    if (!apiErrorString) {
        NSMutableArray *historyItems = [NSMutableArray array];

        for (NSDictionary *jobItem in [json valueForKeyPath : @"history.slots"]) {
            // Search for existing items
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"server = %@ AND nzbId = %@",
                                      self.server,
                                      [jobItem objectForKey:@"nzo_id"]];
            SCHistoryItem *historyItem = [SCHistoryItem findFirstWithPredicate:predicate];

            if (!historyItem)
                historyItem = [SCHistoryItem createEntity];

            [historyItem populateFromJSON:jobItem];
            [historyItems addObject:historyItem];
            [self.server addHistoryItemsObject:historyItem];
        }

        // Delete ones that don't exist anymore
        for (SCHistoryItem *item in self.server.historyItems) {
            if (![historyItems containsObject:item]) {
                [item deleteEntity];
            }
        }

        [[NSManagedObjectContext defaultContext] save];
    }
    
    return apiErrorString;
}

- (NSString *)processDownloadRequestResponseWithJSON:(id)json
{
    return [self errorStringForJSON:json];
}

- (NSString *)processSwitchRequestResponseWithJSON:(id)json
{
    return [self errorStringForJSON:json];
}

- (NSString *)processRemoveRequestResponseWithJSON:(id)json
{
    return [self errorStringForJSON:json];
}

- (NSString *)processPauseRequestResponseWithJSON:(id)json
{
    return [self errorStringForJSON:json];
}

- (NSString *)processConfigSetRequestResponseWithJSON:(id)json
{
    return [self errorStringForJSON:json];
}

#pragma mark - Utilities

- (NSString *)errorStringForJSON:(id)json
{
    if ([json objectForKey:@"error"]) {
        return [json objectForKey:@"error"];
    }

    return nil;
}

@end