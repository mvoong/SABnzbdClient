//
//  SCServerPickerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 30/05/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerPickerDataSource.h"
#import "SCServer.h"

@interface SCServerPickerDataSource ()

@property (nonatomic, retain, readwrite) NSArray *servers;

@end

@implementation SCServerPickerDataSource

@synthesize servers = _servers;

- (void)load
{
    self.servers = [SCServer findAllSortedBy:@"name" ascending:YES];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.servers count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end