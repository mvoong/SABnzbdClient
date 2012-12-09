//
//  SCStatusTransformer.m
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCStatusTransformer.h"

@implementation SCStatusTransformer

+ (DownloadStatus)downloadStatusForString:(NSString *)statusString
{
    static NSArray *statusStrings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      statusStrings = [NSArray arrayWithObjects:DOWNLOAD_STATUS_STRINGS];
                  });

    return (DownloadStatus)[statusStrings indexOfObject : statusString];
}

+ (DownloadStatus)downloadStatusForNumber:(NSNumber *)downloadStatus
{
    return (DownloadStatus)[downloadStatus integerValue];
}

@end