//
//  SCDownloadItem.h
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCCategory, SCServer;

@interface SCDownloadItem : NSManagedObject

@property (nonatomic, retain) NSString * averageAge;
@property (nonatomic, retain) NSString * eta;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * nzbId;
@property (nonatomic, retain) NSNumber * paused;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSString * script;
@property (nonatomic, retain) NSDecimalNumber * sizeMB;
@property (nonatomic, retain) NSDecimalNumber * sizeRemainingMB;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * timeRemaining;
@property (nonatomic, retain) NSNumber * unpackOperations;
@property (nonatomic, retain) SCCategory *category;
@property (nonatomic, retain) SCServer *server;

@end
