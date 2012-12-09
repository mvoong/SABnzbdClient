//
//  SCBaseGroupedTableViewCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseGroupedTableViewCell.h"

@implementation SCBaseGroupedTableViewCell

- (void)setup
{
    [super setup];

    self.backgroundColor = [UIColor whiteColor];
}

- (BOOL)drawGradientBackground
{
    return NO;
}

@end