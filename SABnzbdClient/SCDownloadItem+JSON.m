//
//  SCDownloadItem+JSON.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadItem+JSON.h"
#import "SCDownloadItem.h"
#import "SCCategory.h"
#import "NSString+Utils.h"
#import "SCServer.h"

@implementation SCDownloadItem (JSON)

- (void)populateFromJSON:(NSDictionary *)json
{
    self.status = [NSNumber numberWithInteger:[SCStatusTransformer downloadStatusForString:[json objectForKey:@"status"]]];
    self.index = [json objectForKey:@"index"];
    self.eta = [json objectForKey:@"eta"];
    self.timeRemaining = [json objectForKey:@"timeleft"];
    self.averageAge = [json objectForKey:@"avg_age"];
    self.script = [json objectForKey:@"script"];
    self.itemId = [json objectForKey:@"msgid"];
    self.sizeMB = [NSDecimalNumber decimalNumberWithString:[json objectForKey:@"mb"]];
    self.sizeRemainingMB = [NSDecimalNumber decimalNumberWithString:[json objectForKey:@"mbleft"]];
    self.filename = [[[json objectForKey:@"filename"]
                      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                     cleanupFilenameString];
    self.priority = [json objectForKey:@"priority"];

    SCCategory *category = [SCCategory findFirstWithPredicate:[NSPredicate predicateWithFormat:@"server = %@ and name = %@",
                                                               self.server,
                                                               [json objectForKey:@"cat"]]];

    if (!category) {
        category = [SCCategory createEntity];
        category.name = [json objectForKey:@"cat"];
        [self.server addCategoriesObject:category];
    }

    self.category = category;

    self.nzbId = [json objectForKey:@"nzo_id"];
    self.unpackOperations = [NSNumber numberWithInteger:[[json objectForKey:@"unpackopts"] integerValue]];
}

@end