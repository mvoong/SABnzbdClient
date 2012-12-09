//
//  SCNZBResult.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNZBResult : NSObject <SCNZBItem>

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSNumber *comments;
@property (nonatomic, retain) NSString *group;
@property (nonatomic, retain) NSNumber *hasNFO;
@property (nonatomic, retain) NSNumber *hits;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSDate *indexDate;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *nzbId;
@property (nonatomic, retain) NSNumber *region;
@property (nonatomic, retain) NSDecimalNumber *size;
@property (nonatomic, retain) NSDate *usenetDate;
@property (nonatomic, retain) NSString *webLink;
@property (nonatomic, copy) NSString *imdbTitleID;
@property (nonatomic, retain) NSURL *downloadURL;

@end
