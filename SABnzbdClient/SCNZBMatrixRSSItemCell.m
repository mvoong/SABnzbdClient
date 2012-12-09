//
//  SCNZBMatrixRSSItemCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixRSSItemCell.h"
#import "NSString+Utils.h"

@implementation SCNZBMatrixRSSItemCell

- (void)setResult:(id<SCNZBItem>)result
{
    _result = result;
    
    if (result) {
        self.titleLabel.text = [result name];
        
        // Size
        self.fileDetailsLabel.text = [NSMutableString stringWithString:[NSString stringFromFileSize:[result.size longLongValue]]];
        
        // Date
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
        });
        
        self.dateLabel.text = [dateFormatter stringFromDate:result.indexDate];
    }
}

@end
