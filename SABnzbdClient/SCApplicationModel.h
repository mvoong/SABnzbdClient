//
//  SCApplicationModel.h
//  SABnzbdClient
//
//  Created by Michael Voong on 21/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCCategory.h"

@interface SCApplicationModel : NSObject

/**
 The latest category selected during this application session
 */
@property (nonatomic, strong) SCCategory *selectedCategory;

+ (SCApplicationModel *)sharedModel;

@end
