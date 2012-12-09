//
//  SCSearchResultCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchResultCell.h"
#import "SCNZBResult.h"
#import "NSString+Utils.h"

@implementation SCSearchResultCell

@synthesize titleLabel = _titleLabel;
@synthesize fileDetailsLabel = _fileDetailsLabel;
@synthesize result = _result;

- (void)setResult:(SCNZBResult *)result
{
    _result = result;

    if (result) {
        self.titleLabel.text = result.name;

        // Size
        NSMutableString *detailString = [NSMutableString stringWithString:[NSString stringFromFileSize:[result.size longLongValue]]];

        // Category
        if ([result.category length])
            [detailString appendFormat:@" - %@", result.category];
        // or Group
        else if ([result.group length])
            [detailString appendFormat:@" - %@", result.group];

        self.fileDetailsLabel.text = detailString;
    }
}

@end