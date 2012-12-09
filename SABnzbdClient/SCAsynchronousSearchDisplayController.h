//
//  SCAsynchronousSearchDisplayController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAsynchronousSearchDisplayController : UISearchDisplayController

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showPlaceholderWithMessage:(NSString *)message;
- (void)hidePlaceholder;

@end
