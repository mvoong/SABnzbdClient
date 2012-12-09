//
//  SCBindingTableViewCell.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseGroupedTableViewCell.h"

@interface SCBindingTableViewCell : SCBaseGroupedTableViewCell

@property (nonatomic, strong) NSObject *bindObject;
@property (nonatomic, strong) NSString *bindKeyPath;

+ (id)cellWithTitle:(NSString *)title bindObject:(NSObject *)bindObject bindKeyPath:(NSString *)bindKeyPath;
- (void)setup;
- (void)updateValueFromObject;
- (void)updateObjectValue;

@end
