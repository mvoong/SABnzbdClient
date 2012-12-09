//
//  SCApplicationModel.m
//  SABnzbdClient
//
//  Created by Michael Voong on 21/10/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCApplicationModel.h"

@implementation SCApplicationModel

+ (SCApplicationModel *)sharedModel
{
    static SCApplicationModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SCApplicationModel alloc] init];
    });
    
    return model;
}

@end
