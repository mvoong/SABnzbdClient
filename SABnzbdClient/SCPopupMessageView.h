//
//  SCPopupMessageView.h
//  SABnzbdClient
//
//  Created by Michael Voong on 14/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPopupMessageView : UIView

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

+ (void)showWithMessage:(NSString *)message overView:(UIView *)parentView;
+ (void)showWithMessage:(NSString *)message overView:(UIView *)parentView iconImage:(UIImage *)iconImage;
+ (void)showWithMessage:(NSString *)message overView:(UIView *)parentView iconImage:(UIImage *)iconImage duration:(NSTimeInterval)duration;

- (id)initWithMessage:(NSString *)message;
- (id)initWithMessage:(NSString *)message iconImage:(UIImage *)iconImage;
- (id)initWithMessage:(NSString *)message iconImage:(UIImage *)iconImage duration:(NSTimeInterval)duration;
- (void)showOverView:(UIView *)parentView;

@end
