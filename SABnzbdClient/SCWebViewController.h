//
//  SCWebViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseViewController.h"

@interface SCWebViewController : SCBaseViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURLRequest *urlRequest;
@property (strong, nonatomic) NSString *customCssPath;
@property (assign, nonatomic) BOOL directLoadMode;

@end
