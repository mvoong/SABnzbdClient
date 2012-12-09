//
//  SCPopupMessageView.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCPopupMessageView.h"
#import <QuartzCore/QuartzCore.h>

@interface SCPopupMessageView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (CGSize)calculateIconSize;
- (CGSize)calculateMessageSizeForAvailableSize:(CGSize)availableSize;

@end

@implementation SCPopupMessageView

static const NSTimeInterval kSCPopupMessageViewDefaultDuration = 1.2;

@synthesize iconImage = _iconImage;
@synthesize message = _message;
@synthesize duration = _duration;
@synthesize textColor = _textColor;
@synthesize font = _font;
@synthesize textLabel = _textLabel;
@synthesize imageView = _imageView;

+ (void)showWithMessage:(NSString *)message overView:(UIView *)parentView
{
    [SCPopupMessageView showWithMessage:message overView:parentView iconImage:nil];
}

+ (void)showWithMessage:(NSString *)message overView:(UIView *)parentView iconImage:(UIImage *)iconImage
{
    [SCPopupMessageView showWithMessage:message overView:parentView iconImage:iconImage duration:kSCPopupMessageViewDefaultDuration];
}

+ (void)showWithMessage:(NSString *)message overView:(UIView *)parentView iconImage:(UIImage *)iconImage duration:(NSTimeInterval)duration
{
    if (parentView) {
        SCPopupMessageView *messageView = [[SCPopupMessageView alloc] initWithMessage:message iconImage:iconImage duration:duration];
        [messageView showOverView:parentView];
    }
}

- (id)initWithMessage:(NSString *)message
{
    self = [self initWithMessage:message iconImage:nil];
    return self;
}

- (id)initWithMessage:(NSString *)message iconImage:(UIImage *)iconImage
{
    self = [self initWithMessage:message iconImage:nil duration:kSCPopupMessageViewDefaultDuration];
    return self;
}

- (id)initWithMessage:(NSString *)message iconImage:(UIImage *)iconImage duration:(NSTimeInterval)duration
{
    self = [self init];

    if (self) {
        self.message = message;
        self.iconImage = iconImage;
        self.duration = duration;
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 10;
    }

    return self;
}

- (void)setMessage:(NSString *)message
{
    if (message != _message) {
        _message = message;
        self.textLabel.text = message;
        [self setNeedsLayout];
    }
}

- (void)setIconImage:(UIImage *)iconImage
{
    if (iconImage != _iconImage) {
        _iconImage = iconImage;
        self.imageView.image = iconImage;
        [self setNeedsLayout];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }

    return _imageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.lineBreakMode = UILineBreakModeWordWrap;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_textLabel];
    }

    return _textLabel;
}

- (void)setTextColor:(UIColor *)textColor
{
    if (textColor != _textColor) {
        _textColor = textColor;
        self.textLabel.textColor = textColor;
    }
}

- (void)setFont:(UIFont *)font
{
    if (font != _font) {
        _font = font;
        self.font = font;
        [self setNeedsLayout];
    }
}

- (void)showOverView:(UIView *)parentView
{
    if (parentView) {
        [self setNeedsLayout];
        [parentView addSubview:self];
        [parentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];

        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
             self.alpha = 1;
         } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.4 delay:self.duration options:UIViewAnimationCurveEaseIn animations:^{
                  self.alpha = 0;
              } completion:^(BOOL finished) {
                  [self removeFromSuperview];
                  [parentView removeObserver:self forKeyPath:@"frame"];
              }];
         }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self setNeedsLayout];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)layoutSubviews
{
    // Calculate space required
    if (self.superview) {
        static const CGFloat kMaxWidth = 150.0f;
        static const CGFloat kMaxHeight = 300.0f;
        static const CGFloat kIconTextPadding = 8.0f;
        static const CGFloat kPadding = 12.0f;

        CGSize availableSize = CGSizeMake(MAX(kMaxWidth, (NSUInteger)(self.superview.bounds.size.width * 0.6)),
                                          MAX(kMaxHeight, (NSUInteger)(self.superview.bounds.size.height * 0.6)));
        CGSize iconSize = [self calculateIconSize];
        CGSize messageSize = [self calculateMessageSizeForAvailableSize:availableSize];

        CGFloat width = MAX(iconSize.width, messageSize.width) + kPadding * 2;
        CGFloat height = kPadding * 2 + iconSize.height + (iconSize.height > 0 && messageSize.height > 0 ? kIconTextPadding : 0) + messageSize.height;

        self.frame = CGRectMake((NSUInteger)(self.superview.bounds.size.width / 2 - width / 2),
                                (NSUInteger)(self.superview.bounds.size.height / 2 - height / 2),
                                width,
                                height);

        if (self.iconImage) {
            self.imageView.frame = CGRectMake((NSUInteger)(width / 2 - iconSize.width / 2),
                                              kPadding,
                                              iconSize.width,
                                              iconSize.height);
        }

        if ([self.message length]) {
            self.textLabel.frame = CGRectMake((NSUInteger)(width / 2 - messageSize.width / 2),
                                              kPadding + iconSize.height + (iconSize.height > 0 ? kIconTextPadding : 0),
                                              messageSize.width,
                                              messageSize.height);
        }
    }
}

- (CGSize)calculateIconSize
{
    return self.iconImage ? self.iconImage.size : CGSizeZero;
}

- (CGSize)calculateMessageSizeForAvailableSize:(CGSize)availableSize
{
    if ([self.message length]) {
        CGSize stringSize = [self.message sizeWithFont:self.textLabel.font
                                     constrainedToSize:availableSize
                                         lineBreakMode:self.textLabel.lineBreakMode];
        return stringSize;
    }

    return CGSizeZero;
}

- (void)dealloc
{
}

@end