//
//  SCActivityIndicatorView.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCActivityIndicatorView.h"

@interface SCActivityIndicatorView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation SCActivityIndicatorView

@synthesize activityIndicator = _activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicator startAnimating];
        [self addSubview:self.activityIndicator];
    }

    return self;
}

- (void)layoutSubviews
{
    self.activityIndicator.frame = CGRectMake((NSUInteger)(self.bounds.size.width / 2 - 10),
                                              (NSUInteger)(self.bounds.size.height / 2 - 10),
                                              20,
                                              20);
}

@end