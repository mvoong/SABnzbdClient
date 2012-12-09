//
//  SCScriptActionSheetPickerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 23/09/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetPickerDataSource.h"

@class SCDownloadItem;

@protocol SCScriptSelectionViewDelegate <NSObject>

@required
- (void)scriptActionSheetViewDidSelectScript:(NSString *)script;

@end

@interface SCScriptActionSheetPickerDataSource : MVActionSheetPickerDataSource

@property (nonatomic, weak) id<SCScriptSelectionViewDelegate> delegate;

- (id)initWithDelegate:(id<SCScriptSelectionViewDelegate>)delegate downloadItem:(SCDownloadItem *)item;

@end
