//
//  SCSearchAccount+Additions.m
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchAccount+Additions.h"
#import "SCNZBMatrixAccountViewController.h"
#import "SCSearchClient.h"
#import "SCNZBMatrixSearchClient.h"
#import "SCBinSearchClient.h"
#import "SCNZBResult.h"

@implementation SCSearchAccount (Additions)

+ (SCSearchAccount *)searchAccountWithKey:(NSString *)key
{
    return [SCSearchAccount findFirstByAttribute:@"key" withValue:key];
}

- (BOOL)hasSettings
{
    return [self.key isEqualToString:kSearchAccountKeyNZBMatrix];
}

- (BOOL)isValid
{
    if ([self.key isEqualToString:kSearchAccountKeyNZBMatrix]) {
        return [self.apiKey length] > 0 && [self.username length] > 0;
    } else {
        return YES;
    }
}

- (UIViewController *)settingsViewController
{
    if ([self.key isEqualToString:kSearchAccountKeyNZBMatrix]) {
        SCNZBMatrixAccountViewController *accountViewController = [[SCNZBMatrixAccountViewController alloc] initWithNibName:@"SCNZBMatrixAccountViewController" bundle:nil];
        accountViewController.account = self;
        return accountViewController;
    }

    return nil;
}

- (SCSearchClient *)searchClient
{
    if ([self.key isEqualToString:kSearchAccountKeyNZBMatrix]) {
        return [SCNZBMatrixSearchClient client];
    } else {
        return [SCBinSearchClient client];
    }
}

- (NSArray *)possibleOrderItems
{
    if ([self.key isEqualToString:kSearchAccountKeyNZBMatrix]) {
        return @[@(SCSearchOrderingScopeBarItemHits), @(SCSearchOrderingScopeBarItemDate), @(SCSearchOrderingScopeBarItemSize), @(SCSearchOrderingScopeBarItemName)];
    } else {
        return @[@(SCSearchOrderingScopeBarItemDate), @(SCSearchOrderingScopeBarItemSize), @(SCSearchOrderingScopeBarItemName)];
    }
}

@end