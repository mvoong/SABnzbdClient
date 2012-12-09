//
//  SCStatusTransformer.h
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DownloadStatusUnknown,
    DownloadStatusQueued,
    DownloadStatusDownloading,
    DownloadStatusCompleted,
    DownloadStatusGrabbing,
    DownloadStatusPaused, // Guessed this one
    DownloadStatusFailed // Guessed this one
} DownloadStatus;

#define DOWNLOAD_STATUS_STRINGS\
    @"",\
    @"Queued",\
    @"Downloading",\
    @"Completed",\
    @"Grabbing",\
    @"Paused",\
    @"Failed",\
    nil

@interface SCStatusTransformer : NSObject

+ (DownloadStatus)downloadStatusForString:(NSString *)statusString;
+ (DownloadStatus)downloadStatusForNumber:(NSNumber *)downloadStatus;

@end
