//
//  SCSearchResultDetailViewControllerDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCSearchResultDetailViewControllerDataSource.h"
#import "SCNZBResult.h"
#import "NSString+Utils.h"
#import "SCItemDetailCell.h"
#import "SCSearchAccount.h"
#import "UIImageView+AFNetworking.h"
#import "SCActionCell.h"

@implementation SCSearchResultDetailViewControllerDataSource

- (void)setResult:(id<SCNZBItem>)result
{
    if (result == _result)
        return;
    
   _result = result;

    if (result) {
        NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:8];
        
        if ([result category])
            [attributes addObject:@"SEARCH_RESULT_CATEGORY_KEY"];
        
        if ([result size])
            [attributes addObject:@"SEARCH_RESULT_SIZE_KEY"];
        
        if ([result usenetDate])
            [attributes addObject:@"SEARCH_RESULT_USENET_DATE_KEY"];
        
        if ([result indexDate])
            [attributes addObject:@"SEARCH_RESULT_INDEX_DATE_KEY"];
        
        if ([result group])
            [attributes addObject:@"SEARCH_RESULT_GROUP_KEY"];
        
        if ([result hits])
            [attributes addObject:@"SEARCH_RESULT_HITS_KEY"];
        
        if ([result language])
            [attributes addObject:@"SEARCH_RESULT_LANGUAGE_KEY"];
        
        if ([result imdbTitleID])
            [attributes addObject:@"SEARCH_RESULT_LAUNCH_IMDB_KEY"];
        
        self.attributes = attributes;
    }
}

- (void)loadData
{
    [super loadData];
    [self.tableView reloadData];
    
    if ([self.result respondsToSelector:@selector(imageURL)]) {
        [self loadImage];
    }
    
    [self didFinishLoading];
}

- (void)loadImage
{
    if ([self.result.imageURL length]) {
        NSURL *imageUrl = [NSURL URLWithString:self.result.imageURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
        [self.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * request, NSHTTPURLResponse * response, UIImage * image) {
             [self.tableView reloadData];
         } failure:^(NSURLRequest * request, NSHTTPURLResponse * response, NSError * error) {
         }];
    }
}

- (BOOL)hasImage
{
    return self.imageView.image != nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return [self.attributes count] + ([self hasImage] ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self hasImage] && indexPath.row == 0) {
        return self.imageCell;
    } else {
        if ([self hasImage])
            indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        
        NSString *attribute = [self.attributes objectAtIndex:indexPath.row];
        NSObject *data = [self dataForKeyAtIndexPath:indexPath];
        
        if ([attribute isEqualToString:@"SEARCH_RESULT_LAUNCH_IMDB_KEY"]) {
            return [self cellForLaunchIMDBForTable:tableView];
        } else {
            return [self descriptionCellForTableView:tableView attribute:attribute data:data];
        }
    }
}

- (UITableViewCell *)descriptionCellForTableView:(UITableView *)tableView attribute:(NSString *)attribute data:(NSObject *)data
{
    static NSString *cellId = @"SCItemDetailCell";
    SCItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [SCItemDetailCell loadFromNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Default to none
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLabel.text = NSLocalizedString(attribute, nil);
    
    
    if ([data isKindOfClass:[NSString class]]) {
        cell.descriptionLabel.text = [data description];
    } else if ([data isKindOfClass:[NSDate class]]) {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterMediumStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
        });
        
        cell.descriptionLabel.text = [dateFormatter stringFromDate:(NSDate *)data];
    } else if ([data isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)data;
        
        if ([attribute isEqualToString:@"SEARCH_RESULT_SIZE_KEY"]) {
            cell.descriptionLabel.text = [NSString stringFromFileSize:[number longLongValue]];
        } else if ([attribute isEqualToString:@"SEARCH_RESULT_NFO_KEY"]) {
            //                if ([number boolValue]) {
            //                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            //                }
            cell.descriptionLabel.text = NSLocalizedString([number boolValue] ? @"YES_KEY" : @"NO_KEY", nil);
        } else {
            cell.descriptionLabel.text = [number stringValue];
        }
    }
    
    return cell;
}

- (UITableViewCell *)cellForLaunchIMDBForTable:(UITableView *)tableView
{
    static NSString *cellId = @"IMDBCell";
    SCActionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [SCActionCell loadFromNib];
        cell.titleLabel.text = NSLocalizedString(@"SEARCH_RESULT_LAUNCH_IMDB_KEY", nil);
    }
    
    return cell;
}

- (NSObject *)dataForKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *attribute = [self.attributes objectAtIndex:indexPath.row];

    if ([attribute isEqualToString:@"SEARCH_RESULT_NAME_KEY"])
        return [self.result name];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_SIZE_KEY"])
        return [self.result size];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_INDEX_DATE_KEY"])
        return [self.result indexDate];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_USENET_DATE_KEY"])
        return [self.result usenetDate];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_CATEGORY_KEY"])
        return [self.result category];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_GROUP_KEY"])
        return [self.result group];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_COMMENTS_KEY"])
        return [self.result comments];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_HITS_KEY"])
        return [self.result hits];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_NFO_KEY"])
        return [self.result hasNFO];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_LANGUAGE_KEY"])
        return [self.result language];
    else if ([attribute isEqualToString:@"SEARCH_RESULT_REGION_KEY"])
        return [self.result region];

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"NZB_DETAILS_KEY", nil);
}

@end