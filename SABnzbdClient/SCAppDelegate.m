//
//  SCAppDelegate.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCAppDelegate.h"
#import "SCServersViewController.h"
#import "SCDownloadQueueViewController.h"
#import "SCModels.h"
#import "SCDataSetup.h"
#import "SCBinSearchClient.h"
#import "SCURLSchemeHandler.h"

#ifndef TESTFLIGHT
#import <Crashlytics/Crashlytics.h>
#endif

@interface SCAppDelegate ()

- (void)loadRootViewController;
- (void)loadUserDefaults;

@end

@implementation SCAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef TESTFLIGHT
    [TestFlight takeOff:kTestFlightAPIKey];
#endif

    [SCAppearance applyAppearance];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"CoreDataModel.sqlite"];
    [SCDataSetup populateWithData];
    [self loadUserDefaults];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self loadRootViewController];
    [self.window makeKeyAndVisible];

    [FlurryAnalytics startSession:kFlurryAPIKey];
    [Appirater appLaunched:YES];
    
#ifndef TESTFLIGHT
    [Crashlytics startWithAPIKey:kCrashlyticsKey];
#endif

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [SCURLSchemeHandler handleURL:url withApplication:application];
}

- (void)loadRootViewController
{
    UIViewController *serversViewController = [[SCServersViewController alloc] initWithNibName:@"SCServersViewController" bundle:nil];
    UINavigationController *serversNavigationViewController = [[UINavigationController alloc] initWithRootViewController:serversViewController];
    serversNavigationViewController.navigationBar.barStyle = UIBarStyleBlack;

    self.window.rootViewController = serversNavigationViewController;
}

- (void)loadUserDefaults
{
    NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
}

@end