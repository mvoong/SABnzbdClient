//
//  SCCoreGraphicsUtils.m
//  SABnzbdClient
//
//  Created by Michael Voong on 13/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCCoreGraphicsUtils.h"

CGRect CGRectModifyX(CGRect rect, CGFloat value)
{
    return CGRectMake(value, rect.origin.y, rect.size.width, rect.size.height);
}

CGRect CGRectModifyY(CGRect rect, CGFloat value)
{
    return CGRectMake(rect.origin.x, value, rect.size.width, rect.size.height);
}

CGRect CGRectModifyWidth(CGRect rect, CGFloat value)
{
    return CGRectMake(rect.origin.x, rect.origin.y, value, rect.size.height);
}

CGRect CGRectModifyHeight(CGRect rect, CGFloat value)
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, value);
}