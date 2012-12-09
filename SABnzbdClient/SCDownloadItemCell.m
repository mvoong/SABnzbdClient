//
//  SCDownloadItemCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 12/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadItemCell.h"
#import "NSString+Utils.m"
#import "SCDownloadItem+JSON.h"
#import "SCCategory.h"

@implementation SCDownloadItemCell

@synthesize titleLabel = _titleLabel;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;
@synthesize progressView = _progressView;
@synthesize downloadItem = _downloadItem;

static const CGFloat kDownloadItemCellPaddingHeight_ = 47.0f;

+ (CGFloat)heightForItem:(SCDownloadItem *)item width:(CGFloat)width
{
    CGFloat calculatedSize = kDownloadItemCellPaddingHeight_;

    if ([item.filename length]) {
        CGSize size = [item.filename sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                constrainedToSize:CGSizeMake(width - 16, 9999)
                                    lineBreakMode:UILineBreakModeWordWrap];
        calculatedSize += MIN(32, size.height);
    }

    return calculatedSize;
}

- (void)setDownloadItem:(SCDownloadItem *)downloadItem
{
    _downloadItem = downloadItem;
    
    // Progress bar
    CGFloat progress = 0.0f;

    if (downloadItem.sizeMB && downloadItem.sizeRemainingMB && ![downloadItem.sizeMB isEqualToNumber:[NSDecimalNumber zero]]) {
        progress = 1 - [[downloadItem.sizeRemainingMB decimalNumberByDividingBy:self.downloadItem.sizeMB] floatValue];
    }

    self.progressView.progress = progress;

    DownloadStatus status = [SCStatusTransformer downloadStatusForNumber:downloadItem.status];

    if (status == DownloadStatusCompleted || status == DownloadStatusDownloading) {
        self.progressView.alpha = 1;
        self.progressView.progressTintColor = [UIColor greenColor];
    } else {
        self.progressView.alpha = 0.3;
        self.progressView.progressTintColor = [UIColor grayColor];
    }

    // Title
    self.titleLabel.text = downloadItem.filename;

    // Left
    self.leftLabel.text = downloadItem.category.name;

    // Right
    if (status == DownloadStatusGrabbing) {
        self.rightLabel.text = nil;
        
        // Don't show accessory and selection
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        // Populate right label
        NSString *fileSize = [NSString stringFromFileSize:[downloadItem.sizeRemainingMB doubleValue] * 1000000];
        self.rightLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SIZE_REMAINING_KEY", nil), fileSize];
        
        if (status == DownloadStatusDownloading) {
            // Append time remaining
            self.rightLabel.text = [self.rightLabel.text stringByAppendingFormat:@" (%@)", downloadItem.timeRemaining];
        }
        
        // Default accessory type and selection style
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if ([self.titleLabel.text length]) {
        self.titleLabel.frame = CGRectModifyHeight(self.titleLabel.frame, self.contentView.bounds.size.height - kDownloadItemCellPaddingHeight_);
    }
}

@end