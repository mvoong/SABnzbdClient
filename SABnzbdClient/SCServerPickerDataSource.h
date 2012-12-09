//
//  SCServerPickerDataSource.h
//  SABnzbdClient
//
//  Created by Michael Voong on 30/05/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

@interface SCServerPickerDataSource : NSObject <UIPickerViewDataSource>

@property (nonatomic, retain, readonly) NSArray *servers;

- (void)load;

@end
