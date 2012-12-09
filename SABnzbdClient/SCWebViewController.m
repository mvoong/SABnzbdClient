//
//  SCWebViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCWebViewController.h"
#import "AFNetworking.h"

@interface SCWebViewController ()

@property (nonatomic, strong) AFHTTPRequestOperation *request;

- (NSString *)stringByInjecting:(NSString *)injectionHTML toHeadOfHTML:(NSString *)html;

@end

@implementation SCWebViewController

@synthesize webView = _webView;
@synthesize urlRequest = _urlRequest;
@synthesize customCssPath = _customCssPath;
@synthesize request = _request;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.urlRequest)
        [self reload];
}

- (void)setUrlRequest:(NSURLRequest *)urlRequest
{
    _urlRequest = urlRequest;

    if ([self isViewLoaded])
        [self reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.hidden = NO;
    
    // For direct load mode
    [self hideActivityIndicator];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    webView.hidden = YES;
}

- (void)reload
{
    [self.webView stopLoading];
    [self.request cancel];
    [self showActivityIndicator];

    if (self.directLoadMode) {
        [self.webView loadRequest:self.urlRequest];
    } else {
        self.request = [[AFHTTPRequestOperation alloc] initWithRequest:self.urlRequest];
        SCWebViewController *selfBlock = self;

        [self.request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * operation, id responseObject) {
             [selfBlock processResponseWithOperation:operation responseObject:responseObject];
         } failure:^(AFHTTPRequestOperation * operation, NSError * error) {
             [selfBlock processFailureOperation:operation error:error];
         }];
        [self.request start];
    }
}

- (void)processResponseWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject
{
    [self hideActivityIndicator];
    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

    if (responseString) {
        NSURL *baseUrl = nil;

        if ([self.customCssPath length]) {
            NSString *injection = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"%@\" />", self.customCssPath];
            responseString = [self stringByInjecting:injection toHeadOfHTML:responseString];

            NSString *path = [[NSBundle mainBundle] bundlePath];
            baseUrl = [NSURL fileURLWithPath:path];
        }

        NSString *mobileViewportString = @"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0\" /><meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />";
        responseString = [self stringByInjecting:mobileViewportString toHeadOfHTML:responseString];

        [self.webView loadHTMLString:responseString baseURL:baseUrl];
    } else {
        [SCPopupMessageView showWithMessage:NSLocalizedString(@"LOADING_FAILED_KEY", nil) overView:self.view];
    }
}

- (void)processFailureOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error
{
    [self hideActivityIndicator];
    [SCPopupMessageView showWithMessage:[error localizedDescription] overView:self.view];
}

- (NSString *)stringByInjecting:(NSString *)injectionHTML toHeadOfHTML:(NSString *)html
{
    NSString *replacementString = [NSString stringWithFormat:@"%@</head>", injectionHTML];

    return [html stringByReplacingOccurrencesOfString:@"</head>"
                                           withString:replacementString
                                              options:NSCaseInsensitiveSearch
                                                range:NSMakeRange(0, [html length])];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeOther)
        return YES;

    // Open in new window
    [[UIApplication sharedApplication] openURL:[request URL]];
    return NO;
}

- (void)viewDidUnload
{
    self.request = nil;
    [self.webView stopLoading];
    self.webView = nil;
    [super viewDidUnload];
}

@end