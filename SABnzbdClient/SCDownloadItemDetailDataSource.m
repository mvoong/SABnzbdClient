//
//  SCDownloadItemDetailDataSource.m
//  SABnzbdClient
//
//  Created by Michael Voong on 03/04/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCDownloadItemDetailDataSource.h"
#import "SCItemDetailCell.h"
#import "SCDownloadItem.h"
#import "SCCategory.h"
#import "SCScript.h"

@implementation SCDownloadItemDetailDataSource

/**
 category
 priority
 script
 age
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SCItemDetailCell";
    SCItemDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [SCItemDetailCell loadFromNib];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = NSLocalizedString(@"SEARCH_RESULT_CATEGORY_KEY", nil);
            cell.descriptionLabel.text = self.downloadItem.category.name;
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = NSLocalizedString(@"PRIORITY", nil);
            cell.descriptionLabel.text = self.downloadItem.priority;
            break;
        case 2:
            cell.accessoryType = [SCScript countOfEntities] > 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
            cell.titleLabel.text = NSLocalizedString(@"SCRIPT", nil);
            cell.descriptionLabel.text = self.downloadItem.script;
            break;
        case 3:
            cell.titleLabel.text = NSLocalizedString(@"AGE", nil);
            cell.descriptionLabel.text = self.downloadItem.averageAge;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        default:
            break;
    }
    
    cell.selectionStyle = cell.accessoryType == UITableViewCellAccessoryNone ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

@end