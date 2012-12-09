//
//  SCSearchFilterItem+Convenience.h
//  SABnzbdClient
//
//  Created by Michael Voong on 21/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchFilterItem.h"

@interface SCSearchFilterItem (Convenience)

+ (SCSearchFilterItem *)findItemForAccount:(SCSearchAccount *)account category:(SCSearchFilterCategory *)category;

@end
