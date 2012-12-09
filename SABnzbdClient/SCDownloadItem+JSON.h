//
//  SCDownloadItem+JSON.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadItem.h"
#import "SCStatusTransformer.h"

@interface SCDownloadItem (JSON)

- (void)populateFromJSON:(NSDictionary *)json;

@end
