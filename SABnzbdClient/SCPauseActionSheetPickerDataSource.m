//
//  SCPauseActionSheetPickerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCPauseActionSheetPickerDataSource.h"
#import "NSString+Utils.h"

@interface SCPauseActionSheetPickerDataSource ()

@property (nonatomic, strong) NSArray *pauseDurations;

@end

@implementation SCPauseActionSheetPickerDataSource

@synthesize pauseDurations = _pauseDurations;
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<SCPauseSelectionViewDelegate>)delegate
{
    self = [super init];

    if (self) {
        self.delegate = delegate;
        self.pauseDurations = [NSArray arrayWithObjects:
                               [NSNumber numberWithInteger:-1],
                               [NSNumber numberWithInteger:5],
                               [NSNumber numberWithInteger:10],
                               [NSNumber numberWithInteger:15],
                               [NSNumber numberWithInteger:30],
                               [NSNumber numberWithInteger:60],
                               [NSNumber numberWithInteger:60 * 2],
                               [NSNumber numberWithInteger:60 * 3],
                               [NSNumber numberWithInteger:60 * 4],
                               [NSNumber numberWithInteger:60 * 5],
                               [NSNumber numberWithInteger:60 * 6],
                               [NSNumber numberWithInteger:60 * 7],
                               [NSNumber numberWithInteger:60 * 8],
                               [NSNumber numberWithInteger:60 * 9],
                               [NSNumber numberWithInteger:60 * 10],
                               nil];
    }

    return self;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pauseDurations count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
        return NSLocalizedString(@"DONT_PAUSE_KEY", nil);

    NSUInteger pauseDuration = [[self.pauseDurations objectAtIndex:row - 1] integerValue];

    if (pauseDuration == -1)
        return NSLocalizedString(@"PAUSE_INDEFINITELY_KEY", nil);
    else
        return [NSString stringFromDuration:pauseDuration * 60];
}

- (void)donePressed
{
    NSUInteger row = [self.view selectedRowInComponent:0];

    if (row == 0)
        [self.delegate pauseSelectionViewDidClearPauseTime];
    else
        [self.delegate pauseSelectionViewDidSelectPauseTime:[[self.pauseDurations objectAtIndex:row - 1] integerValue] * 60];
}

@end