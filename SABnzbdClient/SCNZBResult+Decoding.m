//
//  SCNZBResult+Decoding.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBResult+Decoding.h"
#import "NSString+NZBMatrixDateParser.h"
#import "NSString+Utils.h"
#import "GDataXMLNode.h"
#import "SCNZBMatrixSearchClient.h"
#import "SCBinSearchClient.h"

@implementation SCNZBResult (Decoding)

- (id)initWithNZBMatrixValues:(NSDictionary *)values
{
    self = [super init];
    if (self) {
        for (NSString *key in [values allKeys]) {
            NSString *value = [values objectForKey:key];

            if ([key isEqualToString:@"NZBID"])
                self.nzbId = [NSNumber numberWithLongLong:[value longLongValue]];
            else if ([key isEqualToString:@"NZBNAME"])
                self.name = [value cleanupFilenameString];
            else if ([key isEqualToString:@"LINK"])
                self.link = value;
            else if ([key isEqualToString:@"SIZE"])
                self.size = [NSDecimalNumber decimalNumberWithString:value];
            else if ([key isEqualToString:@"INDEX_DATE"])
                self.indexDate = [value dateFromNZBMatrixString];
            else if ([key isEqualToString:@"USENET_DATE"])
                self.usenetDate = [value dateFromNZBMatrixString];
            else if ([key isEqualToString:@"CATEGORY"])
                self.category = value;
            else if ([key isEqualToString:@"GROUP"])
                self.group = value;
            else if ([key isEqualToString:@"COMMENTS"])
                self.comments = [NSNumber numberWithInteger:[value integerValue]];
            else if ([key isEqualToString:@"HITS"])
                self.hits = [NSNumber numberWithInteger:[value integerValue]];
            else if ([key isEqualToString:@"NFO"])
                self.hasNFO = [value isEqualToString:@"yes"] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
            else if ([key isEqualToString:@"WEBLINK"])
                self.webLink = value;
            else if ([key isEqualToString:@"LANGUAGE"])
                self.language = value;
            else if ([key isEqualToString:@"IMAGE"])
                self.imageURL = value;
            else if ([key isEqualToString:@"REGION"])
                self.region = [NSNumber numberWithInteger:[value integerValue]];
        }
        
        // Download URL
        self.downloadURL = [SCNZBMatrixSearchClient directDownloadURLForNZBId:self.nzbId];
        
        // IMDB
        static NSRegularExpression *imdbIdRegEx = nil;
        static dispatch_once_t onceToken5;
        dispatch_once(&onceToken5, ^{
            imdbIdRegEx = [NSRegularExpression regularExpressionWithPattern:@"imdb\\..+/title/(tt\\d+)" options:NSRegularExpressionCaseInsensitive error:NULL];
        });
        
        if (self.webLink) {
            NSTextCheckingResult *imdbIdMatch = [imdbIdRegEx firstMatchInString:self.webLink options:0 range:NSMakeRange(0, [self.webLink length])];
            
            if (imdbIdMatch) {
                self.imdbTitleID = [[self.webLink substringWithRange:[imdbIdMatch rangeAtIndex:1]] trimmedString];
            }
        }
    }
    
    return self;
}

- (id)initWithBinSearchValues:(NSDictionary *)values
{
    self = [super init];
    
    if (self) {
        self.name = [values objectForKey:@"name"];
        self.nzbId = [values objectForKey:@"binSearchId"];
        self.size = [[values objectForKey:@"size"] sizeBytes];

        NSString *ageDaysString = [values objectForKey:@"age"];
        NSString *ageType = [ageDaysString substringFromIndex:[ageDaysString length] - 1];
        float age = [[ageDaysString substringToIndex:[ageDaysString length] - 1] floatValue];

        // Convert to seconds
        if ([ageType isEqualToString:@"m"])
            age *= 60;
        else if ([ageType isEqualToString:@"h"])
            age *= 3600;
        else if ([ageType isEqualToString:@"d"])
            age *= 3600 * 24;

        self.usenetDate = [NSDate dateWithTimeInterval:-age sinceDate:[NSDate date]];
        self.group = [values objectForKey:@"group"];
        self.downloadURL = [SCBinSearchClient directDownloadURLForBinSearchId:self.nzbId];
    }
    
    return self;
}

- (id)initWithNZBMatrixRSSResult:(GDataXMLNode *)xmlNode
{
    self = [super init];
    if (self) {
        self.name = [[xmlNode nodesForXPath:@".//title" error:NULL][0] stringValue];
        
        // Has NFO
        NSString *description = [[xmlNode nodesForXPath:@".//description" error:NULL][0] stringValue];
        self.hasNFO = [description rangeOfString:@"View NFO"].location != NSNotFound ? @(YES) : @(NO);
        
        // Size
        static NSRegularExpression *sizeRegEx = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sizeRegEx = [NSRegularExpression regularExpressionWithPattern:@"Size:\\</b\\>(.+?)\\<br" options:0 error:NULL];
        });
        
        NSTextCheckingResult *result = [sizeRegEx firstMatchInString:description options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [description length])];
        NSString *sizeString = [[description substringWithRange:[result rangeAtIndex:1]] trimmedString];
        self.size = [sizeString sizeBytes];
        
        // Added date
        static NSRegularExpression *addedRegEx = nil;
        static dispatch_once_t onceToken2;
        dispatch_once(&onceToken2, ^{
            addedRegEx = [NSRegularExpression regularExpressionWithPattern:@"Added:\\</b\\>(.+?)\\<br" options:0 error:NULL];
        });
        
        NSTextCheckingResult *addedMatch = [addedRegEx firstMatchInString:description options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [description length])];
        NSString *dateString = [[description substringWithRange:[addedMatch rangeAtIndex:1]] trimmedString];
        self.indexDate = [dateString dateFromNZBMatrixString];
        
        // Group
        static NSRegularExpression *groupRegEx = nil;
        static dispatch_once_t onceToken3;
        dispatch_once(&onceToken3, ^{
            groupRegEx = [NSRegularExpression regularExpressionWithPattern:@"Group:\\</b\\>(.+?)\\<BR" options:NSRegularExpressionCaseInsensitive error:NULL];
        });
        
        NSTextCheckingResult *groupMatch = [groupRegEx firstMatchInString:description options:0 range:NSMakeRange(0, [description length])];
        
        if (groupMatch) {
            NSString *groupString = [[description substringWithRange:[groupMatch rangeAtIndex:1]] trimmedString];
            self.group = groupString;
        }
        
        // NZB ID
        static NSRegularExpression *nzbIdRegEx = nil;
        static dispatch_once_t onceToken4;
        dispatch_once(&onceToken4, ^{
            nzbIdRegEx = [NSRegularExpression regularExpressionWithPattern:@"nzb-details\\.php\\?id=(\\d+)" options:NSRegularExpressionCaseInsensitive error:NULL];
        });
        
        NSTextCheckingResult *nzbIdMatch = [nzbIdRegEx firstMatchInString:description options:0 range:NSMakeRange(0, [description length])];
        NSString *nzbIdString = [[description substringWithRange:[nzbIdMatch rangeAtIndex:1]] trimmedString];
        self.nzbId = [NSNumber numberWithLongLong:[nzbIdString longLongValue]];
        
        // IMDB ID
        static NSRegularExpression *imdbIdRegEx = nil;
        static dispatch_once_t onceToken5;
        dispatch_once(&onceToken5, ^{
            imdbIdRegEx = [NSRegularExpression regularExpressionWithPattern:@"imdb\\..+/title/(tt\\d+)" options:NSRegularExpressionCaseInsensitive error:NULL];
        });
        
        NSTextCheckingResult *imdbIdMatch = [imdbIdRegEx firstMatchInString:description options:0 range:NSMakeRange(0, [description length])];
        
        if (imdbIdMatch) {
            NSString *imdbIdString = [[description substringWithRange:[imdbIdMatch rangeAtIndex:1]] trimmedString];
            self.imdbTitleID = imdbIdString;
        }
        
        self.downloadURL = [SCNZBMatrixSearchClient directDownloadURLForNZBId:[self nzbId]];
    }
    
    return self;
}

@end