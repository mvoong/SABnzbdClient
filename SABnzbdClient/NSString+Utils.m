//
//  NSString+Utils.m
//  YouTubeDownloader
//
//  Created by Michael Voong on 06/11/2011.
//  Copyright (c) 2011 Michael Voong. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (NSString *)hourMinuteStringFromSeconds:(NSUInteger)seconds
{
    NSString *mins = [NSString stringWithFormat:@"%02d", seconds / 60];
    NSString *secs = [NSString stringWithFormat:@"%02d", seconds % 60];

    return [NSString stringWithFormat:@"%@:%@", mins, secs];
}

+ (NSString *)stringFromFileSize:(unsigned long long)theSize
{
    float floatSize = theSize;

    if (theSize < 1023)
        return([NSString stringWithFormat:@"%llu bytes", theSize]);

    floatSize = floatSize / 1024;

    if (floatSize < 1023)
        return([NSString stringWithFormat:@"%1.1f KB", floatSize]);

    floatSize = floatSize / 1024;

    if (floatSize < 1023)
        return([NSString stringWithFormat:@"%1.1f MB", floatSize]);

    floatSize = floatSize / 1024;

    // Add as many as you like

    return([NSString stringWithFormat:@"%1.1f GB", floatSize]);
}

+ (NSString *)stringFromSpeed:(unsigned long long)speedBytesPerSecond
{
    float floatSize = speedBytesPerSecond;
    floatSize = floatSize / 1024;

    if (floatSize < 1023)
        return([NSString stringWithFormat:@"%1.1f KB/s", floatSize]);

    floatSize = floatSize / 1024;

    if (floatSize < 1023)
        return([NSString stringWithFormat:@"%1.1f MB/s", floatSize]);

    floatSize = floatSize / 1024;

    // Add as many as you like
    return([NSString stringWithFormat:@"%1.1f GB/s", floatSize]);
}

+ (NSString *)stringFromDuration:(unsigned long long)durationSeconds
{
    NSString *minsFormatString = NSLocalizedString(@"MINUTES_KEY", nil);
    NSString *hourFormatString = NSLocalizedString(@"HOUR_KEY", nil);
    NSString *hoursFormatString = NSLocalizedString(@"HOURS_KEY", nil);

    unsigned long long durationMins = durationSeconds / 60;

    if (durationMins < 60)
        return [NSString stringWithFormat:minsFormatString, durationMins];
    else if (durationMins == 60)
        return [NSString stringWithFormat:hourFormatString, durationMins / 60];
    else
        return [NSString stringWithFormat:hoursFormatString, durationMins / 60];
}

/**
 * Parse from inputs, e.g. 12.5 KB, 15 MB, 15.2 GB
 */
- (NSDecimalNumber *)sizeBytes
{
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      regex = [NSRegularExpression regularExpressionWithPattern:@"(\\S+)\\s(\\S+)"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:NULL];
                  });

    NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];

    if (match.range.location != NSNotFound) {
        NSString *sizeType = [self substringWithRange:[match rangeAtIndex:2]];
        unsigned long long multiplier = 0;

        if ([sizeType compare:@"tb" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            multiplier = 1099511627776;
        else if ([sizeType compare:@"gb" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            multiplier = 1073741824;
        else if ([sizeType compare:@"mb" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            multiplier = 1048576;
        else if ([sizeType compare:@"kb" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            multiplier = 1024;
        else
            multiplier = 1;

        NSDecimalNumber *size = [NSDecimalNumber decimalNumberWithString:[self substringWithRange:[match rangeAtIndex:1]]];
        size = [size decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%llu", multiplier]]];

        return size;
    }

    return nil;
}

- (NSString *)cleanupFilenameString
{
    NSString *newString = [self stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    newString = [newString stringByReplacingOccurrencesOfString:@"  " withString:@" - "];
    newString = [newString stringByReplacingOccurrencesOfString:@"][" withString:@"] ["];
    return newString;
}

- (NSString *)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end