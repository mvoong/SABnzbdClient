//
//  SCBaseTableViewCell.h
//  SABnzbdClient
//
//  Created by Michael Voong on 12/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCBaseTableViewCell : UITableViewCell

+ (id)loadFromNib;
- (void)setup;
- (BOOL)drawGradientBackground;

@end
