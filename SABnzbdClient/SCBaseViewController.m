//
//  SCBaseViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseViewController.h"
#import "SCPlaceholderView.h"
#import "SCActivityIndicatorView.h"

@interface SCBaseViewController ()

@property (nonatomic, strong) SCPlaceholderView *placeholderView;
@property (nonatomic, strong) SCActivityIndicatorView *activityIndicatorView;

@end

@implementation SCBaseViewController

@synthesize placeholderView = _placeholderView;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup
{
}

- (void)showPlaceholderWithMessage:(NSString *)message
{
    if (!self.placeholderView) {
        self.placeholderView = [[SCPlaceholderView alloc] init];
        self.placeholderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    self.placeholderView.frame = self.view.bounds;
    self.placeholderView.text = message;
    [self.view addSubview:self.placeholderView];
}

- (void)hidePlaceholder
{
    [self.placeholderView removeFromSuperview];
}

- (void)showActivityIndicator
{
    if (!self.activityIndicatorView) {
        self.activityIndicatorView = [[SCActivityIndicatorView alloc] init];
        self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    self.activityIndicatorView.frame = self.view.bounds;
    [self.view addSubview:self.activityIndicatorView];
}

- (void)hideActivityIndicator
{
    [self.activityIndicatorView removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Modal view controllers

- (void)showModalViewController:(UIViewController *)viewController withDoneSystemItem:(UIBarButtonSystemItem)systemItem
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
                                                                                                    target:self
                                                                                                    action:@selector(dismissViewController)];
    [self presentModalViewController:navigationController animated:YES];
}

- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Cleanup

- (void)viewDidUnload
{
    self.placeholderView = nil;
    self.activityIndicatorView = nil;

    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end