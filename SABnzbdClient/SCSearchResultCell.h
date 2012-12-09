//
//  SCSearchResultCell.h
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewCell.h"

@class SCNZBResult;

@interface SCSearchResultCell : SCBaseTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fileDetailsLabel;
@property (strong, nonatomic) SCNZBResult *result;

@end
