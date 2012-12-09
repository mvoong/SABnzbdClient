//
//  SCCategory.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCDownloadItem, SCServer;

@interface SCCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *downloadItems;
@property (nonatomic, retain) SCServer *server;
@end

@interface SCCategory (CoreDataGeneratedAccessors)

- (void)addDownloadItemsObject:(SCDownloadItem *)value;
- (void)removeDownloadItemsObject:(SCDownloadItem *)value;
- (void)addDownloadItems:(NSSet *)values;
- (void)removeDownloadItems:(NSSet *)values;

@end
