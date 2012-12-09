//
//  SCCategoryImporter.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCCategoryImporter.h"

@implementation SCCategoryImporter

+ (void)importCategories
{
    NSString *string = [NSString stringWithContentsOfFile:@"/Users/Mike/Desktop/categories.dat" encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:10];

    for (NSString *line in lines) {
        if (line.length > 5) {
            NSString *idd = [line substringToIndex:[line rangeOfString:@":"].location];
            NSString *name = [line substringFromIndex:[line rangeOfString:@":"].location + 2];
            [categories addObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", idd, @"id", nil]];
        }
    }
}

@end