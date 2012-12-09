//
//  MVActionSheetDataSource.h
//
//  A protocol describing the methods that MVActionSheetView uses to display its content, and to receive notifications
//  when the action sheet is dismissed (done or cancel pressed).
//
//  Created by Michael Voong on 09/08/2011.
//

#import <Foundation/Foundation.h>

@protocol MVActionSheetDataSource <NSObject>

@required

// The view to be displayed in the action sheet
- (UIView *)view;

@optional

// Return a fixed height
- (CGFloat)preferredHeight;

- (void)donePressed;
- (void)cancelPressed;

@end
