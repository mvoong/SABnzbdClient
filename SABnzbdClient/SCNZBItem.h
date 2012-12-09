//
//  SCNZBItem.h
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCNZBItem <NSObject>

@required
- (NSString *)category;
- (NSNumber *)nzbId;
- (NSNumber *)hasNFO;
- (NSDecimalNumber *)size;
- (NSDate *)indexDate;
- (NSString *)group;
- (NSString *)name;
- (NSURL *)downloadURL;

@optional
- (NSString *)webLink;
- (NSString *)imageURL;
- (NSNumber *)comments;
- (NSDate *)usenetDate;
- (NSString *)language;
- (NSString *)region;
- (NSNumber *)hits;
- (NSString *)imdbTitleID;

@end
