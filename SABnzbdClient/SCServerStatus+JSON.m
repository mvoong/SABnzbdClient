//
//  SCServerStatus+JSON.m
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServerStatus+JSON.h"

@implementation SCServerStatus (JSON)

- (void)populateFromJSON:(NSDictionary *)json
{
    self.currentSpeed = [NSDecimalNumber decimalNumberWithString:[json objectForKey:@"kbpersec"]];

    BOOL paused = [[json objectForKey:@"paused"] integerValue] == 1;
    self.paused = [NSNumber numberWithBool:paused];

    if ([[json objectForKey:@"noofslots"] integerValue] == 0) {
        self.status = NSLocalizedString(@"EMPTY_QUEUE_KEY", nil);
    } else {
        self.status = [json objectForKey:@"status"];
    }
}

@end