//
//  SCBindingTextFieldTableViewCell.h
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBindingTableViewCell.h"

typedef enum {
    BindingTextTypeString,
    BindingTextTypeNumber
} BindingTextType;

typedef enum {
    TextInputRestrictionNone,
    TextInputRestrictionHostname
} TextInputRestriction;

@interface SCBindingTextFieldTableViewCell : SCBindingTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, assign) BindingTextType bindingTextType;
@property (nonatomic, assign) TextInputRestriction textInputRestriction;

@end
