//
//  NSString+Utils.h
//  YouTubeDownloader
//
//  Created by Michael Voong on 06/11/2011.
//  Copyright (c) 2011 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

+ (NSString *)hourMinuteStringFromSeconds:(NSUInteger)seconds;
+ (NSString *)stringFromFileSize:(unsigned long long)theSize;
+ (NSString *)stringFromSpeed:(unsigned long long)speedBytesPerSecond;
+ (NSString *)stringFromDuration:(unsigned long long)durationSeconds;
- (NSDecimalNumber *)sizeBytes;
- (NSString *)cleanupFilenameString;
- (NSString *)trimmedString;

@end
