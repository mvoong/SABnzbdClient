//
//  MVActionSheetView.h
//
//  A UIView that needs to be initialised with a controller that defines the content view to display, as well as receives
//  callbacks when the action sheet is dismissed or submitted. The action sheet displays from the shortcut controller,
//  therefore goes on top of everything else.
//
//  Created by Michael Voong on 09/08/2011.
//

#import <UIKit/UIKit.h>
#import "MVActionSheetView.h"
#import "MVActionSheetDataSource.h"

// Tag used when attaching action sheet to shortcut bar view
static const NSUInteger kActionSheetViewTag = 12394;

static const CGFloat kActionSheetAnimationTimeInterval = 0.3f;

@interface MVActionSheetView : UIView

@property (nonatomic, strong) UIColor *toolbarTintColor;
@property (nonatomic, strong) id<MVActionSheetDataSource> dataSource;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *title;

+ (void)showWithDataSource:(id<MVActionSheetDataSource>)dataSource;
+ (void)showWithDataSource:(id<MVActionSheetDataSource>)dataSource title:(NSString *)title;
- (id)initWithActionSheetDataSource:(id<MVActionSheetDataSource>)controller;
- (id)initWithActionSheetDataSource:(id<MVActionSheetDataSource>)controller cancelButtonTitle:(NSString *)cancelTitle doneButtonTitle:(NSString *)doneTitle;

// Remove any existing action sheets attached to the view hierarchy, and animate this one
- (void)show;

// Hide the action sheet then remove from view hierarchy
- (void)hide;

- (void)donePressed:(UIControl *)control;
- (void)showAnimationDidFinish;
- (void)hideAnimationDidFinish:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)setWindowInteractionEnabled:(BOOL)enabled;

@end
