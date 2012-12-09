//
//  SCSearchAccount+Additions.h
//  SABnzbdClient
//
//  Created by Michael Voong on 24/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchAccount.h"

@class SCSearchClient;

@interface SCSearchAccount (Additions)

+ (SCSearchAccount *)searchAccountWithKey:(NSString *)key;
- (BOOL)hasSettings;

/**
 Settings have been populated by user and this search account can be used.
 */
- (BOOL)isValid;

- (UIViewController *)settingsViewController;
- (SCSearchClient *)searchClient;
- (NSArray *)possibleOrderItems;

@end
