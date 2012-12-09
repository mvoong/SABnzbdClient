//
//  MVActionSheetView.m
//  SABnzbdClient
//
//  Created by Michael Voong on 09/08/2011.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetView.h"

@interface MVActionSheetView ()

@property (nonatomic, strong) UIToolbar *toolbarView;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSString *doneTitle;

- (void)cancelPressed:(UIControl *)control;
- (BOOL)hideOnTouch;

@end

@implementation MVActionSheetView

+ (void)showWithDataSource:(id<MVActionSheetDataSource>)dataSource
{
    [self showWithDataSource:dataSource title:nil];
}

+ (void)showWithDataSource:(id<MVActionSheetDataSource>)dataSource title:(NSString *)title
{
    NSString *cancelTitle = NSLocalizedString(@"CANCEL_KEY", nil);
    NSString *doneTitle = NSLocalizedString(@"DONE_KEY", nil);
    
    MVActionSheetView *actionSheetView = [[MVActionSheetView alloc] initWithActionSheetDataSource:dataSource
                                                                                cancelButtonTitle:cancelTitle
                                                                                  doneButtonTitle:doneTitle];
    actionSheetView.title = title;
    
    [actionSheetView show];
}

- (id)initWithActionSheetDataSource:(id<MVActionSheetDataSource>)dataSource
{
    self = [self initWithActionSheetDataSource:dataSource cancelButtonTitle:nil doneButtonTitle:nil];

    return self;
}

- (id)initWithActionSheetDataSource:(id<MVActionSheetDataSource>)dataSource cancelButtonTitle:(NSString *)cancelTitle doneButtonTitle:(NSString *)doneTitle
{
    self = [super init];

    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.tag = kActionSheetViewTag;
        self.dataSource = dataSource;
        self.cancelTitle = cancelTitle;
        self.doneTitle = doneTitle;
    }

    return self;
}

- (void)show
{
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    if ([rootViewController modalViewController]) {
        rootViewController = [rootViewController modalViewController];
    }

    UIView *rootView = [rootViewController view];
    CGRect parentBounds = rootView.bounds;

    // Ensure we hide any other action sheets
    MVActionSheetView *otherActionSheetView = (MVActionSheetView *)[rootView viewWithTag:kActionSheetViewTag];
    [otherActionSheetView hide];

    // Set the frame
    self.frame = parentBounds;
    [rootView addSubview:self];

    static CGFloat toolbarHeight = 44.0f;
    BOOL showToolbar = self.cancelTitle || self.doneTitle;

    // Add the action sheet content view
    self.contentView = [self.dataSource view];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    UIEdgeInsets contentViewInsets;

    if ([self.dataSource respondsToSelector:@selector(preferredHeight)]) {
        // Use fixed height as configured by action sheet controller
        CGFloat preferredHeight = [self.dataSource preferredHeight];
        contentViewInsets = UIEdgeInsetsMake(parentBounds.size.height - preferredHeight, 0, 0, 0);
    } else {
        // Use default height (half of screen height)
        contentViewInsets = UIEdgeInsetsMake(parentBounds.size.height / 2, 0, 0, 0);
    }

    self.contentView.frame = UIEdgeInsetsInsetRect(parentBounds, contentViewInsets);

    // Push outside screen
    CGFloat contentOffset = self.contentView.frame.size.height + (showToolbar ? toolbarHeight : 0);
    self.contentView.transform = CGAffineTransformMakeTranslation(0, contentOffset);
    [self addSubview:self.contentView];

    // Load toolbar
    if (showToolbar) {
        CGRect toolbarFrame = CGRectMake(0, contentViewInsets.top - toolbarHeight, parentBounds.size.width, toolbarHeight);
        self.toolbarView = [[UIToolbar alloc] initWithFrame:toolbarFrame];
        self.toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.toolbarView.tintColor = self.toolbarTintColor;

        NSMutableArray *items = [NSMutableArray arrayWithCapacity:3];

        if ([self.cancelTitle length]) {
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:self.cancelTitle style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed:)];
            [items addObject:cancelItem];
        }
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:flexibleItem];
        
        if ([self.title length]) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = self.title;
            
            // Align left if we don't have a cancel title
            titleLabel.textAlignment = [self.cancelTitle length] ? UITextAlignmentCenter : UITextAlignmentLeft;
            
            titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.shadowOffset = CGSizeMake(0, -1);
            titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
            titleLabel.backgroundColor = [UIColor clearColor];
            [titleLabel sizeToFit];
            
            UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
            [items addObject:titleItem];
            
            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [items addObject:flexibleItem];
        }

        if ([self.doneTitle length]) {
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:self.doneTitle style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
            [items addObject:cancelItem];
        }

        [self.toolbarView setItems:items];

        // Position off-screen before adding
        self.toolbarView.transform = CGAffineTransformMakeTranslation(0, contentOffset);
        [self addSubview:self.toolbarView];
    }
    
    // Start animating background colour and view
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

    // Disable interaction for duration of animation
    [self setWindowInteractionEnabled:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kActionSheetAnimationTimeInterval];
    [UIView setAnimationDidStopSelector:@selector(showAnimationDidFinish)];
    [UIView setAnimationDelegate:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.contentView.transform = CGAffineTransformIdentity;
    self.toolbarView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)showAnimationDidFinish
{
    [self setWindowInteractionEnabled:YES];
}

- (void)hide
{
    static CGFloat toolbarHeight = 44.0f;
    CGFloat contentOffset = self.contentView.frame.size.height + (self.toolbarView ? toolbarHeight : 0);
    [self setWindowInteractionEnabled:NO];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kActionSheetAnimationTimeInterval];
    [UIView setAnimationDidStopSelector:@selector(hideAnimationDidFinish:finished:context:)];
    [UIView setAnimationDelegate:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.contentView.transform = CGAffineTransformMakeTranslation(0, contentOffset);
    self.toolbarView.transform = CGAffineTransformMakeTranslation(0, contentOffset);
    [UIView commitAnimations];
}

- (void)hideAnimationDidFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self.contentView removeFromSuperview];
    self.contentView = nil;

    [self.toolbarView removeFromSuperview];
    self.toolbarView = nil;

    [self removeFromSuperview];

    [self setWindowInteractionEnabled:YES];
}

- (void)donePressed:(UIControl *)control
{
    if ([self.dataSource respondsToSelector:@selector(donePressed)]) {
        [self.dataSource donePressed];
    }

    [self hide];
}

- (void)cancelPressed:(UIControl *)control
{
    if ([self.dataSource respondsToSelector:@selector(cancelPressed)]) {
        [self.dataSource cancelPressed];
    }

    [self hide];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Automatically hide when clicking on background
    if ([self hideOnTouch] && touches.count == 1 && [[touches anyObject] view] == self) {
        [self hide];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

/**
 * Override this method in subclasses to avoid dismissing this View whrn touching outside the content area.
 */
- (BOOL)hideOnTouch
{
    return YES;
}

- (void)setWindowInteractionEnabled:(BOOL)enabled
{
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] setUserInteractionEnabled:enabled];
}

#pragma mark - Setters

- (void)setToolbarTintColor:(UIColor *)toolbarTintColor
{
    _toolbarTintColor = toolbarTintColor;

    if (toolbarTintColor)
        self.toolbarView.tintColor = toolbarTintColor;
}

@end