//
//  SCNZBMatrixAccountViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixAccountViewController.h"
#import "SCSearchAccount.h"
#import "SCWebViewController.h"
#import "SCDataSetup.h"

@interface SCNZBMatrixAccountViewController ()

@end

@implementation SCNZBMatrixAccountViewController

@synthesize account = _account;
@synthesize dataSource = _dataSource;

- (void)setup
{
    [super setup];
    self.title = NSLocalizedString(@"NZBMATRIX_SETTINGS_KEY", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSource.account = self.account;
    [self.dataSource loadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCWebViewController *webViewController = [[SCWebViewController alloc] initWithNibName:@"SCWebViewController" bundle:nil];
    webViewController.title = NSLocalizedString(@"SERVICE_STATUS_KEY", nil);
    webViewController.customCssPath = [[NSBundle mainBundle] pathForResource:@"nzbMatrixCSSOverride" ofType:@"html"];
    webViewController.urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://nzbmatrix.info"]];

    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSManagedObjectContext defaultContext] save];

//    [self.dataSource verify];
}

@end