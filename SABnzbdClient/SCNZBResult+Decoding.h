//
//  SCNZBResult+Decoding.h
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBResult.h"

@class GDataXMLNode;

@interface SCNZBResult (Decoding)

- (id)initWithNZBMatrixValues:(NSDictionary *)values;
- (id)initWithBinSearchValues:(NSDictionary *)values;
- (id)initWithNZBMatrixRSSResult:(GDataXMLNode *)xmlNode;

@end
