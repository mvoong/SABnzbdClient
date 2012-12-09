//
//  SCAppearance.h
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ColourNameNone,
    ColourNameCellValue,
    ColourNameBarButtonItemBackground,
    ColourNameBarButtonTableBackground,
    ColourNameBarButtonTableSeparator
} ColourName;

@interface SCAppearance : NSObject

+ (void)applyAppearance;
+ (UIColor *)colourByName:(ColourName)colourName;

@end
