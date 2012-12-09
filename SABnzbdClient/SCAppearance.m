//
//  SCAppearance.m
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCAppearance.h"

@interface SCAppearance ()

+ (UIColor *)colourFromCache:(ColourName)colourName;
+ (void)addColourToCache:(ColourName)colourName colour:(UIColor *)colour;

@end

@implementation SCAppearance

static NSMutableDictionary *colourDictionary;

+ (void)initialize
{
    [super initialize];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      colourDictionary = [NSMutableDictionary dictionary];
                  });
}

+ (void)applyAppearance
{
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UITableView appearance] setBackgroundColor:[SCAppearance colourByName:ColourNameBarButtonTableBackground]];
}

+ (UIColor *)colourByName:(ColourName)colourName
{
    UIColor *colour = [SCAppearance colourFromCache:colourName];

    if (!colour) {
        switch (colourName) {
            case ColourNameCellValue:
                colour = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
                break;
            case ColourNameBarButtonItemBackground:
                colour = [UIColor colorWithWhite:0.2 alpha:1.0f];
                break;
            case ColourNameBarButtonTableBackground:
                colour = [UIColor colorWithWhite:0.95 alpha:1.0f];
                break;
            case ColourNameBarButtonTableSeparator:
                colour = [UIColor colorWithWhite:0.85 alpha:1.0f];
                break;
            default:
                break;
        }

        if (colour)
            [self addColourToCache:colourName colour:colour];
    }

    return colour;
}

+ (UIColor *)colourFromCache:(ColourName)colourName
{
    NSNumber *colourNumber = [NSNumber numberWithInteger:colourName];

    return [colourDictionary objectForKey:colourNumber];
}

+ (void)addColourToCache:(ColourName)colourName colour:(UIColor *)colour
{
    [colourDictionary setObject:colour forKey:[NSNumber numberWithInteger:colourName]];
}

@end