//
//  SCServer+Additions.m
//  SABnzbdClient
//
//  Created by Michael Voong on 14/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCServer+Additions.h"

@implementation SCServer (Additions)

+ (SCServer *)activeServer
{
    return [SCServer findFirstByAttribute:@"active" withValue:[NSNumber numberWithBool:YES]];
}

@end
