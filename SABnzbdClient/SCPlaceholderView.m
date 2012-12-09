//
//  SCPlaceholderView.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCPlaceholderView.h"

@interface SCPlaceholderView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation SCPlaceholderView

@synthesize text = _text;
@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.textColor = [UIColor grayColor];
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self addSubview:self.textLabel];
    }

    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = text;
}

- (void)layoutSubviews
{
    self.textLabel.frame = CGRectInset(self.bounds, 20, 20);
}

@end