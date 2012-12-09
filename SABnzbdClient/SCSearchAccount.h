//
//  SCSearchAccount.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCNZBResult, SCSearchFilterCategory, SCSearchFilterItem;

@interface SCSearchAccount : NSManagedObject

@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSNumber * enableHTTPS;
@property (nonatomic, retain) NSNumber * enableSceneName;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSSet *availableFilterCategories;
@property (nonatomic, retain) NSSet *filterItems;
@end

@interface SCSearchAccount (CoreDataGeneratedAccessors)

- (void)addAvailableFilterCategoriesObject:(SCSearchFilterCategory *)value;
- (void)removeAvailableFilterCategoriesObject:(SCSearchFilterCategory *)value;
- (void)addAvailableFilterCategories:(NSSet *)values;
- (void)removeAvailableFilterCategories:(NSSet *)values;

- (void)addFilterItemsObject:(SCSearchFilterItem *)value;
- (void)removeFilterItemsObject:(SCSearchFilterItem *)value;
- (void)addFilterItems:(NSSet *)values;
- (void)removeFilterItems:(NSSet *)values;

@end
