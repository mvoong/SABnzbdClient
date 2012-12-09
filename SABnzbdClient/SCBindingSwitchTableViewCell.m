//
//  SCBindingSwitchTableViewCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBindingSwitchTableViewCell.h"

@interface SCBindingSwitchTableViewCell ()

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation SCBindingSwitchTableViewCell

@synthesize switchControl = _switchControl;

static const CGFloat kBindingBoolSwitchWidth = 80.0f;

- (void)setup
{
    [super setup];

    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(self.contentView.bounds.size.height / 2 - 14,
                                               self.contentView.bounds.size.width - kBindingBoolSwitchWidth - 6,
                                               0,
                                               0);
    CGRect switchFrame = UIEdgeInsetsInsetRect(self.contentView.bounds, edgeInsets);
    self.switchControl = [[UISwitch alloc] initWithFrame:switchFrame];
    self.switchControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.switchControl addTarget:self action:@selector(updateObjectValue)forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect titleFrame = self.textLabel.frame;
    titleFrame.size.width = self.contentView.bounds.size.width - kBindingBoolSwitchWidth - 20;
    self.textLabel.frame = titleFrame;
}

- (void)updateObjectValue
{
    [self.bindObject setValue:[NSNumber numberWithBool:self.switchControl.on] forKeyPath:self.bindKeyPath];
}

- (void)updateValueFromObject
{
    self.switchControl.on = [[self.bindObject valueForKeyPath:self.bindKeyPath] boolValue];
}

@end