//
//  SCPriorityActionSheetPickerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 23/09/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetPickerDataSource.h"
#import "SCSABnzbdClient.h"

@class SCDownloadItem;

@protocol SCPrioritySelectionViewDelegate <NSObject>

@required
- (void)priorityActionSheetViewDidSelectPriority:(SCSABnzbdItemPriority)priority;

@end

@interface SCPriorityActionSheetPickerDataSource : MVActionSheetPickerDataSource

@property (nonatomic, weak) id<SCPrioritySelectionViewDelegate> delegate;

+ (NSString *)stringForPriority:(SCSABnzbdItemPriority)priority;
- (id)initWithDelegate:(id<SCPrioritySelectionViewDelegate>)delegate downloadItem:(SCDownloadItem *)item;

@end