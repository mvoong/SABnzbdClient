//
//  SCHistoryItem+JSON.h
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCHistoryItem.h"

@interface SCHistoryItem (JSON)

- (void)populateFromJSON:(NSDictionary *)json;

@end
