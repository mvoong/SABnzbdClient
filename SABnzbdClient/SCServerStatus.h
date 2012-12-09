//
//  SCServerStatus.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SCServer;

@interface SCServerStatus : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * currentSpeed;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * paused;
@property (nonatomic, retain) SCServer *server;

@end
