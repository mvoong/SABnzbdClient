//
//  SCBinSearchClient.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBinSearchClient.h"
#import "GDataXMLNode.h"
#import "NSString+HTML.h"
#import "SCNZBResult+Decoding.h"
#import "SCSearchAccount.h"
#import "SCSearchFilterCategory.h"
#import "SCSearchFilterItem.h"

@implementation SCBinSearchClient

static NSString *const kBinSearchHost = @"http://binsearch.info";
static NSString *const kBinSearchPath = @"index.php";
static NSString *const kBinSearchEndpoint = @"q=%@&max=%@&adv_age=1100&adv_sort=date&adv_col=on";
static NSString *const kBinSearchNZBEndpoint = @"http://binsearch.info/?action=nzb&%llu=1";

+ (NSURL *)directDownloadURLForBinSearchId:(NSNumber *)binSearchId
{
    return [NSURL URLWithString:[NSString stringWithFormat:kBinSearchNZBEndpoint, [binSearchId longLongValue]]];
}

+ (id)client
{
    return [[self alloc] initWithBaseURL:[NSURL URLWithString:kBinSearchHost]];
}

- (NSOperation *)startSearchRequestWithTerm:(NSString *)searchTerm success:(void (^)(NSArray *results, NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString *maxResults = @"25";
    SCSearchAccount *account = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyBinSearch];

    for (SCSearchFilterItem *filterItem in account.filterItems) {
        if ([filterItem.category.key isEqualToString:kSearchFilterCategoryKeyBinSearchMaxResults])
            maxResults = filterItem.value;
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                searchTerm, @"q",
                                maxResults, @"max",
                                @"1100", @"adv_age",
                                @"date", @"adv_sort",
                                @"on", @"adv_col",
                                nil];
    NSURLRequest *urlRequest = [self requestWithMethod:@"GET" path:kBinSearchPath parameters:parameters];

    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSArray *itemDictionaries = [self searchResultItemsFromResponse:responseString];
            
            dispatch_sync (dispatch_get_main_queue (), ^{
                if (![operation isCancelled]) {
                    NSMutableArray *results = [NSMutableArray array];
                    
                    for (NSDictionary *itemDictionary in itemDictionaries) {
                        SCNZBResult *result = [[SCNZBResult alloc] initWithBinSearchValues:itemDictionary];
                        [results addObject:result];
                    }
                    
                    if ([results count] > 0) {
                        if (successBlock)
                            successBlock(results, nil);
                    } else {
                        if (successBlock)
                            successBlock(nil, NSLocalizedString(@"NO_RESULTS_FOUND_KEY", nil));
                    }
                }
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock)
            failureBlock(error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
    
    return operation;

}

- (NSArray *)searchResultItemsFromResponse:(NSString *)response
{
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLString:response options:0 error:NULL];
    NSArray *rows = [doc nodesForXPath:@"//table[@id='r2']//tr[@bgcolor!='#ffffbb']" error:NULL];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:50];

    for (GDataXMLNode *node in rows) {
        // I hardly ever use try and catch, but in this case, it's good, as we never know what problems the screen scraping will
        // cause when the site changes markup
        @try {
            NSArray *columns = [node nodesForXPath:@".//td" error:NULL];
            GDataXMLElement *checkboxNode = (GDataXMLElement *)[[[columns objectAtIndex:1] nodesForXPath:@".//input[@type='checkbox']" error:NULL] objectAtIndex:0];
            GDataXMLNode *nameNode = [[[columns objectAtIndex:2] nodesForXPath:@".//span[@class='s']" error:NULL] objectAtIndex:0];

            // Might not have a 'd' node
            NSArray *descriptionNodes = [[columns objectAtIndex:2] nodesForXPath:@".//span[@class='d']" error:NULL];
            GDataXMLNode *descriptionNode = [descriptionNodes count] ? [descriptionNodes objectAtIndex:0] : nil;

            GDataXMLNode *groupNode = [[[columns objectAtIndex:4] nodesForXPath:@"./a" error:NULL] objectAtIndex:0];
            GDataXMLNode *ageNode = [columns objectAtIndex:5];

            long long binSearchId = [[[checkboxNode attributeForName:@"name"] stringValue] longLongValue];
            NSString *name = [[[nameNode stringValue] stringByRemovingNewLinesAndWhitespace] stringByDecodingHTMLEntities];
            NSString *size = [self extractSizeFromDescription:[[descriptionNode stringValue] stringByRemovingNewLinesAndWhitespace]];
            NSString *group = [[groupNode stringValue] stringByRemovingNewLinesAndWhitespace];
            NSString *age = [[ageNode stringValue] stringByRemovingNewLinesAndWhitespace];

            NSDictionary *itemDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            name, @"name",
                                            age, @"age",
                                            group, @"group",
                                            [NSNumber numberWithLongLong:binSearchId], @"binSearchId",
                                            size, @"size",
                                            nil];
            [items addObject:itemDictionary];
        }@catch (NSException *exception)
        {
        }
        @finally {
        }
    }

    return items;
}

- (NSString *)extractSizeFromDescription:(NSString *)description
{
    if (![description length])
        return nil;

    description = [description stringByDecodingHTMLEntities];
    description = [description stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"size:\\s*([^\\,]+)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:description options:0 range:NSMakeRange(0, [description length])];

    if (match.range.location != NSNotFound)
        return [description substringWithRange:[match rangeAtIndex:1]];

    return nil;
}

@end