//
//  SCNZBMatrixRSSClient.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixRSSClient.h"
#import "GDataXMLNode.h"

@interface SCNZBMatrixRSSClient ()

@property (nonatomic, strong) SCSearchAccount *searchAccount;

@end

@implementation SCNZBMatrixRSSClient

static NSString *const kHostAndPort = @"%@://rss.nzbmatrix.com";
static NSString *const kNoResultsTitle = @"Error: No Results Found For Your Search";

+ (id)client
{
    SCSearchAccount *account = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
    NSString *host = [NSString stringWithFormat:kHostAndPort, [account.enableHTTPS boolValue] ? @"https":@"http"];
    
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:host]];
}

+ (NSArray *)itemsFromXMLString:(NSString *)xmlString
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:NULL];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:50];
    NSArray *xmlItems = [doc nodesForXPath:@"//item" error:NULL];
    
    for (GDataXMLNode *node in xmlItems) {
        @try {
            id<SCNZBItem> result = [[SCNZBResult alloc] initWithNZBMatrixRSSResult:node];
            if ([[result name] isEqualToString:kNoResultsTitle]) {
                // Don't add this item
                continue;
            }
            
            [results addObject:result];
        } @catch (NSException *exception)
        {
        }
    }

    return results;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.searchAccount = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    NSMutableDictionary *allParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [allParameters setObject:self.searchAccount.apiKey forKey:@"apikey"];
    [allParameters setObject:self.searchAccount.username forKey:@"username"];
//    [allParameters setObject:@"1" forKey:@"maxage"];
    
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:allParameters];
    
    return request;
}

- (NSOperation *)startRSSRequestWithCategoryID:(NSString *)categoryID success:(void (^)(NSArray *items))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSDictionary *parameters = @{ @"page": @"download", @"subcat": categoryID };
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"rss.php" parameters:parameters];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock && ![operation isCancelled]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSArray *results = [SCNZBMatrixRSSClient itemsFromXMLString:responseString];
                                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![operation isCancelled]) {
                        successBlock(results);
                    }
                });
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;
}

@end
