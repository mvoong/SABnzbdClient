//
//  SCBaseTableViewCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 12/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface SCBaseTableViewCell ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIColor *tempShadowColour;

@end

@implementation SCBaseTableViewCell

@synthesize gradientLayer;
@synthesize tempShadowColour;

+ (id)loadFromNib
{
    NSString *className = NSStringFromClass([self class]);
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];

    for (id object in objects) {
        if ([object isKindOfClass:[UITableViewCell class]]) {
            return object;
        }
    }

    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.shadowColor = [UIColor whiteColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.shadowColor = [UIColor whiteColor];

    if (self.selectionStyle != UITableViewCellSelectionStyleNone) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
}

- (BOOL)drawGradientBackground
{
    return YES;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    if ([self drawGradientBackground] && !self.gradientLayer) {
        UIColor *gradientStartColor = [UIColor colorWithWhite:0.95 alpha:1];
        UIColor *gradientEndColor = [UIColor colorWithWhite:0.90 alpha:1];

        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[gradientStartColor CGColor], (id)[gradientEndColor CGColor], nil];
        [self.backgroundView.layer insertSublayer:self.gradientLayer atIndex:0];
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self updateLabelHighlights:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateLabelHighlights:highlighted];
}

- (void)updateLabelHighlights:(BOOL)selected
{
    UILabel *label = nil;

    for (UIView *subview in self.contentView.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            label = (UILabel *)subview;

            if (selected) {
                if (label.shadowColor) {
                    if (!self.tempShadowColour)
                        self.tempShadowColour = label.shadowColor;

                    label.shadowColor = [UIColor clearColor];
                }
            } else if (self.tempShadowColour) {
                label.shadowColor = self.tempShadowColour;
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientLayer.frame = UIEdgeInsetsInsetRect(self.backgroundView.bounds, UIEdgeInsetsMake(0, 0, 1, 0));
}

@end