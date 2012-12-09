//
//  SCAsynchronousSearchDisplayController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCAsynchronousSearchDisplayController.h"
#import "SCActivityIndicatorView.h"
#import "SCPlaceholderView.h"

@interface SCAsynchronousSearchDisplayController ()

@property (nonatomic, strong) SCPlaceholderView *placeholderView_;
@property (nonatomic, strong) SCActivityIndicatorView *activityIndicatorView_;

@end

@implementation SCAsynchronousSearchDisplayController

@synthesize placeholderView_;
@synthesize activityIndicatorView_;

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.searchBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)showPlaceholderWithMessage:(NSString *)message
{
    if (!self.placeholderView_) {
        self.placeholderView_ = [[SCPlaceholderView alloc] init];
        self.placeholderView_.autoresizingMask = self.searchResultsTableView.autoresizingMask;
    }

    self.placeholderView_.frame = self.searchResultsTableView.frame;
    self.placeholderView_.text = message;
    [self.searchResultsTableView.superview addSubview:self.placeholderView_];
}

- (void)hidePlaceholder
{
    [self.placeholderView_ removeFromSuperview];
}

- (void)showActivityIndicator
{
    if (!self.activityIndicatorView_) {
        self.activityIndicatorView_ = [[SCActivityIndicatorView alloc] init];
        self.activityIndicatorView_.autoresizingMask = self.searchResultsTableView.autoresizingMask;
    }

    self.activityIndicatorView_.frame = self.searchResultsTableView.frame;
    [self.searchResultsTableView.superview addSubview:self.activityIndicatorView_];
}

- (void)hideActivityIndicator
{
    [self.activityIndicatorView_ removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.searchBar && [keyPath isEqualToString:@"frame"]) {
        self.placeholderView_.frame = self.searchResultsTableView.frame;
        self.activityIndicatorView_.frame = self.searchResultsTableView.frame;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [self.searchBar removeObserver:self forKeyPath:@"frame"];
}

@end