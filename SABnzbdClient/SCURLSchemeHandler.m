//
//  SCURLSchemeHandler.m
//  SABnzbdClient
//
//  Created by Michael Voong on 30/05/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCURLSchemeHandler.h"
#import "NSString+XQueryComponents.h"
#import "AFNetworking.h"
#import "SCNZBImportViewController.h"

@interface SCURLSchemeHandler ()

+ (BOOL)addNZBWithURLString:(NSString *)urlString rootViewController:(UIViewController *)rootViewController;

@end

@implementation SCURLSchemeHandler

+ (BOOL)handleURL:(NSURL *)url withApplication:(UIApplication *)application
{
    NSString *action = [url host];
    NSDictionary *queryComponents = [[url query] dictionaryFromQueryComponents];
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    // Start consuming actions
    if ([action isEqualToString:@"addnzb"]) {
        NSString *nzbURL = [[queryComponents objectForKey:@"url"] count] ? [[queryComponents objectForKey:@"url"] objectAtIndex:0] : nil;

        return [SCURLSchemeHandler addNZBWithURLString:nzbURL rootViewController:rootViewController];
    }

    return NO;
}

+ (BOOL)addNZBWithURLString:(NSString *)urlString rootViewController:(UIViewController *)rootViewController
{
    NSURL *url = [NSURL URLWithString:urlString];

    if (!url)
        return NO;

    SCNZBImportViewController *viewController = [[SCNZBImportViewController alloc] initWithNibName:@"SCNZBImportViewController" bundle:nil];
    viewController.url = url;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    if ([rootViewController modalViewController]) {
        [rootViewController dismissViewControllerAnimated:YES completion:^{
             [rootViewController presentModalViewController:navigationController animated:YES];
         }];
    } else {
        [rootViewController presentModalViewController:navigationController animated:YES];
    }

    return YES;
}

@end