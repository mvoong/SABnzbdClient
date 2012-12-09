//
//  SCHistoryItem.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCServer;

@interface SCHistoryItem : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * completed;
@property (nonatomic, retain) NSString * failMessage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nzbId;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * actionLine;
@property (nonatomic, retain) SCServer *server;

@end
