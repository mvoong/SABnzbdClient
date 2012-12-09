//
//  SCSearchResultDetailViewControllerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseTableViewDataSource.h"

@class SCNZBResult;

@interface SCSearchResultDetailViewControllerDataSource : SCBaseTableViewDataSource

@property (nonatomic, strong) NSArray *attributes;
@property (nonatomic, strong) id<SCNZBItem> result;
@property (strong, nonatomic) IBOutlet UITableViewCell *imageCell;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (NSObject *)dataForKeyAtIndexPath:(NSIndexPath *)indexPath;

@end
