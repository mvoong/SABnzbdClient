//
//  SCSearchFilterItem.h
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCSearchAccount, SCSearchFilterCategory;

@interface SCSearchFilterItem : NSManagedObject

@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) SCSearchFilterCategory *category;
@property (nonatomic, retain) NSSet *searchAccounts;
@end

@interface SCSearchFilterItem (CoreDataGeneratedAccessors)

- (void)addSearchAccountsObject:(SCSearchAccount *)value;
- (void)removeSearchAccountsObject:(SCSearchAccount *)value;
- (void)addSearchAccounts:(NSSet *)values;
- (void)removeSearchAccounts:(NSSet *)values;

@end
