//
//  NSString+NZBMatrixParsers.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "NSString+NZBMatrixParsers.h"

@implementation NSString (NZBMatrixParsers)

- (NSArray *)splitNZBMatrixRecords
{
    NSArray *components = [self componentsSeparatedByString:@"|"];
    NSMutableArray *records = [NSMutableArray arrayWithCapacity:[components count]];

    for (NSString *component in components) {
        // Filter out empty records
        if ([[component componentsSeparatedByString:@"\n"] count] > 2)
            [records addObject:component];
    }

    return records;
}

- (NSDictionary *)parseNZBMatrixRecords
{
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:20];

    for (NSString *line in [self componentsSeparatedByString : @"\n"]) {
        NSRange separatorPosition = [line rangeOfString:@":"];

        if (separatorPosition.location != NSNotFound) {
            NSString *key = [line substringToIndex:separatorPosition.location];
            NSString *value = [line substringWithRange:NSMakeRange(separatorPosition.location + 1, [line length] - separatorPosition.location - 2)];

            [result setObject:value forKey:key];
        }
    }

    return result;
}

@end