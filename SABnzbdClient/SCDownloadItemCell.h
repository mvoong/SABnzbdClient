//
//  SCDownloadItemCell.h
//  SABnzbdClient
//
//  Created by Michael Voong on 12/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewCell.h"
#import "SCDownloadItem.h"

@interface SCDownloadItemCell : SCBaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) SCDownloadItem *downloadItem;

+ (CGFloat)heightForItem:(SCDownloadItem *)item width:(CGFloat)width;

@end
