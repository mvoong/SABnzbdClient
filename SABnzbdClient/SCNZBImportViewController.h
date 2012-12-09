//
//  SCNZBImportViewController.h
//  SABnzbdClient
//
//  Created by Michael Voong on 30/05/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseViewController.h"
#import "SCSABnzbdClient.h"
#import "SCCategoryPickerDataSource.h"

@class SCServerPickerDataSource;

@interface SCNZBImportViewController : SCBaseViewController <UIPickerViewDelegate, SCCategoryPickerDataSourceDelegate>

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) IBOutlet SCServerPickerDataSource *dataSource;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UILabel *urlTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *urlLabel;
@property (nonatomic, retain) IBOutlet UILabel *sabnzbdServerLabel;

- (IBAction)add;

@end
