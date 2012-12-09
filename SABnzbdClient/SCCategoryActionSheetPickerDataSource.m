//
//  SCCategoryActionSheetPickerDataSource
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCCategoryActionSheetPickerDataSource.h"
#import "SCCategory.h"
#import "SCDownloadItem.h"

@interface SCCategoryActionSheetPickerDataSource ()

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) SCDownloadItem *downloadItem;

@end

@implementation SCCategoryActionSheetPickerDataSource

- (id)initWithDelegate:(id<SCCategorySelectionViewDelegate>)delegate downloadItem:(SCDownloadItem *)downloadItem
{
    self = [super init];

    if (self) {
        self.delegate = delegate;
        self.downloadItem = downloadItem;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"server = %@", self.downloadItem.server];
        self.categories = [SCCategory findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
        
        [self.view selectRow:[self.categories indexOfObject:downloadItem.category] inComponent:0 animated:NO];
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
    [self.delegate categorySelectionViewDidSelectCategory:[self.categories objectAtIndex:row]];
}

@end