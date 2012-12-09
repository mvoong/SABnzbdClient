//
//  SCServerDetailViewControllerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerDetailViewControllerDataSource.h"
#import "SCBindingTextFieldTableViewCell.h"
#import "SCBindingSwitchTableViewCell.h"

@interface SCServerDetailViewControllerDataSource ()

@property (nonatomic, strong) NSArray *cells;

@end

@implementation SCServerDetailViewControllerDataSource

@synthesize server = _server;
@synthesize cells = _cells;

- (void)setup
{
    [super setup];
}

- (void)loadData
{
    [super loadData];

    SCBindingTextFieldTableViewCell *nameCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"NAME_KEY", @"Name") bindObject:self.server bindKeyPath:@"name"];
    nameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [nameCell updateValueFromObject];

    SCBindingTextFieldTableViewCell *hostCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"HOST_KEY", @"Host") bindObject:self.server bindKeyPath:@"hostname"];
    hostCell.textField.keyboardType = UIKeyboardTypeURL;
    hostCell.textInputRestriction = TextInputRestrictionHostname;
    [hostCell updateValueFromObject];

    SCBindingTextFieldTableViewCell *portCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"PORT_KEY", @"Port") bindObject:self.server bindKeyPath:@"port"];
    portCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    portCell.bindingTextType = BindingTextTypeNumber;
    [portCell updateValueFromObject];

    SCBindingSwitchTableViewCell *useHTTPSCell = [SCBindingSwitchTableViewCell cellWithTitle:NSLocalizedString(@"ENABLE_HTTPS_KEY", nil) bindObject:self.server bindKeyPath:@"enableHTTPS"];
    [useHTTPSCell updateValueFromObject];

//    SCBindingTextFieldTableViewCell *usernameCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"USERNAME_KEY", @"Username") bindObject:self.server bindKeyPath:@"username"];
//    usernameCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
//    [usernameCell updateValueFromObject];
//
//    SCBindingTextFieldTableViewCell *passwordCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"PASSWORD_KEY", @"Password") bindObject:self.server bindKeyPath:@"password"];
//    passwordCell.textField.secureTextEntry = YES;
//    [passwordCell updateValueFromObject];

    SCBindingTextFieldTableViewCell *apiKeyCell = [SCBindingTextFieldTableViewCell cellWithTitle:NSLocalizedString(@"API_KEY_KEY", @"API Key") bindObject:self.server bindKeyPath:@"apiKey"];
    apiKeyCell.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [apiKeyCell updateValueFromObject];

    self.cells = [NSArray arrayWithObjects:nameCell, hostCell, portCell, useHTTPSCell, apiKeyCell, nil];

    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cells objectAtIndex:indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString(@"SABNZBD_ACCOUNT_FOOTER", nil);
}

@end