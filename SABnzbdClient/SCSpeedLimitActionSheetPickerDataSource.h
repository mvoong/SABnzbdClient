//
//  SCSpeedLimitActionSheetPickerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetPickerDataSource.h"

@protocol SCSpeedLimitSelectionViewDelegate <NSObject>

@required
- (void)speedLimitSelectionViewDidSelectSpeed:(NSUInteger)speedKB;
- (void)speedLimitSelectionViewDidClearSpeedLimit;

@end

@interface SCSpeedLimitActionSheetPickerDataSource : MVActionSheetPickerDataSource

@property (nonatomic, weak) id<SCSpeedLimitSelectionViewDelegate> delegate;

- (id)initWithDelegate:(id<SCSpeedLimitSelectionViewDelegate>)delegate;

@end
