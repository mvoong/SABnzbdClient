//
//  SCScriptActionSheetPickerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 23/09/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCScriptActionSheetPickerDataSource.h"
#import "SCDownloadItem.h"
#import "SCScript.h"

@interface SCScriptActionSheetPickerDataSource ()

@property (nonatomic, strong) NSArray *scripts;

@end

@implementation SCScriptActionSheetPickerDataSource

- (id)initWithDelegate:(id<SCScriptSelectionViewDelegate>)delegate downloadItem:(SCDownloadItem *)item
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        
        self.scripts = [SCScript findAllSortedBy:@"name" ascending:YES];
        
        // Preselect
        [self.scripts enumerateObjectsUsingBlock:^(SCScript *obj, NSUInteger idx, BOOL *stop) {
            if ([item.script isEqualToString:obj.name]) {
                [self.view selectRow:idx inComponent:0 animated:NO];
                *stop = YES;
            }
        }];
    }
    
    return self;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.scripts count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self.scripts objectAtIndex:row] name];
}

- (void)donePressed
{
    NSUInteger row = [self.view selectedRowInComponent:0];
    [self.delegate scriptActionSheetViewDidSelectScript:[[self.scripts objectAtIndex:row] name]];
}

@end
