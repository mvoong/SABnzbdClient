//
//  SCBaseDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCBaseDataSource;

@protocol SCBaseDataSourceDelegate <NSObject>

@optional
- (void)baseDataSourceDidSucceed:(SCBaseDataSource *)dataSource;
- (void)baseDataSource:(SCBaseDataSource *)dataSource didFailWithError:(NSString *)errorDescription;
- (void)baseDataSourceDidStartLoading:(SCBaseDataSource *)dataSource;
- (void)baseDataSourceDidStopLoading:(SCBaseDataSource *)dataSource;

@end

@interface SCBaseDataSource : NSObject

@property (nonatomic, weak) IBOutlet id<SCBaseDataSourceDelegate> delegate;
@property (nonatomic, assign, getter = isStale) BOOL stale;

- (void)setup;
- (void)loadData;
- (void)didFinishLoading;
- (void)didSucceedLoading;
- (void)didFailWithLocalisedError:(NSString *)error;
- (void)stopLoadingData;
- (void)startTrackingStaleIndicationAgainstObject:(NSObject *)object dateKeyPath:(NSString *)dateKeyPath staleAgeSeconds:(NSTimeInterval)seconds;
- (void)stopTrackingStaleIndication;

@end
