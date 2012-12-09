//
//  SCBindingTextFieldTableViewCell.m
//  SABnzbdClient
//
//  Created by Michael Voong on 10/03/2012.
//  Copyright (c) 2012 Michael Voong. All rights reserved.
//

#import "SCBindingTextFieldTableViewCell.h"

@interface SCBindingTextFieldTableViewCell ()

@property (nonatomic, strong, readwrite) UITextField *textField;

- (void)updateObjectValue;

@end

@implementation SCBindingTextFieldTableViewCell

static const CGFloat kBindingTextTextLabelWidth = 110.0f;

@synthesize textField = _textField;
@synthesize bindingTextType = _bindingTextType;
@synthesize textInputRestriction = _textInputRestriction;

- (void)setup
{
    [super setup];

    CGRect textFieldFrame = UIEdgeInsetsInsetRect(self.contentView.bounds, UIEdgeInsetsMake(0, kBindingTextTextLabelWidth + 14, 0, 10));
    self.textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.textColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.textField addTarget:self action:@selector(updateObjectValue)forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textField];
}

- (void)updateValueFromObject
{
    [super updateValueFromObject];

    NSObject *object = [self.bindObject valueForKeyPath:self.bindKeyPath];

    switch (self.bindingTextType) {
        case BindingTextTypeString:
            self.textField.text = (NSString *)object;
            break;
        case BindingTextTypeNumber:
            self.textField.text = [(NSNumber *) object stringValue];
            break;
        default:
            break;
    }
}

- (void)updateObjectValue
{
    switch (self.bindingTextType) {
        case BindingTextTypeString: {
            [self.bindObject setValue:self.textField.text forKeyPath:self.bindKeyPath];
            break;
        }
        case BindingTextTypeNumber: {
            static NSNumberFormatter *formatter;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                              formatter = [[NSNumberFormatter alloc] init];
                              [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                          });

            NSNumber *newNumber = [formatter numberFromString:self.textField.text];
            [self.bindObject setValue:newNumber forKey:self.bindKeyPath];

            break;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (self.textInputRestriction == TextInputRestrictionHostname) {
        static NSString *regex = @"([a-zA-Z0-9\\.\\-]*)";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

        return [predicate evaluateWithObject:newString];
    }

    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect titleFrame = self.textLabel.frame;
    titleFrame.size.width = kBindingTextTextLabelWidth;
    self.textLabel.frame = titleFrame;
}

@end