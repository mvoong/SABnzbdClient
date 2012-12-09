//
//  SCSearchFilterItem+Convenience.m
//  SABnzbdClient
//
//  Created by Michael Voong on 21/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchFilterItem+Convenience.h"
#import "SCModels.h"

@implementation SCSearchFilterItem (Convenience)

+ (SCSearchFilterItem *)findItemForAccount:(SCSearchAccount *)account category:(SCSearchFilterCategory *)category
{
    for (SCSearchFilterItem *item in account.filterItems) {
        if (item.category == category)
            return item;
    }

    return nil;
}

@end