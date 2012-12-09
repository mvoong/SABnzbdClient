//
//  SCCategoryPickerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 25/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "MVActionSheetPickerDataSource.h"

@class SCCategoryPickerDataSource;
@class SCCategory;
@class SCServer;

@protocol SCCategoryPickerDataSourceDelegate <NSObject>

@required
- (void)categoryPickerDataSource:(SCCategoryPickerDataSource *)dataSource didPickCategory:(SCCategory *)category;

@end

@interface SCCategoryPickerDataSource : MVActionSheetPickerDataSource

@property (nonatomic, weak) id<SCCategoryPickerDataSourceDelegate> delegate;

- (id)initWithDelegate:(id<SCCategoryPickerDataSourceDelegate>)delegate server:(SCServer *)server;

@end
