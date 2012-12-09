//
//  SCNZBMatrixAccountViewControllerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 11/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCNZBMatrixAccountViewControllerDataSource.h"
#import "SCBindingTextFieldTableViewCell.h"
#import "SCBindingSwitchTableViewCell.h"
#import "SCModels.h"
#import "SCActionCell.h"

@interface SCNZBMatrixAccountViewControllerDataSource ()

@property (nonatomic, strong) NSArray *cells;
@property (nonatomic, strong) SCActionCell *serviceStatusCell;
@property (nonatomic, strong) SCNZBMatrixSearchClient *searchClient;
@property (nonatomic, strong) NSOperation *accountClientOperation;

@end

@implementation SCNZBMatrixAccountViewControllerDataSource

- (void)loadData
{
    [super loadData];

    SCBindingTextFieldTableViewCell *usernameCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"USERNAME_KEY", @"Username") bindObject:self.account bindKeyPath:@"username"];
    usernameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    usernameCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [usernameCell updateValueFromObject];

//    SCBindingTextFieldTableViewCell *passwordCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"PASSWORD_KEY", @"Password") bindObject:self.account bindKeyPath:@"password"];
//    passwordCell.textField.secureTextEntry = YES;
//    [passwordCell updateValueFromObject];

    SCBindingTextFieldTableViewCell *apiKeyCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"API_KEY_KEY", @"API Key") bindObject:self.account bindKeyPath:@"apiKey"];
    apiKeyCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    apiKeyCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [apiKeyCell updateValueFromObject];

//    SCBindingSwitchTableViewCell *enableSceneNameCell = [SCBindingSwitchTableViewCell cellWithTitle:NSLocalizedString(@"ENABLE_SCENE_NAME_KEY", @"Enable Scene Name") bindObject:self.account bindKeyPath:@"enableSceneName"];
//    [enableSceneNameCell updateValueFromObject];

    SCBindingSwitchTableViewCell *enableHTTPSCell = [SCBindingSwitchTableViewCell cellWithTitle:NSLocalizedString(@"ENABLE_HTTPS_KEY", @"Enable HTTPS") bindObject:self.account bindKeyPath:@"enableHTTPS"];
    [enableHTTPSCell updateValueFromObject];

    self.cells = [NSArray arrayWithObjects:usernameCell, apiKeyCell, enableHTTPSCell, nil];

    self.serviceStatusCell = [SCActionCell loadFromNib];
    self.serviceStatusCell.titleLabel.text = NSLocalizedString(@"SERVICE_STATUS_KEY", nil);

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.cells count];
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [self.cells objectAtIndex:indexPath.row];
        default:
            return self.serviceStatusCell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return section == 0 ? NSLocalizedString(@"NZB_MATRIX_ACCOUNT_FOOTER", nil) : nil;
}

#pragma mark - Verification

- (void)verify
{
    if (![self.account.verified boolValue]) {
        [self.accountClientOperation cancel];
        self.searchClient = [SCNZBMatrixSearchClient client];
        self.accountClientOperation = [self.searchClient startAccountRequestWithSuccess:nil failure:nil];
    }
}

@end