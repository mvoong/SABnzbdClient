//
//  SCBaseViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPopupMessageView.h"
#import "MVActionSheetView.h"

@interface SCBaseViewController : UIViewController

- (void)setup;
- (void)showPlaceholderWithMessage:(NSString *)message;
- (void)hidePlaceholder;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showModalViewController:(UIViewController *)viewController withDoneSystemItem:(UIBarButtonSystemItem)systemItem;

@end
