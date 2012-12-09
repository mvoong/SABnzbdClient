//
//  SCNZBImportViewController.m
//  SABnzbdClient
//
//  Created by Michael Voong on 30/05/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBImportViewController.h"
#import "SCServerPickerDataSource.h"
#import "SCServer.h"

@interface SCNZBImportViewController ()

@property (nonatomic, strong) SCSABnzbdClient *client;
@property (nonatomic, strong) NSOperation *downloadClientRequest;

@end

@implementation SCNZBImportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"ADD_NZB_TITLE", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalViewControllerAnimated:)];
    [self.dataSource load];
    [self.pickerView reloadAllComponents];

    self.urlTitleLabel.text = NSLocalizedString(@"URL", nil);
    self.sabnzbdServerLabel.text = NSLocalizedString(@"SABNZBD_SERVER", nil);
    [self.addButton setTitle:NSLocalizedString(@"ADD", nil) forState:UIControlStateNormal];
    self.urlLabel.text = self.url ? [self.url absoluteString] : @"Invalid URL";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    self.dataSource = nil;
    [super viewDidUnload];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.dataSource.servers objectAtIndex:row] name];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (IBAction)add
{
    SCServer *server = [self.dataSource.servers objectAtIndex:[self.pickerView selectedRowInComponent:0]];

    if ([server.categories count]) {
        SCCategoryPickerDataSource *dataSource = [[SCCategoryPickerDataSource alloc] initWithDelegate:self server:server];
        [MVActionSheetView showWithDataSource:dataSource title:NSLocalizedString(@"SEARCH_RESULT_CATEGORY_KEY", nil)];
    } else {
        [self startDownloadWithCategory:nil];
    }
}

- (void)startDownloadWithCategory:(SCCategory *)category
{
    [self showActivityIndicator];

    SCServer *server = [self.dataSource.servers objectAtIndex:[self.pickerView selectedRowInComponent:0]];

    [self.downloadClientRequest cancel];
    self.client = [SCSABnzbdClient clientWithServer:server];
    self.downloadClientRequest = [self.client startDownloadRequestWithURL:self.url
                                                                     name:nil
                                                                 category:category
                                                                  success:^(NSString *apiError) {
                                                                      if (!apiError) {
                                                                          [self dismissModalViewControllerAnimated:YES];
                                                                      } else {
                                                                          [self hideActivityIndicator];
                                                                          [SCPopupMessageView showWithMessage:apiError overView:self.view];
                                                                      }
                                                                      self.downloadClientRequest = nil;
                                                                 } failure:^(NSError *error) {
                                                                     [self hideActivityIndicator];
                                                                     [SCPopupMessageView showWithMessage:[error localizedDescription] overView:self.view iconImage:[UIImage imageNamed:@"Icon-Wifi.png"]];
                                                                      self.downloadClientRequest = nil;
                                                                 }];
}

- (void)categoryPickerDataSource:(SCCategoryPickerDataSource *)dataSource didPickCategory:(SCCategory *)category
{
    [self startDownloadWithCategory:category];
}

@end