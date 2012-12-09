//
//  NSString+NZBMatrixDateParser.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "NSString+NZBMatrixDateParser.h"

@implementation NSString (NZBMatrixDateParser)

/**
 * Parses dates like 2009-02-14 09:08:55
 */
- (NSDate *)dateFromNZBMatrixString
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      dateFormatter = [[NSDateFormatter alloc] init];
                      dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                      dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                      dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                  });
    return [dateFormatter dateFromString:self];
}

@end