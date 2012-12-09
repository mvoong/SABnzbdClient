//
//  SCDataSetup.m
//  SABnzbdClient
//
//  Created by Michael Voong on 21/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDataSetup.h"
#import "SCModels.h"
#import "SCSettingsConstants.h"

@interface SCDataSetup ()

+ (void)createDefaultServer;
+ (void)createSearchAccounts;
+ (void)createSearchFilters;

@end

@implementation SCDataSetup

+ (void)populateWithData
{
    [SCDataSetup createDefaultServer];
    [SCDataSetup createSearchAccounts];
    [SCDataSetup createSearchFilters];
    [SCDataSetup dataDidFinishMigrating];
}

+ (void)createDefaultServer
{
    SCServer *anyServer = [SCServer findFirst];

    if (!anyServer) {
        anyServer = [SCServer createEntity];
        anyServer.active = [NSNumber numberWithBool:NO];
        anyServer.name = NSLocalizedString(@"DEFAULT_SERVER_NAME_KEY", nil);
        anyServer.hostname = @"";
        anyServer.apiKey = @"";
#ifdef DEBUG
        anyServer.hostname = @"192.168.2.2";
        anyServer.apiKey = @"<YourDefaultPassword>";
#endif
        anyServer.port = [NSNumber numberWithInteger:9090];
    }
}

+ (void)createSearchAccounts
{
    SCSearchAccount *searchAccount = nil;

    // NZBMatrix
    searchAccount = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
    
    if (!searchAccount) {
        searchAccount = [SCSearchAccount createEntity];
        searchAccount.key = kSearchAccountKeyNZBMatrix;
        searchAccount.name = @"NZBMatrix";
#ifdef DEBUG
        searchAccount.apiKey = @"<NZBMatrixAPIKey>";
        searchAccount.username = @"<NZBMatrixUsername>";
#endif
    }

    // Binsearch
    searchAccount = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyBinSearch];

    if (!searchAccount) {
        searchAccount = [SCSearchAccount createEntity];
        searchAccount.key = kSearchAccountKeyBinSearch;
        searchAccount.name = @"BinSearch";
        searchAccount.displayIndex = [NSNumber numberWithInteger:100];
    }
}

+ (NSString *)versionString
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (BOOL)needsDataMigration
{
    return ![[[NSUserDefaults standardUserDefaults] stringForKey:kSettingKeyLastMigrated] isEqualToString:[self versionString]];
}

+ (void)dataDidFinishMigrating
{
    NSError *error = nil;
    [[NSManagedObjectContext defaultContext] save:&error];
    
    if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:[self versionString] forKey:kSettingKeyLastMigrated];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {

    }
}

#pragma mark - Importing

+ (void)createSearchFilters
{
    SCSearchAccount *searchAccount = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyNZBMatrix];
    SCSearchFilterCategory *category = nil;
    
    // Add categories if we've verified a valid account
//    if ([searchAccount.verified boolValue]) {
        category = [SCSearchFilterCategory findFirstByAttribute:@"key" withValue:kSearchFilterCategoryKeyNZBMatrixCategory];

        if (!category) {
            category = [SCSearchFilterCategory createEntity];
            category.key = kSearchFilterCategoryKeyNZBMatrixCategory;
            category.name = NSLocalizedString(@"SEARCH_CATEGORY_CATEGORY_KEY", nil);
            category.account = searchAccount;
        }
    
        if ([self needsDataMigration]) {
            // Delete existing
            for (SCSearchFilterItem *item in category.items) {
                [item deleteEntity];
            }
            
            // Add new items
            NSString *path = [[NSBundle mainBundle] pathForResource:@"nzbMatrixCategories" ofType:@"plist"];
            NSArray *categories = [NSArray arrayWithContentsOfFile:path];

            NSUInteger index = 0;

            for (NSDictionary *categoryDictionary in categories) {
                SCSearchFilterItem *item = [SCSearchFilterItem createEntity];
                item.value = [categoryDictionary objectForKey:@"id"];
                item.name = [categoryDictionary objectForKey:@"name"];
                item.displayIndex = [NSNumber numberWithInteger:index++];
                item.category = category;
            }
        }
//    }

    // Max results
    category = [SCSearchFilterCategory findFirstByAttribute:@"key" withValue:kSearchFilterCategoryKeyNZBMatrixMaxResults];

    if (!category) {
        category = [SCSearchFilterCategory createEntity];
        category.key = kSearchFilterCategoryKeyNZBMatrixMaxResults;
        category.name = NSLocalizedString(@"SEARCH_CATEGORY_MAX_RESULTS_KEY", nil);
        category.account = searchAccount;

        NSUInteger i = 0;

        for (NSUInteger maxResults = 10; maxResults <= 50; maxResults += 10) {
            SCSearchFilterItem *item = [SCSearchFilterItem createEntity];
            item.value = [NSString stringWithFormat:@"%i", maxResults];
            item.name = item.value;
            item.displayIndex = [NSNumber numberWithInteger:i++];
            item.category = category;
        }
    }

    searchAccount = [SCSearchAccount findFirstByAttribute:@"key" withValue:kSearchAccountKeyBinSearch];

    // Max results
    category = [SCSearchFilterCategory findFirstByAttribute:@"key" withValue:kSearchFilterCategoryKeyBinSearchMaxResults];

    if (!category) {
        category = [SCSearchFilterCategory createEntity];
        category.key = kSearchFilterCategoryKeyBinSearchMaxResults;
        category.name = NSLocalizedString(@"SEARCH_CATEGORY_MAX_RESULTS_KEY", nil);
        category.account = searchAccount;

        NSArray *increments = [NSArray arrayWithObjects:
                               [NSNumber numberWithInteger:25],
                               [NSNumber numberWithInteger:50],
                               [NSNumber numberWithInteger:100],
                               [NSNumber numberWithInteger:250],
                               nil];

        NSUInteger i = 0;

        for (NSNumber *increment in increments) {
            SCSearchFilterItem *item = [SCSearchFilterItem createEntity];
            item.value = [increment stringValue];
            item.name = item.value;
            item.displayIndex = [NSNumber numberWithInteger:i++];
            item.category = category;
        }
    }
}

@end