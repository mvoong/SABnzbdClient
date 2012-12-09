//
//  SCNZBMatrixSearchClient.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixSearchClient.h"
#import "SCNZBResult+Decoding.h"
#import "SCNZBResult.h"
#import "SCSearchFilterItem+Convenience.h"
#import "SCSearchFilterCategory+Convenience.h"
#import "NSString+NZBMatrixParsers.h"
#import "SCDataSetup.h"
#import "SCSearchAccount.h"

@interface SCNZBMatrixSearchClient ()

@property (nonatomic, strong) SCSearchAccount *searchAccount;

+ (NSString *)localisedErrorForErrorCode:(NSString *)errorCode;;
- (NSString *)localisedErrorStringForResponse:(NSString *)responseString;

@end

@implementation SCNZBMatrixSearchClient

static NSString *const kHostAndPort = @"%@://api.nzbmatrix.com/v1.1/";
static NSString *const kNZBNFOURL = @"http://nzbmatrix.com/nzb-details.php?id=%@&type=nfo";
static NSString *const kNZBDirectDownloadURL = @"http://api.nzbmatrix.com/v1.1/download.php?id=%lld&username=%@&apikey=%@";
static NSString *const kNZBNFOURL2 = @"http://nzbmatrix.com/viewnfo.php?id=%@";
static dispatch_queue_t processingQueue;

+ (NSURL *)urlForNZBId:(NSNumber *)nzbId
{
    return [NSURL URLWithString:[NSString stringWithFormat:kNZBNFOURL, nzbId]];
}

+ (NSURL *)directDownloadURLForNZBId:(NSNumber *)nzbId
{
    SCSearchAccount *account = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];

    return [NSURL URLWithString:[NSString stringWithFormat:
                                 kNZBDirectDownloadURL,
                                 [nzbId longLongValue],
                                 account.username,
                                 account.apiKey]];
}

+ (NSURL *)nfoURLForNZBId:(NSNumber *)nzbId
{
    return [NSURL URLWithString:[NSString stringWithFormat:kNZBNFOURL2, [nzbId stringValue]]];
}

+ (NSString *)localisedErrorForErrorCode:(NSString *)errorCode
{
    if ([errorCode isEqualToString:@"error:invalid_login"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_INVALID_LOGIN_KEY", nil);
    else if ([errorCode isEqualToString:@"error:invalid_api"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_INVALID_API_KEY", nil);
    else if ([errorCode isEqualToString:@"error:vip_only"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_VIP_ONLY_KEY", nil);
    else if ([errorCode isEqualToString:@"error:disabled_account"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_DISABLED_ACCOUNT_KEY", nil);
    else if ([errorCode isEqualToString:@"error:no_user"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_NO_USER_KEY", nil);
    else if ([errorCode isEqualToString:@"error:invalid_nzbid"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_INVALID_NZBID_KEY", nil);
    else if ([errorCode isEqualToString:@"error:no_nzb_found"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_NO_NZB_FOUND_KEY", nil);
    else if ([errorCode isEqualToString:@"error:please_wait_x"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_PLEASE_WAIT_X_KEY", nil);
    else if ([errorCode isEqualToString:@"error:x_daily_limit"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_DAILY_LIMIT_KEY", nil);
    else if ([errorCode isEqualToString:@"error:no_search"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_NO_SEARCH_KEY", nil);
    else if ([errorCode isEqualToString:@"error:nothing_found"])
        return NSLocalizedString(@"NO_RESULTS_FOUND_KEY", nil);
    else if ([errorCode isEqualToString:@"error:API_RATE_LIMIT_REACHED"])
        return NSLocalizedString(@"NZBMATRIX_ERROR_RATE_LIMIT_REACHED_KEY", nil);

    return errorCode;
}

+ (id)client
{
    SCSearchAccount *account = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
    NSString *host = [NSString stringWithFormat:kHostAndPort, [account.enableHTTPS boolValue] ? @"https":@"http"];

    return [[self alloc] initWithBaseURL:[NSURL URLWithString:host]];
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];

    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                          processingQueue = dispatch_queue_create ("nzbmatrixsearchclient.processing", 0);
                      });
        self.searchAccount = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
    }

    return self;
}
    
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [allParameters setObject:self.searchAccount.apiKey forKey:@"apikey"];
    [allParameters setObject:self.searchAccount.username forKey:@"username"];
    
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:allParameters];
    
    return request;
}

- (NSOperation *)startSearchRequestWithTerm:(NSString *)searchTerm success:(void (^)(NSArray *results, NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    // 1. Category
    SCSearchFilterItem *categoryFilterItem = [SCSearchFilterItem findItemForAccount:self.searchAccount
                                                                           category:[SCSearchFilterCategory categoryWithKey:kSearchFilterCategoryKeyNZBMatrixCategory]];
    NSString *categoryString = categoryFilterItem ? categoryFilterItem.value : @"";

    // 2. Max results
    SCSearchFilterItem *maxResultsFilterItem = [SCSearchFilterItem findItemForAccount:self.searchAccount
                                                                             category:[SCSearchFilterCategory categoryWithKey:kSearchFilterCategoryKeyNZBMatrixMaxResults]];
    NSString *maxResultsString = maxResultsFilterItem ? maxResultsFilterItem.value : @"";

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                searchTerm, @"search",
                                categoryString, @"catid",
                                maxResultsString, @"num",
                                nil];
    
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"search.php" parameters:parameters];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *localisedError = [self localisedErrorStringForResponse:responseString];
        
        if (!localisedError) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *items = [responseString splitNZBMatrixRecords];
                NSMutableArray *resultingObjects = [NSMutableArray arrayWithCapacity:[items count]];
                NSMutableArray *values = [NSMutableArray arrayWithCapacity:[items count]];
                
                for (NSString *itemString in items) {
                    [values addObject:[itemString parseNZBMatrixRecords]];
                }
                
                dispatch_sync(dispatch_get_main_queue (), ^{
                    if ([operation isCancelled])
                        return;
                    
                    for (NSDictionary *itemValue in values) {
                        SCNZBResult *result = [[SCNZBResult alloc] initWithNZBMatrixValues:itemValue];
                        [resultingObjects addObject:result];
                    }
                    
                    if (successBlock)
                        successBlock(resultingObjects, nil);
                });
            });
        } else {
            if (successBlock)
                successBlock(nil, localisedError);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSOperation *)startAccountRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"account.php" parameters:nil];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // TODO: use account details - we ignore for now, as we just want to use this call for verification
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *localisedError = [self localisedErrorStringForResponse:responseString];
        
        if (!localisedError) {
            // Populate categories
            self.searchAccount.verified = [NSNumber numberWithBool:YES];
            [SCDataSetup populateWithData];
        }
        
        if (successBlock)
            successBlock(localisedError);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

- (NSString *)localisedErrorStringForResponse:(NSString *)responseString
{
    NSRange errorRange = [responseString rangeOfString:@"error:"];

    if (errorRange.location == 0) {
        return [SCNZBMatrixSearchClient localisedErrorForErrorCode:responseString];
    }

    return nil;
}

@end