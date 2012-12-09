//
//  NSString+NZBMatrixParsers.h
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NZBMatrixParsers)

- (NSArray *)splitNZBMatrixRecords;
- (NSDictionary *)parseNZBMatrixRecords;

@end
