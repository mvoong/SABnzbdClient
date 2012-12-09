//
//  SCBaseDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBaseDataSource.h"

@interface SCBaseDataSource ()

@property (nonatomic, assign) NSTimeInterval staleAgeSeconds;
@property (nonatomic, strong) NSString *staleTrackingKeyPath;
@property (nonatomic, strong) NSObject *staleTrackingObject;

@end

@implementation SCBaseDataSource

- (id)init
{
    self = [super init];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)setup
{
}

- (void)loadData
{
    if ([self.delegate respondsToSelector:@selector(baseDataSourceDidStartLoading:)])
        [self.delegate baseDataSourceDidStartLoading:self];
}

- (void)didSucceedLoading
{
    [self didFinishLoading];
    
    if ([self.delegate respondsToSelector:@selector(baseDataSourceDidSucceed:)])
        [self.delegate baseDataSourceDidSucceed:self];
}

- (void)didFinishLoading
{
    if ([self.delegate respondsToSelector:@selector(baseDataSourceDidStopLoading:)])
        [self.delegate baseDataSourceDidStopLoading:self];
}

- (void)didFailWithLocalisedError:(NSString *)error
{
    [self didFinishLoading];
    
    if ([self.delegate respondsToSelector:@selector(baseDataSource:didFailWithError:)])
        [self.delegate  baseDataSource:self didFailWithError:error];
}

- (void)stopLoadingData
{
}

- (void)startTrackingStaleIndicationAgainstObject:(NSObject *)object dateKeyPath:(NSString *)dateKeyPath staleAgeSeconds:(NSTimeInterval)seconds
{
    self.staleTrackingKeyPath = dateKeyPath;
    self.staleTrackingObject = object;
    self.staleAgeSeconds = seconds;
    [object addObserver:self forKeyPath:dateKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [self indicateStaleDataIfLastUpdatedDate:[object valueForKeyPath:dateKeyPath] isBeforeAgeSeconds:seconds];
}

- (void)stopTrackingStaleIndication
{
    [self.staleTrackingObject removeObserver:self forKeyPath:self.staleTrackingKeyPath];
    self.staleTrackingKeyPath = nil;
    self.staleTrackingObject = nil;
    self.staleAgeSeconds = 0;
    self.stale = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.staleTrackingObject && [keyPath isEqualToString:self.staleTrackingKeyPath]) {
        [self indicateStaleDataIfLastUpdatedDate:[object valueForKeyPath:self.staleTrackingKeyPath] isBeforeAgeSeconds:self.staleAgeSeconds];
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)indicateStaleDataIfLastUpdatedDate:(NSDate *)date isBeforeAgeSeconds:(NSTimeInterval)seconds
{
    self.stale = !date || ABS([date timeIntervalSinceNow]) > seconds;
}

@end