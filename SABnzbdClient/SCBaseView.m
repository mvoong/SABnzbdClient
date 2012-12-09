//
//  SCBaseView.m
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseView.h"

@implementation SCBaseView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup
{
}

@end