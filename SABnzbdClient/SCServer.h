//
//  SCServer.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCategory, SCDownloadItem, SCHistoryItem, SCServerStatus;

@interface SCServer : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSNumber * enableHTTPS;
@property (nonatomic, retain) NSString * hostname;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSSet *downloadItems;
@property (nonatomic, retain) NSSet *historyItems;
@property (nonatomic, retain) SCServerStatus *status;
@property (nonatomic, retain) NSSet *categories;
@end

@interface SCServer (CoreDataGeneratedAccessors)

- (void)addDownloadItemsObject:(SCDownloadItem *)value;
- (void)removeDownloadItemsObject:(SCDownloadItem *)value;
- (void)addDownloadItems:(NSSet *)values;
- (void)removeDownloadItems:(NSSet *)values;

- (void)addHistoryItemsObject:(SCHistoryItem *)value;
- (void)removeHistoryItemsObject:(SCHistoryItem *)value;
- (void)addHistoryItems:(NSSet *)values;
- (void)removeHistoryItems:(NSSet *)values;

- (void)addCategoriesObject:(SCCategory *)value;
- (void)removeCategoriesObject:(SCCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
