//
//  SCBaseScrollViewViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseScrollViewViewController.h"

@interface SCBaseScrollViewViewController ()

@property (nonatomic, assign) UIEdgeInsets savedScrollViewInsets;
@property (nonatomic, assign) BOOL scrollViewInsetsSaved;

@end

@implementation SCBaseScrollViewViewController

@synthesize savedScrollViewInsets = _savedScrollViewInsets;
@synthesize scrollViewInsetsSaved = _scrollViewInsetsSaved;

- (void)setup
{
    [super setup];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (UIScrollView *)scrollView
{
    return nil;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self keyboardWillShow:YES withNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self keyboardWillShow:NO withNotification:notification];
}

- (void)keyboardWillShow:(BOOL)show withNotification:(NSNotification *)notification
{
    UIScrollView *managedView = [self scrollView];

    if (show && managedView && !self.scrollViewInsetsSaved) {
        // Save the scroll insets, to restore when keyboard is hidden
        self.savedScrollViewInsets = managedView.contentInset;
        self.scrollViewInsetsSaved = YES;
    }

    NSDictionary *userInfo = [notification userInfo];

    // Calculate the keyboard height
    CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    // Conversion required, to take into account rotation
    CGFloat keyboardHeight = [[managedView window] convertRect:keyboardEndFrame toView:managedView].size.height;

    // Get animation curve and duration (see http://stackoverflow.com/questions/3332364/uikeyboardframebeginuserinfokey-uikeyboardframeenduserinfokey)
    UIViewAnimationCurve curve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:[duration doubleValue]];

    if (show) {
        if (managedView) {
            // Calculate the height of views beneath the managedView
            UIView *rootView = [[[managedView window] subviews] objectAtIndex:0];
            CGRect managedViewWindowBounds = [managedView convertRect:managedView.bounds toView:rootView];
            CGFloat negativeYInset = rootView.bounds.size.height - CGRectGetMaxY(managedViewWindowBounds);

            // Apply insets to view to take into account keyboard height - other height
            UIEdgeInsets contentInset = self.savedScrollViewInsets;
            contentInset.bottom += keyboardHeight - negativeYInset;
            managedView.contentInset = contentInset;
            managedView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, contentInset.bottom, 0);

            [self makeKeyboardResponderViewVisible];
        }
    } else {
        // Restore scroll insets as the keyboard is now hidden
        managedView.contentInset = self.savedScrollViewInsets;
        managedView.scrollIndicatorInsets = UIEdgeInsetsZero;
        self.scrollViewInsetsSaved = NO;
    }

    [UIView commitAnimations];
}

- (void)makeKeyboardResponderViewVisible
{
    [self makeKeyboardResponderViewVisibleAnimated:YES];
}

- (void)makeKeyboardResponderViewVisibleAnimated:(BOOL)animated
{
    UIScrollView *managedView = [self scrollView];
    UIView *responderView = [self firstTextFieldResponder];

    if (managedView && responderView) {
        // Calculate responder view's coords in the scroll view's coordinate space
        CGRect responderViewCoords = [managedView convertRect:responderView.bounds
                                                     fromView:responderView];

        // Pad more according to customisation
        UIEdgeInsets customInsets = UIEdgeInsetsZero;
        responderViewCoords = UIEdgeInsetsInsetRect(responderViewCoords, customInsets);

        // Scroll - attempt to fit viewport around so responder view is visible
        [managedView scrollRectToVisible:responderViewCoords animated:animated];
    }
}

- (NSMutableArray *)keyboardRespondersForParent:(UIView *)parentView
{
    return [self keyboardRespondersForParent:parentView responders:nil];
}

/**
 * Recursive method to return an NSMutableArray containing the UITextFields that can be found under parentView in the
 * view hierarchy.
 */
- (NSMutableArray *)keyboardRespondersForParent:(UIView *)parentView responders:(NSMutableArray *)responders
{
    if (responders == nil) {
        responders = [NSMutableArray arrayWithCapacity:5];
    }

    // Base case
    if (parentView.subviews.count == 0) {
        return responders;
    }

    // Else add subviews that are UITextFields
    for (UIView *subview in parentView.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            [responders addObject:subview];
        } else {
            // Recursively call
            responders = [self keyboardRespondersForParent:subview responders:responders];
        }
    }

    return responders;
}

- (void)moveToNextResponder
{
    [self moveToResponder:1];
}

- (void)moveToPreviousResponder
{
    [self moveToResponder:-1];
}

- (void)moveToResponder:(NSInteger)stepSize
{
    // Find item currently responding to keyboard input
//    UITextField *firstResponder = [self firstTextFieldResponder];
//
//    if (firstResponder) {
//
//        NSArray *responders = [self keyboardRespondersForParent:self.view];
//        NSArray *sortedResponders = [UIView viewsSortedByVerticalPosition:responders];
//
//        NSUInteger foundIndex = [sortedResponders indexOfObject:firstResponder];
//        NSInteger nextIndex = foundIndex + stepSize;
//
//        // Only move if there is a valid responder after stepping. Note that we need the cast as the right hand side of the
//        // evaluation is an unsigned int, so compiler will convert left hand side into unsigned int, which would be a very
//        // large number
//        if (nextIndex >= 0 && nextIndex <= (NSInteger)[responders count] - 1 && nextIndex != foundIndex) {
//
//            BOOL resigned = [firstResponder resignFirstResponder];
//
//            if (resigned) {
//                [[sortedResponders objectAtIndex:nextIndex] becomeFirstResponder];
//            }
//        }
//    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Default implementation to dismiss keyboard on DONE button press
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (UITextField *)firstTextFieldResponder
{
    for (UITextField *textField in [self keyboardRespondersForParent : self.view]) {
        if ([textField isFirstResponder]) {
            return textField;
        }
    }

    return nil;
}

#pragma mark - KeyboardActionDelegate

- (void)keyboardDidPressPrevious
{
    [self moveToPreviousResponder];
}

- (void)keyboardDidPressNext
{
    [self moveToNextResponder];
}

@end