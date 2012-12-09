//
//  SCPriorityActionSheetPickerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 23/09/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCPriorityActionSheetPickerDataSource.h"

@interface SCPriorityActionSheetPickerDataSource ()

@property (nonatomic, strong) NSArray *priorities;

@end

@implementation SCPriorityActionSheetPickerDataSource

+ (NSString *)stringForPriority:(SCSABnzbdItemPriority)priority
{
    switch (priority) {
        case SCSABnzbdItemPriorityDefault:
            return @"Default";
        case SCSABnzbdItemPriorityHigh:
            return @"High";
        case SCSABnzbdItemPriorityNormal:
            return @"Normal";
        case SCSABnzbdItemPriorityLow:
            return @"Low";
        case SCSABnzbdItemPriorityPaused:
            return @"Paused";
        default:
            break;
    }
}

- (id)initWithDelegate:(id<SCPrioritySelectionViewDelegate>)delegate downloadItem:(SCDownloadItem *)item
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        
        self.priorities = @[@(SCSABnzbdItemPriorityHigh), @(SCSABnzbdItemPriorityNormal), @(SCSABnzbdItemPriorityLow)];
        
        // Preselect
        [self.priorities enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
            if ([[SCPriorityActionSheetPickerDataSource stringForPriority:[obj integerValue]] isEqualToString:item.priority]) {
                [self.view selectRow:idx inComponent:0 animated:NO];
                *stop = YES;
            }
        }];
    }
    
    return self;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.priorities count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [SCPriorityActionSheetPickerDataSource stringForPriority:[[self.priorities objectAtIndex:row] integerValue]];
}

- (void)donePressed
{
    NSUInteger row = [self.view selectedRowInComponent:0];
    [self.delegate priorityActionSheetViewDidSelectPriority:[[self.priorities objectAtIndex:row] integerValue]];
}

@end


