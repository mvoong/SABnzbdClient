//
//  SCSpeedLimitActionSheetPickerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSpeedLimitActionSheetPickerDataSource.h"
#import "NSString+Utils.h"

@interface SCSpeedLimitActionSheetPickerDataSource ()

@property (nonatomic, strong) NSArray *speedsKB;

@end

@implementation SCSpeedLimitActionSheetPickerDataSource

@synthesize speedsKB = _speedsKB;
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id<SCSpeedLimitSelectionViewDelegate>)delegate
{
    self = [super init];

    if (self) {
        self.delegate = delegate;
        static const NSUInteger kb = 1024;
        static const NSUInteger mb = kb * 1024;

        self.speedsKB = [NSArray arrayWithObjects:
                         [NSNumber numberWithInteger:50 * kb],
                         [NSNumber numberWithInteger:100 * kb],
                         [NSNumber numberWithInteger:200 * kb],
                         [NSNumber numberWithInteger:300 * kb],
                         [NSNumber numberWithInteger:400 * kb],
                         [NSNumber numberWithInteger:500 * kb],
                         [NSNumber numberWithInteger:600 * kb],
                         [NSNumber numberWithInteger:700 * kb],
                         [NSNumber numberWithInteger:800 * kb],
                         [NSNumber numberWithInteger:900 * kb],
                         [NSNumber numberWithInteger:1 * mb],
                         [NSNumber numberWithInteger:2 * mb],
                         [NSNumber numberWithInteger:3 * mb],
                         [NSNumber numberWithInteger:4 * mb],
                         [NSNumber numberWithInteger:5 * mb],
                         [NSNumber numberWithInteger:6 * mb],
                         [NSNumber numberWithInteger:7 * mb],
                         [NSNumber numberWithInteger:8 * mb],
                         [NSNumber numberWithInteger:9 * mb],
                         [NSNumber numberWithInteger:10 * mb],
                         nil];
    }

    return self;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.speedsKB count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
        return NSLocalizedString(@"NO_LIMIT_KEY", nil);

    return [NSString stringFromSpeed:[[self.speedsKB objectAtIndex:row - 1] integerValue]];
}

- (void)donePressed
{
    NSUInteger row = [self.view selectedRowInComponent:0];

    if (row > 0) {
        NSUInteger speed = [[self.speedsKB objectAtIndex:row - 1] integerValue] / 1024;
        [self.delegate speedLimitSelectionViewDidSelectSpeed:speed];
    } else {
        [self.delegate speedLimitSelectionViewDidClearSpeedLimit];
    }
}

@end