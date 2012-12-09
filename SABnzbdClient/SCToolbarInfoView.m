//
//  SCToolbarInfoView.m
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCToolbarInfoView.h"
#import "SCServer.h"
#import "SCServerStatus.h"
#import "NSString+Utils.h"

@interface SCToolbarInfoView ()

@property (nonatomic, strong) UILabel *mainLabel;

@end

@implementation SCToolbarInfoView

static void *kToolbarInfoViewStatusChangedNotification;

@synthesize mainLabel = _mainLabel;
@synthesize server = _server;

- (void)setup
{
    [super setup];
    self.mainLabel = [[UILabel alloc] init];
    self.mainLabel.shadowOffset = CGSizeMake(0, -1);
    self.mainLabel.shadowColor = [UIColor blackColor];
    self.mainLabel.font = [UIFont boldSystemFontOfSize:13];
    self.mainLabel.textColor = [UIColor whiteColor];
    self.mainLabel.textAlignment = UITextAlignmentCenter;
    self.mainLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainLabel];
}

- (void)setServer:(SCServer *)server
{
    [_server removeObserver:self forKeyPath:@"status"];
    _server = server;
    [_server addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&kToolbarInfoViewStatusChangedNotification];
    [self update];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &kToolbarInfoViewStatusChangedNotification)
        [self update];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)update
{
    if ([self.server.status.paused boolValue])
        self.mainLabel.text = NSLocalizedString(@"PAUSED_KEY", nil);
    else if ([self.server.downloadItems count] > 0)
        self.mainLabel.text = [NSString stringFromSpeed:[self.server.status.currentSpeed doubleValue] * 1000];
    else
        self.mainLabel.text = self.server.status.status;
}

- (void)layoutSubviews
{
    self.mainLabel.frame = self.bounds;
}

- (void)dealloc
{
    [_server removeObserver:self forKeyPath:@"status"];
}

@end