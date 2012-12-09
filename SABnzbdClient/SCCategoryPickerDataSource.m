//
//  SCCategoryPickerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCCategoryPickerDataSource.h"
#import "SCCategory.h"
#import "SCServer.h"

@interface SCCategoryPickerDataSource ()

/**
 Array of SCCategory objects
 */
@property (nonatomic, strong) NSArray *categories;

@end

@implementation SCCategoryPickerDataSource

- (id)initWithDelegate:(id<SCCategoryPickerDataSourceDelegate>)delegate server:(SCServer *)server
{
    self = [super init];

    if (self) {
        self.delegate = delegate;

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"server = %@", server];
        self.categories = [SCCategory findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
        
        // Restore previously selected category
        SCCategory *selectedCategory = [[SCApplicationModel sharedModel] selectedCategory];
        if (selectedCategory) {
            [self selectRow:[self.categories indexOfObject:selectedCategory]];
        }
    }

    return self;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.categories count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.categories objectAtIndex:row] name];
}

- (void)donePressed
{
    NSUInteger row = [self.view selectedRowInComponent:0];
    SCCategory *category = [self.categories objectAtIndex:row];
    [self.delegate categoryPickerDataSource:self didPickCategory:category];
    
    [[SCApplicationModel sharedModel] setSelectedCategory:category];
}

@end