//
//  SCHistoryItemCell.h
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewCell.h"

@class SCHistoryItem;

@interface SCHistoryItemCell : SCBaseTableViewCell

@property (strong, nonatomic) SCHistoryItem *historyItem;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@end
