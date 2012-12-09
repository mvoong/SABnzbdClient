//
//  SCHistoryItem+JSON.m
//  SABnzbdClient
//
//  Created by Michael Voong on 22/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCHistoryItem+JSON.h"
#import "SCStatusTransformer.h"

@implementation SCHistoryItem (JSON)

- (void)populateFromJSON:(NSDictionary *)json
{
    self.nzbId = [json objectForKey:@"nzo_id"];
    self.status = [NSNumber numberWithInteger:[SCStatusTransformer downloadStatusForString:[json objectForKey:@"status"]]];
    self.category = [json objectForKey:@"category"] == [NSNull null] ? nil : [json objectForKey:@"category"];
    self.failMessage = [json objectForKey:@"fail_message"];
    self.name = [json objectForKey:@"name"];
    self.actionLine = [json objectForKey:@"action_line"];
    self.size = [json objectForKey:@"size"];
    self.completed = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"completed"] longLongValue]];
}

@end