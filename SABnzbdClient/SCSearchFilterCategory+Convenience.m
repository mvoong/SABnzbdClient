//
//  SCSearchFilterCategory+Convenience.m
//  SABnzbdClient
//
//  Created by Michael Voong on 21/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchFilterCategory+Convenience.h"

@implementation SCSearchFilterCategory (Convenience)

+ (SCSearchFilterCategory *)categoryWithKey:(NSString *)key
{
    return [SCSearchFilterCategory findFirstByAttribute:@"key" withValue:key];
}

@end