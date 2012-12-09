//
//  MVActionSheetPickerDataSource.h
//
//  A base class for MVActionSheetDataSource implementations that contain just a UIPickerView.
//
//  Created by Michael Voong on 09/08/2011.
//

#import <Foundation/Foundation.h>
#import "MVActionSheetDataSource.h"

@interface MVActionSheetPickerDataSource : NSObject <MVActionSheetDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

/**
 * Hack method to select row. The reason why we do this in the next run loop is that otherwise in landscape mode, the picker behaves
 * incorrectly and the selection row is not set properly. Horrible I know :(
 */
- (void)selectRow:(NSInteger)row;
- (void)selectRow:(NSInteger)row component:(NSInteger)component;

@property (nonatomic, strong) UIPickerView *view;

@end
