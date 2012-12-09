//
//  SCCategoryActionSheetPickerDataSource
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetPickerDataSource.h"

@class SCCategory;
@class SCDownloadItem;

@protocol SCCategorySelectionViewDelegate <NSObject>

@required
- (void)categorySelectionViewDidSelectCategory:(SCCategory *)category;

@end

@interface SCCategoryActionSheetPickerDataSource : MVActionSheetPickerDataSource

@property (nonatomic, weak) id<SCCategorySelectionViewDelegate> delegate;

- (id)initWithDelegate:(id<SCCategorySelectionViewDelegate>)delegate downloadItem:(SCDownloadItem *)downloadItem;

@end
