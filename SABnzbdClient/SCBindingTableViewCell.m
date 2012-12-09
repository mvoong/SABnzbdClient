//
//  SCBindingTableViewCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBindingTableViewCell.h"

@implementation SCBindingTableViewCell

@synthesize bindObject = _bindObject;
@synthesize bindKeyPath = _bindKeyPath;

+ (id)cellWithTitle:(NSString *)title bindObject:(NSObject *)bindObject bindKeyPath:(NSString *)bindKeyPath
{
    SCBindingTableViewCell *cell = [[[self class] alloc] init];
    cell.bindObject = bindObject;
    cell.bindKeyPath = bindKeyPath;
    cell.textLabel.text = title;
    return cell;
}

- (void)setup
{
    [super setup];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateValueFromObject
{
}

- (void)updateObjectValue
{
}

@end