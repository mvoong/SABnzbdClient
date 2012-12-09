//
//  SCHistoryItemCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCHistoryItemCell.h"
#import "SCHistoryItem.h"

@implementation SCHistoryItemCell

@synthesize historyItem = _historyItem;
@synthesize titleLabel = _titleLabel;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;

- (void)setHistoryItem:(SCHistoryItem *)historyItem
{
    _historyItem = historyItem;

    if (historyItem) {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                          dateFormatter = [[NSDateFormatter alloc] init];
                          dateFormatter.dateStyle = NSDateFormatterMediumStyle;
                          dateFormatter.timeStyle = NSDateFormatterShortStyle;
                      });

        self.titleLabel.text = historyItem.name;

        if ([historyItem.failMessage length])
            self.leftLabel.text = historyItem.failMessage;
        else if ([historyItem.actionLine length])
            self.leftLabel.text = historyItem.actionLine;
        else if (historyItem.category)
            self.leftLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                   historyItem.category,
                                   [dateFormatter stringFromDate:historyItem.completed]];
        else
            self.leftLabel.text = [dateFormatter stringFromDate:historyItem.completed];

        self.rightLabel.text = historyItem.size;
    }
}

@end