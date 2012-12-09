//
//  SCURLSchemeHandler.h
//  SABnzbdClient
//
//  Created by Michael Voong on 30/05/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCURLSchemeHandler : NSObject

+ (BOOL)handleURL:(NSURL *)url withApplication:(UIApplication *)application;

@end
