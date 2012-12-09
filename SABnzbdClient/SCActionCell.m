//
//  SCActionCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCActionCell.h"

@implementation SCActionCell

@synthesize titleLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLabel.textColor = [SCAppearance colourByName:ColourNameCellValue];
}

@end