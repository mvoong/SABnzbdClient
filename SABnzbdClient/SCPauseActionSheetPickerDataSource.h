//
//  SCPauseActionSheetPickerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetPickerDataSource.h"

@protocol SCPauseSelectionViewDelegate <NSObject>

@required
- (void)pauseSelectionViewDidSelectPauseTime:(NSTimeInterval)pauseTimeSeconds;
- (void)pauseSelectionViewDidClearPauseTime;

@end

@interface SCPauseActionSheetPickerDataSource : MVActionSheetPickerDataSource

@property (nonatomic, weak) id<SCPauseSelectionViewDelegate> delegate;

- (id)initWithDelegate:(id<SCPauseSelectionViewDelegate>)delegate;

@end
