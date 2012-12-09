//
//  SCSABnzbdClient.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerClient.h"
#import "SCDownloadItem.h"

typedef enum {
    SCSABnzbdItemPriorityDefault = -100,
    SCSABnzbdItemPriorityPaused = -2,
    SCSABnzbdItemPriorityLow = -1,
    SCSABnzbdItemPriorityNormal = 0,
    SCSABnzbdItemPriorityHigh = 1
} SCSABnzbdItemPriority;

@interface SCSABnzbdClient : AFHTTPClient

@property (nonatomic, strong) SCServer *server;

+ (id)clientWithServer:(SCServer *)server;
- (NSOperation *)startStatusRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startHistoryRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startDownloadRequestWithURL:(NSURL *)downloadURL name:(NSString *)name category:(SCCategory *)category success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startSwitchRequestWithItem:(SCDownloadItem *)item toIndex:(NSUInteger)index success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startRemoveRequestWithNZBID:(NSString *)nzbID mode:(NSString *)mode success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startPauseRequestWithSuccess:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startConfigSetRequestWithName:(NSString *)name value:(NSString *)value success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startChangeRequestForMode:(NSString *)mode value1:(NSString *)value1 value2:(NSString *)value2 success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
- (NSOperation *)startPriorityChangeRequestForNzbId:(NSString *)nzbId priority:(SCSABnzbdItemPriority)priority success:(void (^)(NSString *apiError))successBlock failure:(void (^)(NSError *error))failureBlock;
@end
