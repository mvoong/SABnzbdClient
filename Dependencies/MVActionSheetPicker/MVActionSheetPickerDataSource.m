//
//  MVActionSheetPickerDataSource.m
//
//  Created by Michael Voong on 09/08/2011.
//

#import "MVActionSheetPickerDataSource.h"

@interface MVActionSheetPickerDataSource ()

- (void)performSelectRow:(NSNumber *)row;

@end

@implementation MVActionSheetPickerDataSource

@synthesize view;

#pragma mark - Initialisation

- (id)init
{
    self = [super init];

    if (self) {
        self.view = [[UIPickerView alloc] init];
        self.view.delegate = self;
        self.view.dataSource = self;
        self.view.showsSelectionIndicator = YES;
    }

    return self;
}

#pragma mark - MVActionSheetController methods

- (CGFloat)preferredHeight
{
    // Default height of UIPickerView
    return 216.0f;
}

#pragma mark - Row selection hack

- (void)selectRow:(NSInteger)row
{
    [self selectRow:row component:0];
}

- (void)selectRow:(NSInteger)row component:(NSInteger)component
{
    if (row < [self.view.dataSource pickerView:self.view numberOfRowsInComponent:component]) {
        [self performSelector:@selector(performSelectRow:)withObject:[NSNumber numberWithInteger:row] afterDelay:0];
    }
}

- (void)performSelectRow:(NSNumber *)row
{
    [self.view selectRow:[row integerValue] inComponent:0 animated:NO];
}

#pragma mark - UIPicker delegate and datasource stubs

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return nil;
}

@end