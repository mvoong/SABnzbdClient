//
//  SCServerStatus+JSON.h
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerStatus.h"

@interface SCServerStatus (JSON)

- (void)populateFromJSON:(NSDictionary *)json;

@end
