//
//  SCSearchFilterCategory.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCSearchAccount, SCSearchFilterItem;

@interface SCSearchFilterCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * editable;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderIndex;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) SCSearchAccount *account;
@end

@interface SCSearchFilterCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(SCSearchFilterItem *)value;
- (void)removeItemsObject:(SCSearchFilterItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
